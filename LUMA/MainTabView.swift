
import SwiftUI

@available(iOS 26.0, *)
struct MainTabView: View {
    
    @State private var selectedTab: Tab = .MySpace
    @State private var showChat = false
    
    @AppStorage("selectedStage")
    private var savedStageRaw: String = LifeStage.reproductive.rawValue

    private var currentStage: LifeStage {
        LifeStage(rawValue: savedStageRaw) ?? .reproductive
    }
    enum Tab: Hashable {
        case MySpace, Phases, Reveal
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                TabView(selection: $selectedTab) {
                    
                    MySpaceView(selectedTab: $selectedTab)
                        .tag(Tab.MySpace)
                        .tabItem {
                            AnimatedTabIcon(
                                systemName: "house.fill",
                                title: "MySpace",
                                isSelected: selectedTab == .MySpace
                            )
                        }
                    
                    PhasesView()
                        .tag(Tab.Phases)
                        .tabItem {
                            AnimatedTabIcon(
                                systemName: "moon.stars.fill",
                                title: "Phases",
                                isSelected: selectedTab == .Phases
                            )
                        }
                    
                    RevealView()
                        .id(savedStageRaw)
                        .tag(Tab.Reveal)
                        .tabItem {
                            AnimatedTabIcon(
                                systemName: "magnifyingglass",
                                title: "Reveal",
                                isSelected: selectedTab == .Reveal
                            )
                        }
                }
                .tint(.lumaPinkBubble)
                
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showChat = true
                        } label: {
                            
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                
                                Text("Ask Luma")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.92, green: 0.45, blue: 0.70),
                                        Color(red: 0.82, green: 0.30, blue: 0.60)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(
                                color: Color(red: 0.82, green: 0.30, blue: 0.60).opacity(0.35),
                                radius: 10,
                                y: 6
                            )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 80)
                    }
                }
                .ignoresSafeArea(.keyboard)
            }
            
            .navigationDestination(isPresented: $showChat) {
                AskLumaView(currentStage: currentStage)
            }
        }
    }
}


struct AnimatedTabIcon: View {
    
    let systemName: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .scaleEffect(isSelected ? 1.15 : 1.0)
                .foregroundColor(isSelected ? .lumaPinkBubble : .gray)
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.6),
                    value: isSelected
                )
            
            Text(title)
                .font(.caption2)
                .foregroundColor(isSelected ? .lumaPinkBubble : .gray)
        }
    }
}
