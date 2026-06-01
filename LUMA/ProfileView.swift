import SwiftUI
import FirebaseAuth

@available(iOS 26.0, *)
struct ProfileView: View {
    @EnvironmentObject var store: SymptomStore
    @Environment(\.dismiss) private var dismiss
    
    private var currentUserEmail: String {
        Auth.auth().currentUser?.email ?? "Guest User"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LumaBackground()
                
                VStack(spacing: 24) {
                    
                    // Profile Header Card
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.lumaAccent)
                            .padding(.top, 20)
                        
                        VStack(spacing: 6) {
                            Text(currentUserEmail)
                                .font(.headline)
                                .foregroundColor(.lumaDarkGray)
                            
                            Text("Current Stage: \(store.currentLifeStage.title)")
                                .font(.subheadline)
                                .foregroundColor(.lumaMidGray)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(22)
                    .shadow(color: .pink.opacity(0.08), radius: 10, y: 5)
                    .padding(.horizontal)
                    
                    // App Details List
                    VStack(spacing: 16) {
                        HStack {
                            Text("My Age")
                                .font(.body)
                                .foregroundColor(.lumaDarkGray)
                            Spacer()
                            Text("\(store.userAge) years")
                                .font(.body.bold())
                                .foregroundColor(.lumaMidGray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Log Out Button
                    Button {
                        signOut()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.85))
                        .cornerRadius(24)
                        .shadow(color: Color.red.opacity(0.25), radius: 8, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.lumaAccent)
                }
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
