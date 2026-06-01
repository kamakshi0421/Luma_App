import SwiftUI
import FirebaseAuth

@available(iOS 26.0, *)
struct OTPVerificationView: View {
    let email: String
    let password: String
    
    @State private var otpDigits = ["", "", "", ""]
    @State private var generatedOTP = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showDemoAlert = false
    
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            LumaBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Verify Email")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.lumaDarkGray)
                        
                        Text("We sent a verification code to")
                            .font(.subheadline)
                            .foregroundColor(.lumaMidGray)
                        
                        Text(email)
                            .font(.subheadline.bold())
                            .foregroundColor(.lumaDarkGray)
                    }
                    .padding(.top, 60)
                    
                    // 4-Digit Entry Fields
                    HStack(spacing: 16) {
                        ForEach(0..<4, id: \.self) { index in
                            TextField("", text: $otpDigits[index])
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .font(.title.bold())
                                .frame(width: 55, height: 65)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(focusedField == index ? Color.lumaAccent : Color.gray.opacity(0.2), lineWidth: 2)
                                )
                                .focused($focusedField, equals: index)
                                .onChange(of: otpDigits[index]) { _, newValue in
                                    if newValue.count > 1 {
                                        otpDigits[index] = String(newValue.suffix(1))
                                    }
                                    
                                    if !newValue.isEmpty && index < 3 {
                                        focusedField = index + 1
                                    }
                                }
                        }
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Submit Button
                    Button {
                        verifyAndSignUp()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Verify & Create Account")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.lumaAccent)
                                .cornerRadius(24)
                                .shadow(color: Color.lumaAccent.opacity(0.3), radius: 8, y: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .disabled(isLoading || otpDigits.contains { $0.isEmpty })
                    
                    // Resend Code Link
                    Button {
                        generateAndSendSimulatedOTP()
                    } label: {
                        Text("Resend Code")
                            .font(.subheadline.bold())
                            .foregroundColor(.lumaAccent)
                    }
                    .disabled(isLoading)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            generateAndSendSimulatedOTP()
            focusedField = 0
        }
        .alert("Code Sent", isPresented: $showDemoAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("A verification code has been sent to \(email). Please check your inbox for the code.")
        }
    }
    
    private func generateAndSendSimulatedOTP() {
        // Generate a random 4 digit code
        let code = String(format: "%04d", Int.random(in: 1000...9999))
        generatedOTP = code
        showDemoAlert = true
        
        // Call local python helper to send actual email via macOS Mail app
        guard let url = URL(string: "http://localhost:8080/send") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = ["email": email, "code": code]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            // Run asynchronously in the background
        }.resume()
    }
    
    private func verifyAndSignUp() {
        errorMessage = ""
        let enteredOTP = otpDigits.joined()
        
        if enteredOTP != generatedOTP {
            errorMessage = "Invalid verification code. Please try again."
            return
        }
        
        isLoading = true
        
        // Register the user with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
}
