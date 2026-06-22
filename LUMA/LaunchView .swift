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
                Color.lumaSurface
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
                        .frame(width: isLogoExpanded ? 300 : 210,
                               height: isLogoExpanded ? 300 : 210)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .shadow(color: .black.opacity(0.15),
                                radius: isLogoExpanded ? 40 : 25,
                                x: 0,
                                y: 15)
                        .scaleEffect(animate ? 1 : 0.9)
                        .opacity(animate ? 1 : 0)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                isLogoExpanded.toggle()
                            }
                        }
                    
                    if !isLogoExpanded {
                        Text("AAROHI")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(.lumaDarkGray)
                            .tracking(6)
                            .opacity(animate ? 1 : 0)
                        
                        Text("Because every stage deserves care")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.lumaMidGray)
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
                                        .fill(Color.lumaPinkLight)
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
                hasSeenOnboarding = false // Reset for testing so the user can see the onboarding screen
                
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
