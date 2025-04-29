import SwiftUI
import Supabase
import SwiftSMTP

// Email Service for OTP
class EmailService {
    static let shared = EmailService()
    private let smtp: SMTP
    private let senderEmail = "rt9593878@gmail.com"
    private let appPassword = "ibda bytr uomg scxw"
    
    private init() {
        smtp = SMTP(
            hostname: "smtp.gmail.com",
            email: senderEmail,
            password: appPassword,
            port: 465,               // Changed to SSL port
            tlsMode: .requireTLS,
            tlsConfiguration: nil,
            authMethods: [.plain],
            domainName: "gmail.com",
            timeout: 30              // Increased timeout
        )
    }
    
    func sendOTP(to email: String, otp: String, isPasswordReset: Bool = false) async throws {
        print("Attempting to send email to: \(email)")
        print("Using sender email: \(senderEmail)")
        
        let subject = isPasswordReset ? "RasoiChef - Password Reset Code" : "Welcome to RasoiChef - Verify Your Email"
        let text = isPasswordReset ? """
            Dear User,

            You have requested to reset your password for RasoiChef.

            Your verification code is: \(otp)

            Please enter this code in the app to reset your password. This code will expire in 10 minutes for security purposes.

            If you didn't request this code, please ignore this email and ensure your account is secure.

            Best regards,
            The RasoiChef Team
            """ : """
            Dear User,

            Welcome to RasoiChef! We're excited to have you join our culinary community.

            Your verification code is: \(otp)

            Please enter this code in the app to complete your registration. This code will expire in 10 minutes for security purposes.

            If you didn't request this code, please ignore this email.

            Happy Eating!

            Best regards,
            The RasoiChef Team
            """
        
        let mail = Mail(
            from: Mail.User(name: "RasoiChef", email: senderEmail),
            to: [Mail.User(name: "", email: email)],
            subject: subject,
            text: text
        )
        
        print("Sending email with subject: \(subject)")
        
        return try await withCheckedThrowingContinuation { continuation in
            smtp.send(mail) { error in
                if let error = error {
                    print("SMTP Error Details: \(error)")
                    print("Error Description: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else {
                    print("Email sent successfully!")
                    continuation.resume()
                }
            }
        }
    }
}

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header Image
                ZStack {
                    Image("WhatsApp Image 2025-01-16 at 20.47.08")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                    
                    // Overlay gradient
                    LinearGradient(
                        gradient: Gradient(colors: [.white.opacity(0), .white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .frame(height: 200)
                
                // Welcome Text
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Please fill in the details to sign up")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Sign Up Form
                VStack(spacing: 16) {
                    // Name Field
                    TextField("Full Name", text: $viewModel.fullName)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    // Email Field with validation indicator
                    HStack {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .onChange(of: viewModel.email) { _ in
                                viewModel.validateEmailDebounced()
                            }
                        
                        // Validation indicator
                        Group {
                            switch viewModel.emailValidationState {
                            case .none:
                                EmptyView()
                            case .validating:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.8)
                            case .valid:
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            case .invalid:
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(width: 20)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Email validation message
                    if !viewModel.emailErrorMessage.isEmpty {
                        Text(viewModel.emailErrorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    // Password Field with validation
                    HStack {
                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.newPassword)
                            .onChange(of: viewModel.password) { _ in
                                viewModel.validatePasswordDebounced()
                            }
                        
                        // Password validation indicator
                        Group {
                            switch viewModel.passwordValidationState {
                            case .none:
                                EmptyView()
                            case .validating:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.8)
                            case .valid:
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            case .invalid:
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(width: 20)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Password validation message
                    if !viewModel.passwordErrorMessage.isEmpty {
                        Text(viewModel.passwordErrorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    // Confirm Password Field with validation
                    HStack {
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .textContentType(.newPassword)
                            .onChange(of: viewModel.confirmPassword) { _ in
                                viewModel.validatePasswordDebounced()
                            }
                        
                        // Confirm password validation indicator
                        Group {
                            switch viewModel.confirmPasswordValidationState {
                            case .none:
                                EmptyView()
                            case .validating:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.8)
                            case .valid:
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            case .invalid:
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(width: 20)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Confirm password validation message
                    if !viewModel.confirmPasswordErrorMessage.isEmpty {
                        Text(viewModel.confirmPasswordErrorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    if viewModel.showOTPField {
                        // OTP Field
                        TextField("Enter OTP from Email", text: $viewModel.otp)
                            .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                // Sign Up/Verify Button
                Button(action: {
                    Task {
                        if viewModel.showOTPField {
                            await viewModel.verifyOTP()
                        } else {
                        await viewModel.signUp()
                        }
                    }
                }) {
                    HStack {
                        Text(viewModel.showOTPField ? "Verify OTP" : "Sign Up")
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
                
                // Terms and Conditions
                VStack(spacing: 8) {
                    Text("By signing up, you agree to our")
                        .foregroundColor(.gray)
                    HStack {
                        Button("Terms of Service") {
                            viewModel.showTerms = true
                        }
                        .foregroundColor(.accentColor)
                        
                        Text("and")
                            .foregroundColor(.gray)
                        
                        Button("Privacy Policy") {
                            viewModel.showPrivacy = true
                        }
                        .foregroundColor(.accentColor)
                    }
                }
                .font(.footnote)
                
                // Back to Login
                Button(action: { dismiss() }) {
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Text("Login")
                            .foregroundColor(.accentColor)
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
            }
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showTerms) {
            TermsView()
        }
        .sheet(isPresented: $viewModel.showPrivacy) {
            PrivacyView()
        }
    }
}

class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var otp = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var showTerms = false
    @Published var showPrivacy = false
    @Published var showOTPField = false
    @Published var shouldNavigateToMain = false
    @Published var emailValidationState: ValidationState = .none
    @Published var emailErrorMessage = ""
    @Published var passwordValidationState: ValidationState = .none
    @Published var passwordErrorMessage = ""
    @Published var confirmPasswordValidationState: ValidationState = .none
    @Published var confirmPasswordErrorMessage = ""
    
    private let supabase = SupabaseController.shared.client
    private var generatedOTP: String = ""
    private var emailCheckTask: Task<Void, Never>?
    
    enum ValidationState {
        case none
        case validating
        case invalid
        case valid
    }
    
    // Password validation requirements
    private struct PasswordCriteria {
        var hasMinLength: Bool = false      // At least 8 characters
        var hasUppercase: Bool = false      // At least one uppercase letter
        var hasLowercase: Bool = false      // At least one lowercase letter
        var hasNumber: Bool = false         // At least one number
        var hasSpecialChar: Bool = false    // At least one special character
        
        var isValid: Bool {
            return hasMinLength && hasUppercase && hasLowercase && hasNumber && hasSpecialChar
        }
    }
    
    // Validate password strength
    private func validatePassword(_ password: String) -> (PasswordCriteria, String) {
        var criteria = PasswordCriteria()
        var messages: [String] = []
        
        criteria.hasMinLength = password.count >= 8
        criteria.hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        criteria.hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        criteria.hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        criteria.hasSpecialChar = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
        
        if !criteria.hasMinLength { messages.append("At least 8 characters") }
        if !criteria.hasUppercase { messages.append("One uppercase letter") }
        if !criteria.hasLowercase { messages.append("One lowercase letter") }
        if !criteria.hasNumber { messages.append("One number") }
        if !criteria.hasSpecialChar { messages.append("One special character") }
        
        return (criteria, messages.isEmpty ? "" : "Missing: " + messages.joined(separator: ", "))
    }
    
    // Check password match
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordValidationState = .none
            confirmPasswordErrorMessage = ""
        } else if password != confirmPassword {
            confirmPasswordValidationState = .invalid
            confirmPasswordErrorMessage = "Passwords don't match"
        } else {
            confirmPasswordValidationState = .valid
            confirmPasswordErrorMessage = ""
        }
    }
    
    // Update password validation state
    func validatePasswordDebounced() {
        if password.isEmpty {
            passwordValidationState = .none
            passwordErrorMessage = ""
        } else {
            let (criteria, message) = validatePassword(password)
            passwordValidationState = criteria.isValid ? .valid : .invalid
            passwordErrorMessage = message
        }
        validateConfirmPassword()
    }
    
    // Debounced email validation
    func validateEmailDebounced() {
        // Cancel any existing validation task
        emailCheckTask?.cancel()
        
        // Reset state if email is empty
        if email.isEmpty {
            emailValidationState = .none
            emailErrorMessage = ""
            return
        }
        
        // Start new validation task
        emailCheckTask = Task { @MainActor in
            emailValidationState = .validating
            
            // Clean the email
            let cleanedEmail = email.lowercased().trimmingCharacters(in: .whitespaces)
            
            // First check format
            guard isValidEmailFormat(cleanedEmail) else {
                emailValidationState = .invalid
                emailErrorMessage = "Invalid email format"
                return
            }
            
            // Check domain
            guard isValidEmailDomain(cleanedEmail) else {
                emailValidationState = .invalid
                emailErrorMessage = "Invalid email domain"
                return
            }
            
            // Check if email is registered
            do {
                if try await isEmailRegistered(cleanedEmail) {
                    emailValidationState = .invalid
                    emailErrorMessage = "Email already registered"
                    return
                }
                
                // All checks passed
                emailValidationState = .valid
                emailErrorMessage = ""
            } catch {
                emailValidationState = .invalid
                emailErrorMessage = "Error checking email"
            }
        }
    }
    
    // Email validation function
    private func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Check if email domain exists
    private func isValidEmailDomain(_ email: String) -> Bool {
        guard let domain = email.components(separatedBy: "@").last else { return false }
        
        // List of common valid email domains
        let commonDomains = ["gmail.com", "yahoo.com", "outlook.com", "hotmail.com", "icloud.com", "aol.com"]
        if commonDomains.contains(domain.lowercased()) {
            return true
        }
        
        // For other domains, we could implement a more thorough check
        // But for now, we'll accept them if they have a valid format
        return domain.contains(".")
    }
    
    // Check if email is already registered
    private func isEmailRegistered(_ email: String) async throws -> Bool {
        let response = try await supabase.database
            .from("users")
            .select("email")
            .eq("email", value: email.lowercased().trimmingCharacters(in: .whitespaces))
            .execute()
        
        // Convert response data to string for checking
        if let jsonString = String(data: response.data, encoding: .utf8),
           jsonString != "[]" { // Check if response is not an empty array
            return true // Email exists
        }
        return false // Email doesn't exist
    }
    
    private func generateOTP() -> String {
        let digits = "0123456789"
        return String((0..<6).map { _ in digits.randomElement()! })
    }
    
    @MainActor
    func signUp() async {
        // Validate inputs
        guard !fullName.isEmpty else {
            errorMessage = "Please enter your full name"
            return
        }
        
        // Validate email state
        guard emailValidationState == .valid else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        // Validate password state
        guard passwordValidationState == .valid else {
            errorMessage = "Please enter a valid password"
            return
        }
        
        // Validate confirm password state
        guard confirmPasswordValidationState == .valid else {
            errorMessage = "Passwords must match"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            // Generate OTP
            generatedOTP = generateOTP()
            
            // Send OTP via email
            try await EmailService.shared.sendOTP(to: email.lowercased().trimmingCharacters(in: .whitespaces), otp: generatedOTP)
            
            // Show OTP field
            showOTPField = true
            errorMessage = "Please check your email for the verification code"
            
        } catch {
            errorMessage = "Failed to send verification code: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    @MainActor
    func verifyOTP() async {
        guard !otp.isEmpty else {
            errorMessage = "Please enter the OTP"
            return
        }
        
        guard otp == generatedOTP else {
            errorMessage = "Invalid verification code"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            // Create user metadata dictionary with proper Supabase types
            let userMetadata: [String: AnyJSON] = [
                "full_name": .string(fullName)
            ]
            
            // First sign up the user with Supabase Auth
            let session = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: userMetadata
            )
            
            // Get the user ID
            let userId = session.user.id
            
            // Encrypt the password
            let encryptedPassword = PasswordEncryption.shared.encryptPassword(password)
            
            // Insert user data into the users table with encrypted password
            try await supabase.database
                .from("users")
                .insert([
                    "user_id": userId.uuidString,
                    "name": fullName,
                    "email": email,
                    "encrypted_password": encryptedPassword
                ])
                .execute()
            
            // Save user data locally
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(fullName, forKey: "userName")
            UserDefaults.standard.set(userId.uuidString, forKey: "userID")
            
            // Navigate to main screen
            navigateToMainTabBar()
            
        } catch {
            errorMessage = "Registration failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func navigateToMainTabBar() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
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
}

struct TermsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Terms of Service content will go here...")
                    .padding()
            }
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PrivacyView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Privacy Policy content will go here...")
                    .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SignUpView()
} 
