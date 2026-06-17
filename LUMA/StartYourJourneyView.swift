import SwiftUI

struct StartYourJourneyView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @AppStorage("selectedStage") private var selectedStageRaw: String = LifeStage.reproductive.rawValue
    @Environment(\.dismiss) private var dismiss
    
    @State private var age: Int = 18
    @State private var suggestedStage: LifeStage = .reproductive
    @State private var selectedStage: LifeStage = .reproductive
    
    var body: some View {
        VStack(spacing: 28) {
            
           
            VStack(spacing: 16) {
                
                Image("ProfileAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 95, height: 95)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(color: Color.lumaAccent.opacity(0.25), radius: 10, x: 0, y: 4)
                
                Text("Hi, I’m Luma")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.lumaAccent)
                
                Text("Let’s understand your body, together.")
                    .font(.subheadline)
                    .foregroundColor(Color.lumaAccent.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 24)
            .padding(.bottom, 32)
            .background(LumaGradient.soft)
            
            
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("How old are you?")
                    .font(.headline)
                
                Stepper(value: $age, in: 9...70) {
                    Text("\(age) years")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Text("You can change this anytime later.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Based on your age, you may be in")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(suggestedStage.title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LifeStage.allCases, id: \.self) { stage in
                        Button {
                            withAnimation(.spring()) {
                                selectedStage = stage
                            }
                        } label: {
                            Text(stage.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(
                                    selectedStage == stage ? .white : .primary
                                )
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(
                                    selectedStage == stage ?
                                    Color.lumaAccent :
                                    Color.lumaSurface
                                )
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            selectedStage == stage ?
                                            Color.clear :
                                            Color.gray.opacity(0.3),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(
                                    color: selectedStage == stage ?
                                    Color.lumaAccent.opacity(0.3) :
                                    .clear,
                                    radius: 6,
                                    x: 0,
                                    y: 3
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Your selected phase")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(selectedStage.title)
                    .font(.headline)
                    .foregroundColor(Color.lumaAccent)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.lumaSurface.opacity(0.8))
            .cornerRadius(16)
            .padding(.horizontal)
            
            
            
            Button {
                selectedStageRaw = selectedStage.rawValue
                hasSeenOnboarding = true
                dismiss()
            } label: {
                Text("Confirm & Continue")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.lumaAccent)
                    .cornerRadius(24)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            suggestedStage = LifeStage.stage(for: age)
            selectedStage = suggestedStage
        }
        .onChange(of: age) { _, newValue in
            suggestedStage = LifeStage.stage(for: newValue)
            selectedStage = suggestedStage
        }
    }
}
