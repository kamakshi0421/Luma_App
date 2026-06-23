import SwiftUI

@available(iOS 26.0, *)
struct MainTabView: View {
    
    @State private var selectedTab: Tab = .MySpace
    @State private var showChat = false
    
    @AppStorage("selectedStage")
    private var savedStageRaw: String = LifeStage.reproductive.rawValue
    @AppStorage("hideGlobalFAB") private var hideGlobalFAB: Bool = false

    private var currentStage: LifeStage {
        LifeStage(rawValue: savedStageRaw) ?? .reproductive
    }
    enum Tab: Hashable {
        case MySpace, Phases, Reveal
    }
    
    var body: some View {
        
        ZStack {
                
                TabView(selection: $selectedTab) {
                    
                    NavigationStack {
                        MySpaceView(selectedTab: $selectedTab)
                    }
                        .tag(Tab.MySpace)
                        .tabItem {
                            Label("MySpace", systemImage: "house.fill")
                        }
                    
                    NavigationStack {
                        PhasesView()
                    }
                        .tag(Tab.Phases)
                        .tabItem {
                            Label("Phases", systemImage: "moon.stars.fill")
                        }
                    
                    NavigationStack {
                        RevealView()
                    }
                        .id(savedStageRaw)
                        .tag(Tab.Reveal)
                        .tabItem {
                            Label("Reveal", systemImage: "magnifyingglass")
                        }
                }
                .tint(.lumaPinkBubble)
                
                if !hideGlobalFAB {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                showChat = true
                            } label: {
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                    
                                    Text("Ask Aarohi")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [Color.lumaPinkLight, Color.lumaPinkDark],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(
                                    color: Color.lumaPinkDark.opacity(0.4),
                                    radius: 12,
                                    y: 6
                                )
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 64)
                        }
                    }
                    .ignoresSafeArea(.keyboard)
                }
        }
        .fullScreenCover(isPresented: $showChat) {
            AskLumaView(currentStage: currentStage)
        }
    }
}

