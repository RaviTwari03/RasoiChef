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
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    // Confirm Password Field
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
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
    
    private let supabase = SupabaseController.shared.client
    private var generatedOTP: String = ""
    
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
        
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter a password"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            // Generate OTP
            generatedOTP = generateOTP()
            
            // Send OTP via email
            try await EmailService.shared.sendOTP(to: email, otp: generatedOTP)
            
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
            
            // Sign up the user
            let session = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: userMetadata
            )
            
            // Get the user ID
            let userId = session.user.id
            
            // Insert user data into the users table
            try await supabase.database
                .from("users")
                .insert([
                    "user_id": userId.uuidString,
                    "name": fullName,
                    "email": email
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
