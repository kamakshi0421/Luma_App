import SwiftUI

struct OnboardingSlide: Identifiable {
  let id = UUID()
  let iconName: String
  let title: String
  let description: String
  let accentColor: Color
}

@available(iOS 26.0, *)
struct OnboardingView: View {
  var onComplete: () -> Void
  
  @State private var currentTab = 0
  
  let slides: [OnboardingSlide] = [
    OnboardingSlide(
      iconName: "chart.xyaxis.line",
      title: "Your Personal Space",
      description: "Track your daily health, monitor symptoms, and understand how your cycle affects your body and mind.",
      accentColor: .lumaAccent
    ),
    OnboardingSlide(
      iconName: "figure.mind.and.body",
      title: "Explore Your Body",
      description: "Interact with the 3D Body Map to discover exactly what's happening inside you during every phase of life.",
      accentColor: .lumaPinkLight
    ),
    OnboardingSlide(
      iconName: "sparkles",
      title: "Meet Aarohi",
      description: "Your intelligent AI companion. Ask Aarohi any question about your health, anytime, securely and privately.",
      accentColor: .purple
    )
  ]
  
  var body: some View {
    ZStack {
      LumaBackground()
      
      VStack {
        HStack {
          Spacer()
          Button("Skip") {
            completeOnboarding()
          }
          .font(.subheadline.bold())
          .foregroundColor(.secondary)
          .padding()
        }
        
        TabView(selection: $currentTab) {
          ForEach(0..<slides.count, id: \.self) { index in
            OnboardingSlideView(slide: slides[index])
              .tag(index)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        
        // Bottom Button
        Button {
          if currentTab < slides.count - 1 {
            withAnimation {
              currentTab += 1
            }
          } else {
            completeOnboarding()
          }
        } label: {
          Text(currentTab == slides.count - 1 ? "Enter LUMA": "Next")
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 30)
                .fill(currentTab == slides.count - 1 ? Color.lumaAccent : slides[currentTab].accentColor)
            )
            .shadow(color: (currentTab == slides.count - 1 ? Color.lumaAccent : slides[currentTab].accentColor).opacity(0.3), radius: 10, y: 5)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 50)
        .padding(.top, 20)
      }
    }
    .navigationBarBackButtonHidden(true)
  }
  
  private func completeOnboarding() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
    onComplete()
  }
}

struct OnboardingSlideView: View {
  let slide: OnboardingSlide
  
  @State private var appear = false
  
  var body: some View {
    VStack(spacing: 32) {
      Spacer()
      
      ZStack {
        Circle()
          .fill(slide.accentColor.opacity(0.15))
          .frame(width: 180, height: 180)
          .scaleEffect(appear ? 1.1 : 0.9)
          .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: appear)
        
        Image(systemName: slide.iconName)
          .font(.system(size: 70, weight: .light))
          .foregroundColor(slide.accentColor)
      }
      .padding(.bottom, 20)
      
      VStack(spacing: 16) {
        Text(slide.title)
          .font(.title)
          .bold()
          .foregroundColor(.primary)
        
        Text(slide.description)
          .font(.body)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
          .lineSpacing(4)
      }
      
      Spacer()
      Spacer()
    }
    .onAppear {
      appear = true
    }
  }
}
