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
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Food Images Grid
                        ZStack {
                            Image("WhatsApp Image 2025-01-16 at 20.47.08")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                            
//                            // Overlay gradient
//                            LinearGradient(
//                                gradient: Gradient(colors: [.white.opacity(0), .white]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
                        }
                        .frame(height: 300)
                        
                        // Welcome Text
                        VStack(spacing: 8) {
                            Text("Welcome Back!")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Please login to continue")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Login Form
                        VStack(spacing: 16) {
                            // Email Field
                            TextField("Email", text: $viewModel.email)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            
                            // Password Field
                            SecureField("Password", text: $viewModel.password)
                                .textContentType(.password)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            
                            // Forgot Password Button
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    showForgotPassword = true
                                }
                                .foregroundColor(.accentColor)
                                .font(.footnote)
                            }
                        }
                        .padding(.horizontal)
                        
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
                            .cornerRadius(25)
                        }
                        .padding(.horizontal)
                        .disabled(viewModel.isLoading)
                        
                        // Social Login Options
                        VStack(spacing: 16) {
                            Text("Or continue with")
                                .foregroundColor(.gray)
                                .font(.footnote)
                            
                            HStack(spacing: 20) {
                                // Google Sign In
                                Button(action: { viewModel.signInWithGoogle() }) {
                                    HStack {
                                        Image(systemName: "g.circle.fill")
                                        Text("Google")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(25)
                                }
                                
                                // Apple Sign In
                                SignInWithAppleButton { request in
                                    viewModel.handleAppleSignInRequest(request)
                                } onCompletion: { result in
                                    viewModel.handleAppleSignInCompletion(result)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .cornerRadius(25)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Sign Up Link
                        NavigationLink(destination: SignUpView(), isActive: $isShowingSignUp) {
                            HStack {
                                Text("Don't have an account?")
                                    .foregroundColor(.gray)
                                Text("Sign Up")
                                    .foregroundColor(.accentColor)
                                    .fontWeight(.semibold)
                            }
                            .font(.footnote)
                        }
                    }
                    .padding(.bottom, 30)
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
    
    func signInWithGoogle() {
        Task {
            do {
                let redirectURL = URL(string: "io.supabase.rasoi-chef://login-callback")!
                try await supabase.auth.signInWithOAuth(
                    provider: .google,
                    redirectTo: redirectURL
                )
            } catch {
                await MainActor.run {
                    errorMessage = "Google sign in failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func handleAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let identityToken = appleIDCredential.identityToken,
                      let tokenString = String(data: identityToken, encoding: .utf8) else {
                    errorMessage = "Could not get identity token"
                    return
                }
                
                Task {
                    do {
                        let session = try await supabase.auth.signInWithIdToken(
                            credentials: .init(
                                provider: .apple,
                                idToken: tokenString
                            )
                        )
                        await MainActor.run {
                            self.navigateToMainTabBar()
                        }
                    } catch {
                        await MainActor.run {
                            errorMessage = "Apple sign in failed: \(error.localizedDescription)"
                        }
                    }
                }
            }
        case .failure(let error):
            errorMessage = "Apple sign in failed: \(error.localizedDescription)"
        }
    }
}

#Preview {
    LoginView()
} 
