import SwiftUI
import FirebaseAuth

@available(iOS 26.0, *)
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LumaBackground()
                
                VStack(spacing: 28) {
                    Spacer()
                    
                    // Header Logo & Title
                    VStack(spacing: 12) {
                        Image("AppIconImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                        
                        Text("Welcome to LUMA")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.lumaDarkGray)
                        
                        Text("Log in to resume your health journey")
                            .font(.subheadline)
                            .foregroundColor(.lumaMidGray)
                    }
                    .padding(.top, 40)
                    
                    // Input Fields Card
                    VStack(spacing: 16) {
                        TextField("Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 24)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    
                    // Buttons
                    VStack(spacing: 14) {
                        Button {
                            loginUser()
                        } label: {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Log In")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .background(Color.lumaAccent)
                        .cornerRadius(24)
                        .shadow(color: Color.lumaAccent.opacity(0.3), radius: 8, y: 4)
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        
                        // Demo login button
                        Button {
                            loginDemoUser()
                        } label: {
                            HStack {
                                Image(systemName: "sparkles")
                                Text("Demo Log In")
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.lumaAccent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.lumaAccent.opacity(0.4), lineWidth: 1)
                            )
                        }
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                        .disabled(isLoading)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Footer Link to Sign Up
                    Button {
                        showSignUp = true
                    } label: {
                        HStack {
                            Text("New to Luma?")
                                .foregroundColor(.lumaMidGray)
                            Text("Create an Account")
                                .fontWeight(.semibold)
                                .foregroundColor(.lumaAccent)
                        }
                        .font(.subheadline)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
    
    private func loginUser() {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func loginDemoUser() {
        isLoading = true
        errorMessage = ""
        
        // Demo credentials
        let demoEmail = "demo@luma.com"
        let demoPassword = "Password123"
        
        Auth.auth().signIn(withEmail: demoEmail, password: demoPassword) { _, error in
            if let error = error {
                // If demo user does not exist in Firebase Auth yet, create it on the fly
                if (error as NSError).code == AuthErrorCode.userNotFound.rawValue {
                    Auth.auth().createUser(withEmail: demoEmail, password: demoPassword) { _, signupError in
                        isLoading = false
                        if let signupError = signupError {
                            errorMessage = signupError.localizedDescription
                        }
                    }
                } else {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            } else {
                isLoading = false
            }
        }
    }
}
