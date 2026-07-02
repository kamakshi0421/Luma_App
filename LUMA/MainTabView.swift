import SwiftUI

@available(iOS 26.0, *)
struct MainTabView: View {
  
  @State private var selectedTab: Tab = .MySpace
  
  @AppStorage("selectedStage")
  private var savedStageRaw: String = LifeStage.reproductive.rawValue
  @AppStorage("hideGlobalFAB") private var hideGlobalFAB: Bool = false

  private var currentStage: LifeStage {
    LifeStage(rawValue: savedStageRaw) ?? .reproductive
  }
  enum Tab: Hashable {
    case MySpace, Phases, Reveal, Aarohi
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
            RevealView(onNavigateToAarohi: {
              selectedTab = .Aarohi
            })
          }
            .id(savedStageRaw)
            .tag(Tab.Reveal)
            .tabItem {
              Label("Reveal", systemImage: "magnifyingglass")
            }
            
          NavigationStack {
            AskLumaView(currentStage: currentStage)
          }
            .tag(Tab.Aarohi)
            .tabItem {
              Label("Aarohi", systemImage: "ellipsis.message")
            }
        }
        .tint(.lumaPinkBubble)
    }
  }
}
