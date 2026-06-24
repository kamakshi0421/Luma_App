import SwiftUI

@available(iOS 26.0, *)
struct StartYourJourneyView: View {
  @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
  @AppStorage("selectedStage") private var selectedStageRaw: String = LifeStage.reproductive.rawValue
  @AppStorage("user_name") private var userName: String = ""
  @Environment(\.dismiss) private var dismiss
  
  @AppStorage("user_age") private var age: Int = 18
  @State private var suggestedStage: LifeStage = .reproductive
  @State private var selectedStage: LifeStage = .reproductive
  
  private func color(for stage: LifeStage) -> Color {
    switch stage {
    case .prePuberty: return .pastelRose
    case .puberty: return .pastelMint
    case .reproductive: return .pastelSky
    case .perimenopause: return .orange
    case .menopause: return .purple
    case .postMenopause: return .teal
    }
  }
  
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
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
              
              Text("Let’s understand your body, together.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .padding(.horizontal, 24)
            .liquidGlass()
            .padding(.horizontal)
            .padding(.top, 24)
            
            // Name Card
            VStack(alignment: .leading, spacing: 12) {
              Text("What should I call you?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
              
              HStack {
                TextField("What should we call you?", text: $userName)
                  .font(.system(size: 20, weight: .medium, design: .rounded))
                  .foregroundColor(.primary)
                  .padding(.vertical, 16)
                  .padding(.horizontal, 20)
                  .submitLabel(.done)
                
                if !userName.trimmingCharacters(in: .whitespaces).isEmpty {
                  Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.green)
                    .transition(.scale.combined(with: .opacity))
                    .padding(.trailing, 20)
                }
              }
              .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                  .fill(Color(.systemBackground).opacity(0.6))
                  .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
              )
              .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                  .stroke(
                    !userName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.green.opacity(0.4) : Color.gray.opacity(0.15),
                    lineWidth: 1.5
                  )
              )
              .animation(.spring(response: 0.4, dampingFraction: 0.7), value: userName)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .liquidGlass()
            .padding(.horizontal)
            
            // Age Card
            VStack(alignment: .leading, spacing: 12) {
              Text("How old are you?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
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
                .font(.system(size: 20, weight: .bold, design: .rounded))
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
                        color(for: stage) :
                        Color.gray.opacity(0.15)
                      )
                      .clipShape(Capsule())
                      .overlay(
                        Capsule()
                          .stroke(Color(.systemBackground).opacity(0.2), lineWidth: 1)
                      )
                      .shadow(
                        color: selectedStage == stage ?
                        color(for: stage).opacity(0.4) :
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
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color(for: selectedStage))
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
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                  Capsule()
                    .fill(Color.lumaPinkBubble)
                )
                .shadow(color: Color.lumaPinkBubble.opacity(0.4), radius: 12, x: 0, y: 8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            
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
