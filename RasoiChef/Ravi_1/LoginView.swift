import SwiftUI
import Supabase
import AuthenticationServices
import UIKit
import SwiftSMTP

struct SignUpView1: View {
    var body: some View {
        Text("Sign Up View")
    }
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isShowingSignUp = false
    @Environment(\.colorScheme) var colorScheme
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 0) {
                        // Food Images Grid
                        ZStack {
                        Image("food1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height * 0.29)
                                .clipped()
                        
                       //  Overlay gradient
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .white.opacity(0.2), .white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    
                    // Main Content
                    VStack(spacing: 15) {
                        // Welcome Text
                        VStack(spacing: 10) {
                            Text("Welcome Back!")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Please login to continue")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Login Form
                        VStack(spacing: 15) {
                            // Email Field
                            TextField("Email", text: $viewModel.email)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            // Password Field with eye icon
                            HStack {
                                Group {
                                    if viewModel.showPassword {
                                        TextField("Password", text: $viewModel.password)
                                            .textContentType(.password)
                                    } else {
                            SecureField("Password", text: $viewModel.password)
                                .textContentType(.password)
                                    }
                                }
                                Button(action: { viewModel.showPassword.toggle() }) {
                                    Image(systemName: viewModel.showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                                .padding()
                                .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // Forgot Password Button
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    showForgotPassword = true
                                }
                                .foregroundColor(.accentColor)
                                .font(.subheadline)
                            }
                        }
                        
                        // Error Message
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                        
                        // Login Button
                        Button(action: {
                            Task {
                                if await viewModel.login() {
                                    viewModel.navigateToMainTabBar()
                                }
                            }
                        }) {
                            HStack {
                                Text("Login")
                                    .fontWeight(.semibold)
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.leading, 5)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.accentColor.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .disabled(viewModel.isLoading)
                        
                        // Social Login Options
                        VStack(spacing: 15) {
                            Text("Or continue with")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            HStack(spacing: 15) {
                                // System Apple Sign In Button
                                SignInWithAppleButton(
                                    .signIn,
                                    onRequest: { request in
                                        request.requestedScopes = [.fullName, .email]
                                    },
                                    onCompletion: { result in
                                        viewModel.handleAppleSignInCompletion(result)
                                    }
                                )
                                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                                .frame(height: 45)
                                .cornerRadius(15)
                            }
                            .frame(height: 45)
                            .padding(.horizontal, 40)
                        }
                        
                        Spacer(minLength: 20)
                        
                        // Sign Up Link
                        NavigationLink(destination: SignUpView(), isActive: $isShowingSignUp) {
                            HStack {
                                Text("Don't have an account?")
                                    .foregroundColor(.gray)
                                Text("Sign Up")
                                    .foregroundColor(.accentColor)
                                    .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.03)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var otp = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var message = ""
    @State private var isLoading = false
    @State private var messageColor: Color = .red
    @State private var showOTPField = false
    @State private var generatedOTP = ""
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(showOTPField ? "Reset Password" : "Verify Email")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if !showOTPField {
                    Text("Enter your email address to receive a verification code.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                } else {
                    Text("Enter the verification code and your new password.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    TextField("Verification Code", text: $otp)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    // New Password with eye button
                    HStack {
                        if showNewPassword {
                            TextField("New Password", text: $newPassword)
                                .textContentType(.newPassword)
                        } else {
                            SecureField("New Password", text: $newPassword)
                                .textContentType(.newPassword)
                        }
                        
                        Button(action: {
                            showNewPassword.toggle()
                        }) {
                            Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Confirm Password with eye button
                    HStack {
                        if showConfirmPassword {
                            TextField("Confirm Password", text: $confirmPassword)
                                .textContentType(.newPassword)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textContentType(.newPassword)
                        }
                        
                        Button(action: {
                            showConfirmPassword.toggle()
                        }) {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(messageColor)
                        .font(.footnote)
                }
                
                Button(action: {
                    Task {
                        if showOTPField {
                            await verifyOTPAndResetPassword()
                        } else {
                            await sendOTP()
                        }
                    }
                }) {
                    HStack {
                        Text(showOTPField ? "Reset Password" : "Send Verification Code")
                            .fontWeight(.semibold)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.leading, 5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .disabled(isLoading)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
    
    private func generateOTP() -> String {
        let digits = "0123456789"
        return String((0..<6).map { _ in digits.randomElement()! })
    }
    
    func verifyOTPAndResetPassword() async {
        // Validate inputs
        guard !otp.isEmpty else {
            message = "Please enter the verification code"
            messageColor = .red
            return
        }
        
        guard otp == generatedOTP else {
            message = "Invalid verification code"
            messageColor = .red
            return
        }
        
        guard !newPassword.isEmpty else {
            message = "Please enter a new password"
            messageColor = .red
            return
        }
        
        guard newPassword == confirmPassword else {
            message = "Passwords do not match"
            messageColor = .red
            return
        }
        
        guard newPassword.count >= 8 else {
            message = "Password must be at least 8 characters"
            messageColor = .red
            return
        }
        
        isLoading = true
        message = ""
        
        do {
            // Update the user's password using Supabase's updateUser method
            try await SupabaseController.shared.client.auth.update(user: .init(
                password: newPassword
            ))
            
            message = "Password has been reset successfully"
            messageColor = .green
            
            // Dismiss the sheet after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
            
        } catch {
            print("Password reset error: \(error)")
            message = "Failed to reset password: \(error.localizedDescription)"
            messageColor = .red
        }
        
        isLoading = false
    }
    
    func sendOTP() async {
        guard !email.isEmpty else {
            message = "Please enter your email"
            messageColor = .red
            return
        }
        
        isLoading = true
        message = ""
        
        do {
            // Generate OTP
            generatedOTP = generateOTP()
            
            // Send OTP via email
            try await EmailService.shared.sendOTP(to: email, otp: generatedOTP, isPasswordReset: true)
            
            message = "Verification code sent to your email"
            messageColor = .green
            showOTPField = true
            
        } catch {
            message = "Failed to send verification code: \(error.localizedDescription)"
            messageColor = .red
        }
        
        isLoading = false
    }
}

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var showPassword = false
    
    private let supabase = SupabaseController.shared.client
    
    @MainActor
    func login() async -> Bool {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return false
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            UserDefaults.standard.set(email, forKey: "userEmail")
            let savedName = UserDefaults.standard.string(forKey: "userName") ?? "User"
            UserDefaults.standard.set(savedName, forKey: "userName")
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func navigateToMainTabBar() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
                // Get the window scene
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                    
                    // Add animation for smooth transition
                    UIView.transition(with: window,
                                    duration: 0.3,
                                    options: .transitionCrossDissolve,
                                    animations: nil,
                                    completion: nil)
                }
            }
        }
    }
    
    func forgotPassword() {
        Task {
            do {
                try await supabase.auth.resetPasswordForEmail(email)
                await MainActor.run {
                    errorMessage = "Password reset email sent. Please check your inbox."
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to send reset email: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let identityToken = appleIDCredential.identityToken,
                      let tokenString = String(data: identityToken, encoding: .utf8) else {
                    let msg = "Could not get identity token"
                    print(msg)
                    errorMessage = msg
                    return
                }
                // Extract user details
                let userID = appleIDCredential.user
                let email = appleIDCredential.email ?? ""
                let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
                
                Task {
                    do {
                        let session = try await supabase.auth.signInWithIdToken(
                            credentials: .init(
                                provider: .apple,
                                idToken: tokenString
                            )
                        )
                        // Save details to UserDefaults
                        if !email.isEmpty {
                            UserDefaults.standard.set(email, forKey: "userEmail")
                        }
                        if !fullName.trimmingCharacters(in: .whitespaces).isEmpty {
                            UserDefaults.standard.set(fullName, forKey: "userName")
                        }
                        UserDefaults.standard.set(userID, forKey: "userID")
                        // Save to database if new user (only if email/name available)
                        if !email.isEmpty && !fullName.trimmingCharacters(in: .whitespaces).isEmpty {
                            try? await SupabaseController.shared.createUserRecord(userID: userID, name: fullName, email: email)
                        }
                        await MainActor.run {
                            self.navigateToMainTabBar()
                        }
                    } catch {
                        let msg = "Apple sign in failed: \(error.localizedDescription)"
                        print(msg)
                        await MainActor.run {
                            errorMessage = msg
                        }
                    }
                }
            }
        case .failure(let error):
            let nsError = error as NSError
            let msg = "Apple sign in failed: \(error.localizedDescription) (code: \(nsError.code), domain: \(nsError.domain))"
            print("ASAuthorizationController credential request failed with error: \(msg)")
            errorMessage = msg
            // If error code 1000, prompt user to open Settings
            if nsError.domain == "com.apple.AuthenticationServices.AuthorizationError" && nsError.code == 1000 {
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootVC = windowScene.windows.first?.rootViewController {
                        let alert = UIAlertController(
                            title: "Apple ID Required",
                            message: "You are not signed in to an Apple ID. Please sign in from Settings to use Sign in with Apple.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        })
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        rootVC.present(alert, animated: true)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
} 
