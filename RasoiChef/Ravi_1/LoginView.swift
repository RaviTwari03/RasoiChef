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
            print("Password reset failed: OTP is empty")
            message = "Please enter the verification code"
            messageColor = .red
            return
        }
        
        guard otp == generatedOTP else {
            print("Password reset failed: Invalid OTP")
            print("Received OTP: \(otp)")
            print("Expected OTP: \(generatedOTP)")
            message = "Invalid verification code"
            messageColor = .red
            return
        }
        
        guard !newPassword.isEmpty else {
            print("Password reset failed: New password is empty")
            message = "Please enter a new password"
            messageColor = .red
            return
        }
        
        guard newPassword == confirmPassword else {
            print("Password reset failed: Passwords do not match")
            print("New password length: \(newPassword.count)")
            print("Confirm password length: \(confirmPassword.count)")
            message = "Passwords do not match"
            messageColor = .red
            return
        }
        
        guard newPassword.count >= 8 else {
            print("Password reset failed: Password too short")
            print("Password length: \(newPassword.count)")
            message = "Password must be at least 8 characters"
            messageColor = .red
            return
        }
        
        isLoading = true
        message = ""
        
        do {
            print("\nStarting password reset process...")
            print("Email being reset: \(email)")
            
            // Encrypt the new password
            let encryptedPassword = PasswordEncryption.shared.encryptPassword(newPassword)
            print("Password encrypted successfully")
            print("Encrypted password length: \(encryptedPassword.count)")
            
            // Update the encrypted password in the users table
            print("Updating encrypted password for email: \(email)")
            
            // Build and execute the update query
            let updateResponse = try await SupabaseController.shared.client.database
                .from("users")
                .update(["encrypted_password": encryptedPassword])
                .eq("email", value: email.lowercased().trimmingCharacters(in: .whitespaces))
                .execute()
            
            print("Update response received")
            if let responseString = String(data: updateResponse.data, encoding: .utf8) {
                print("Update response: \(responseString)")
            }
            
            // Verify the update
            let verifyResponse = try await SupabaseController.shared.client.database
                .from("users")
                .select("encrypted_password")
                .eq("email", value: email.lowercased().trimmingCharacters(in: .whitespaces))
                .execute()
            
            print("Verifying update...")
            if let verifyData = String(data: verifyResponse.data, encoding: .utf8) {
                print("Verification response: \(verifyData)")
                
                // Try to decode and compare the stored password
                if let userData = try? JSONDecoder().decode([[String: String]].self, from: verifyResponse.data),
                   let storedPassword = userData.first?["encrypted_password"] {
                    print("Verification successful - stored password matches expected")
                    print("Stored password length: \(storedPassword.count)")
                } else {
                    print("Warning: Could not verify stored password format")
                }
            }
            
            // Also try to update auth password (but don't fail if it doesn't work)
            do {
                try await SupabaseController.shared.client.auth.resetPasswordForEmail(email)
                print("Auth password reset email sent")
            } catch {
                print("Note: Auth password reset failed, but database update succeeded")
            }
            
            message = "Password has been reset successfully"
            messageColor = .green
            
            // Dismiss the sheet after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
            
        } catch {
            print("\nPassword Reset Error Details:")
            print("Error type: \(type(of: error))")
            print("Error description: \(error.localizedDescription)")
            
            if let supabaseError = error as? PostgrestError {
                print("Supabase error code: \(supabaseError.code)")
                print("Supabase message: \(supabaseError.message)")
            }
            
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
        
        let cleanedEmail = email.lowercased().trimmingCharacters(in: .whitespaces)
        isLoading = true
        message = ""
        
        do {
            print("Checking email: \(cleanedEmail)")
            
            // First verify if the email exists in the users table with a more explicit query
            let query = SupabaseController.shared.client.database
                .from("users")
                .select("""
                    email,
                    user_id
                """)
                .eq("email", value: cleanedEmail)
            
            print("Executing query...")
            
            let response = try await query.execute()
            print("Database response received")
            
            // Print detailed response information
            print("Response status: \(response.status)")
            print("Response data: \(String(data: response.data, encoding: .utf8) ?? "nil")")
            
            // Print the raw JSON for debugging
            if let jsonString = String(data: response.data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            // Try a different query to list all emails
            print("\nFetching all emails for debugging...")
            let allEmailsQuery = SupabaseController.shared.client.database
                .from("users")
                .select("email")
            
            print("Executing all emails query...")
            let allEmailsResponse = try await allEmailsQuery.execute()
            
            if let allEmailsJson = String(data: allEmailsResponse.data, encoding: .utf8) {
                print("All emails in database: \(allEmailsJson)")
            }
            
            // Try to decode the response
            let decoder = JSONDecoder()
            if let users = try? decoder.decode([EmailResponse].self, from: response.data),
               !users.isEmpty {
                print("Found user with email: \(users[0].email)")
                
                // Email exists, proceed with OTP
                generatedOTP = generateOTP()
                print("Generated OTP: \(generatedOTP)")
                
                do {
                    try await EmailService.shared.sendOTP(to: cleanedEmail, otp: generatedOTP, isPasswordReset: true)
                    message = "Verification code sent to your email"
                    messageColor = .green
                    showOTPField = true
                } catch {
                    print("Failed to send email: \(error)")
                    message = "Error sending verification code. Please try again."
                    messageColor = .red
                }
            } else {
                print("\nDebug Information:")
                print("1. Cleaned Email: \(cleanedEmail)")
                print("2. Response Data Length: \(response.data.count) bytes")
                print("3. Trying to decode raw data...")
                
                if let rawString = String(data: response.data, encoding: .utf8) {
                    print("Raw data as string: \(rawString)")
                }
                
                message = "No account found with this email address"
                messageColor = .red
            }
            
        } catch {
            print("\nDatabase Error Details:")
            print("Error type: \(type(of: error))")
            print("Error description: \(error.localizedDescription)")
            if let supabaseError = error as? PostgrestError {
                print("Supabase error code: \(supabaseError.code)")
                print("Supabase message: \(supabaseError.message)")
            }
            message = "Error verifying email. Please try again."
            messageColor = .red
        }
        
        isLoading = false
    }
}

// Add this struct for decoding the response
private struct UserEmail: Codable {
    let email: String
}

// Add this struct at the top level of the file if not already present
private struct UserResponse: Codable {
    let email: String
}

// Add this at the top of the file, outside any class or struct
private struct EmailResponse: Codable {
    let email: String
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
            // First verify the encrypted password
            let encryptedAttempt = PasswordEncryption.shared.encryptPassword(password)
            
            // Fetch user from database to get stored encrypted password
            let response = try await supabase.database
                .from("users")
                .select("encrypted_password")
                .eq("email", value: email)
                .single()
                .execute()
            
            // Decode the response
            do {
                let userData = try JSONDecoder().decode([String: String].self, from: response.data)
                guard let storedPassword = userData["encrypted_password"] else {
                    errorMessage = "Invalid email or password"
                    isLoading = false
                    return false
                }
                
                // Verify password
                if encryptedAttempt == storedPassword {
                    // If password matches, proceed with Supabase auth
                    let session = try await supabase.auth.signIn(
                        email: email,
                        password: password
                    )
                    
                    // Store user information
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    let savedName = UserDefaults.standard.string(forKey: "userName") ?? "User"
                    UserDefaults.standard.set(savedName, forKey: "userName")
                    
                    isLoading = false
                    return true
                }
            } catch {
                errorMessage = "Invalid email or password"
                isLoading = false
                return false
            }
            
            errorMessage = "Invalid email or password"
            isLoading = false
            return false
            
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }
    
    func navigateToMainTabBar() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                    
                    // Setup location manager after successful login
                    if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        sceneDelegate.setupLocationManager()
                    }
                    
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
