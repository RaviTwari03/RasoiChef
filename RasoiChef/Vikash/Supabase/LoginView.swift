import SwiftUI
import Supabase
import AuthenticationServices
import UIKit

struct SignUpView: View {
    var body: some View {
        Text("Sign Up View")
    }
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isShowingSignUp = false
    @Environment(\.colorScheme) var colorScheme
    
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
                                    viewModel.forgotPassword()
                                }
                                .foregroundColor(.orange)
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
                            .background(Color.orange)
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
                                    .foregroundColor(.orange)
                                    .fontWeight(.semibold)
                            }
                            .font(.footnote)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
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
