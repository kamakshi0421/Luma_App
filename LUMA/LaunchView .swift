import SwiftUI

@available(iOS 26.0, *)
struct LaunchView: View {
  @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
  
  @State private var showJourneyView = false
  @State private var goToHome = false
  
  // Animation States
  @State private var logoScale: CGFloat = 0.4
  @State private var showHint = true
  @State private var showContent = false
  @State private var animationTriggered = false
  
  var body: some View {
    if goToHome {
      MainTabView()
    } else {
      ZStack {
        LumaBackground()
          .ignoresSafeArea()
        
        // Invisible tap target covering the whole screen
        Color.white.opacity(0.001)
          .ignoresSafeArea()
          .onTapGesture {
            if !animationTriggered {
              triggerAnimation()
            }
          }
        
        VStack(spacing: 28) {
          Spacer() // Top spacer keeps logo centered initially
          
          Image("AppIconImage")
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 30, y: 15)
            .scaleEffect(logoScale)
          
          if showHint {
            Text("Tap to wake")
              .font(.caption.weight(.medium))
              .foregroundColor(.secondary)
              .opacity(0.6)
              .transition(.opacity)
              .padding(.top, 10)
          }
          
          if showContent {
            VStack(spacing: 16) {
              Text("AAROHI")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .tracking(6)
              
              Text("Because every stage deserves care")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            
            Spacer() // This pushes the logo and text upwards smoothly
            
            Button {
              handleGetStarted()
            } label: {
              Text("Get Started")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 48)
                .padding(.vertical, 16)
                .background(
                  RoundedRectangle(cornerRadius: 30)
                    .fill(Color.lumaPinkLight)
                )
                .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .padding(.bottom, 50)
          } else {
            Spacer() // Bottom spacer keeps logo centered
          }
        }
        .padding(.horizontal, 24)
      }
      .sheet(isPresented: $showJourneyView) {
        StartYourJourneyView()
          .presentationDetents([.large])
          .presentationCornerRadius(28)
      }
      .onChange(of: showJourneyView) { _, isPresented in
        if !isPresented {
          withAnimation(.easeInOut(duration: 0.5)) {
            goToHome = true
          }
        }
      }
    }
  }
  
  private func triggerAnimation() {
    animationTriggered = true
    
    // Hide hint immediately
    withAnimation(.easeOut(duration: 0.2)) {
      showHint = false
    }
    
    // Step 1: Pop up the logo
    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
      logoScale = 1.0
    }
    
    // Step 2: Show content, which naturally shifts the layout upwards
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
      withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
        showContent = true
      }
    }
  }
  
  private func handleGetStarted() {
    if hasSeenOnboarding {
      withAnimation {
        goToHome = true
      }
    } else {
      showJourneyView = true
    }
  }
}
