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
  @State private var animateButton = false
  
  let slides: [OnboardingSlide] = [
    OnboardingSlide(
      iconName: "waveform.path.ecg",
      title: "Your Personal Space",
      description: "Track your daily health, monitor symptoms, and understand how your cycle affects your body and mind.",
      accentColor: .lumaAccent
    ),
    OnboardingSlide(
      iconName: "figure.mind.and.body",
      title: "Explore Your Body",
      description: "Interact with the 3D Body Map to discover exactly what's happening inside you during every phase of life.",
      accentColor: .lumaPinkBubble
    ),
    OnboardingSlide(
      iconName: "ellipsis.message",
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
          .font(.subheadline.weight(.semibold))
          .foregroundColor(.secondary)
          .padding(.horizontal, 24)
          .padding(.top, 16)
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
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
              currentTab += 1
            }
          } else {
            completeOnboarding()
          }
        } label: {
          Text(currentTab == slides.count - 1 ? "Start Journey" : "Next")
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
              Capsule()
                .fill(currentTab == slides.count - 1 ? Color.lumaPinkBubble : slides[currentTab].accentColor)
            )
            .shadow(
              color: (currentTab == slides.count - 1 ? Color.lumaPinkBubble : slides[currentTab].accentColor).opacity(0.4),
              radius: 12,
              x: 0,
              y: 8
            )
            .scaleEffect(animateButton ? 1.02 : 1.0)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 60)
        .padding(.top, 10)
      }
    }
    .navigationBarBackButtonHidden(true)
    .onAppear {
      withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
        animateButton = true
      }
    }
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
    VStack(spacing: 40) {
      Spacer()
      
      ZStack {
        // Soft glowing aura
        Circle()
          .fill(
            LinearGradient(
              colors: [slide.accentColor.opacity(0.1), slide.accentColor.opacity(0.4)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 240, height: 240)
          .blur(radius: 30)
          .scaleEffect(appear ? 1.1 : 0.9)
          .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: appear)
        
        // Crisp Icon
        Image(systemName: slide.iconName)
          .font(.system(size: 90, weight: .ultraLight))
          .foregroundStyle(
            LinearGradient(
              colors: [slide.accentColor.opacity(0.7), slide.accentColor],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .shadow(color: slide.accentColor.opacity(0.3), radius: 10, x: 0, y: 10)
          .scaleEffect(appear ? 1.0 : 0.8)
          .opacity(appear ? 1.0 : 0)
          .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: appear)
      }
      .padding(.bottom, 10)
      
      VStack(spacing: 16) {
        Text(slide.title)
          .font(.system(size: 32, weight: .bold, design: .rounded))
          .foregroundColor(.primary)
          .multilineTextAlignment(.center)
          .opacity(appear ? 1.0 : 0)
          .offset(y: appear ? 0 : 20)
          .animation(.easeOut(duration: 0.6).delay(0.2), value: appear)
        
        Text(slide.description)
          .font(.system(size: 17, weight: .regular))
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 40)
          .lineSpacing(6)
          .opacity(appear ? 1.0 : 0)
          .offset(y: appear ? 0 : 20)
          .animation(.easeOut(duration: 0.6).delay(0.3), value: appear)
      }
      
      Spacer()
      Spacer()
    }
    .onAppear {
      appear = true
    }
  }
}
