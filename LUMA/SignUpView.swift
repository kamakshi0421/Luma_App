import SwiftUI

@available(iOS 26.0, *)
struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var navigateToOTP = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LumaBackground()
            
            VStack(spacing: 28) {
                // Header
                VStack(spacing: 12) {
                    Text("Create Account")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.lumaDarkGray)
                    
                    Text("Join LUMA and start understanding your body")
                        .font(.subheadline)
                        .foregroundColor(.lumaMidGray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 40)
                
                // Form Fields
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
                    
                    SecureField("Confirm Password", text: $confirmPassword)
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
                
                // Submit Button
                Button {
                    validateAndRegister()
                } label: {
                    Text("Send Verification Code")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.lumaAccent)
                        .cornerRadius(24)
                        .shadow(color: Color.lumaAccent.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal, 24)
                .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                
                Spacer()
                
                // Footer
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.lumaMidGray)
                        Text("Log In")
                            .fontWeight(.semibold)
                            .foregroundColor(.lumaAccent)
                    }
                    .font(.subheadline)
                }
                .padding(.bottom, 24)
            }
        }
        .navigationDestination(isPresented: $navigateToOTP) {
            OTPVerificationView(email: email, password: password)
        }
    }
    
    private func validateAndRegister() {
        errorMessage = ""
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailPred.evaluate(with: email) {
            errorMessage = "Please enter a valid email address."
            return
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }
        
        navigateToOTP = true
    }
}
