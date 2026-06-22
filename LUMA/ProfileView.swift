import SwiftUI

@available(iOS 26.0, *)
struct ProfileView: View {
    @AppStorage("user_age") private var userAge: Int = 25
    private var currentLifeStage: LifeStage { LifeStage.stage(for: userAge) }
    @Environment(\.dismiss) private var dismiss
    
    
    
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
                            Text("My Profile")
                                .font(.headline)
                                .foregroundColor(.lumaDarkGray)
                            
                            Text("Current Stage: \(currentLifeStage.title)")
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
                            Text("\(userAge) years")
                                .font(.body.bold())
                                .foregroundColor(.lumaMidGray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Spacer()
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
    

}
