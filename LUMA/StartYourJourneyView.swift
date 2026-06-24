import SwiftUI

@available(iOS 26.0, *)
struct StartYourJourneyView: View {
  @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
  @AppStorage("selectedStage") private var selectedStageRaw: String = LifeStage.reproductive.rawValue
  @Environment(\.dismiss) private var dismiss
  
  @State private var age: Int = 18
  @State private var suggestedStage: LifeStage = .reproductive
  @State private var selectedStage: LifeStage = .reproductive
  
  var body: some View {
    NavigationStack {
      ZStack {
        LumaBackground()
        
        ScrollView(showsIndicators: false) {
          VStack(spacing: 28) {
            
            // Header Profile Card
            VStack(spacing: 16) {
              Image("ProfileAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 95, height: 95)
                .clipShape(Circle())
                .overlay(
                  Circle()
                    .stroke(Color(.systemBackground).opacity(0.8), lineWidth: 4)
                )
                .shadow(color: Color.lumaPinkBubble.opacity(0.3), radius: 10, x: 0, y: 4)
              
              Text("Hi, I’m Aarohi")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
              
              Text("Let’s understand your body, together.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .padding(.horizontal, 24)
            .liquidGlass()
            .padding(.horizontal)
            .padding(.top, 24)
            
            // Age Card
            VStack(alignment: .leading, spacing: 12) {
              Text("How old are you?")
                .font(.headline)
                .foregroundColor(.primary)
              
              Stepper(value: $age, in: 9...70) {
                Text("\(age) years")
                  .font(.body)
                  .foregroundColor(.primary)
              }
              
              Text("You can change this anytime later.")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .liquidGlass()
            .padding(.horizontal)
            
            // Phase Suggestion
            VStack(alignment: .leading, spacing: 6) {
              Text("Based on your age, you may be in")
                .font(.caption)
                .foregroundColor(.secondary)
              
              Text(suggestedStage.title)
                .font(.headline)
                .foregroundColor(.primary)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Phase Selector
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
                      .padding(.vertical, 12)
                      .padding(.horizontal, 20)
                      .background(
                        selectedStage == stage ?
                        Color.lumaAccent :
                        Color.gray.opacity(0.15)
                      )
                      .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                      .overlay(
                        RoundedRectangle(cornerRadius: 24)
                          .stroke(Color(.systemBackground).opacity(0.2), lineWidth: 1)
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
              .padding(.horizontal, 24)
            }
            
            // Selected Phase Card
            VStack(alignment: .leading, spacing: 6) {
              Text("Your selected phase")
                .font(.caption)
                .foregroundColor(.secondary)
              
              Text(selectedStage.title)
                .font(.headline)
                .foregroundColor(.lumaPinkBubble)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .liquidGlass()
            .padding(.horizontal)
            
            // Navigation to Onboarding
            NavigationLink {
              OnboardingView(onComplete: {
                selectedStageRaw = selectedStage.rawValue
                hasSeenOnboarding = true
                dismiss()
              })
            } label: {
              Text("Confirm & Continue")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.lumaAccent)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.lumaAccent.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
            
            Spacer()
          }
        }
      }
      .navigationBarHidden(true)
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
}
