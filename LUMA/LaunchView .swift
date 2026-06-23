import SwiftUI

@available(iOS 26.0, *)
struct LaunchView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    
    @State private var showJourneyView = false
    @State private var goToHome = false
    @State private var animate = false
    @State private var isLogoExpanded = false
    
    @available(iOS 26.0, *)
    var body: some View {
        if goToHome {
            MainTabView()
        } else {
            ZStack {
                LumaBackground()
                    .ignoresSafeArea()
                
                if isLogoExpanded {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isLogoExpanded = false
                            }
                        }
                }
                
                VStack(spacing: 28) {
                    Spacer()
                    
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isLogoExpanded ? 320 : 220,
                               height: isLogoExpanded ? 320 : 220)
                        // Use a dynamic, slightly tighter corner radius to hide any baked-in logo corners
                        .clipShape(RoundedRectangle(cornerRadius: isLogoExpanded ? 72 : 50, style: .continuous))
                        .shadow(color: .black.opacity(0.15),
                                radius: isLogoExpanded ? 50 : 30,
                                x: 0,
                                y: 15)
                        .scaleEffect(animate ? 1 : 0.8)
                        .opacity(animate ? 1 : 0)
                        // Breathing animation
                        .scaleEffect(isLogoExpanded ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isLogoExpanded)
                        .onAppear {
                            // Start continuous breathing effect
                            isLogoExpanded = true
                        }
                    
                    if true { // Always show text now
                        Text("AAROHI")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            // Revert to primary text color
                            .foregroundColor(.primary)
                            .tracking(6)
                            .opacity(animate ? 1 : 0)
                        
                        Text("Because every stage deserves care")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .opacity(animate ? 1 : 0)
                        
                        Spacer()
                        
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
                                        .fill(Color.lumaPinkLight) // Reverted to original button color
                                )
                                .shadow(color: .black.opacity(0.1),
                                        radius: 12,
                                        x: 0,
                                        y: 6)
                        }
                        .scaleEffect(animate ? 1 : 0.95)
                        .opacity(animate ? 1 : 0)
                        .padding(.bottom, 50)
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
            .onAppear {
                
                withAnimation(.easeOut(duration: 0.9)) {
                    animate = true
                }
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
