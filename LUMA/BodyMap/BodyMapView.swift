import SwiftUI
import SpriteKit

struct BodyMapView: View {
    @AppStorage("selectedStage") private var selectedStageString: String = LifeStage.reproductive.rawValue
    @AppStorage("hideGlobalFAB") private var hideGlobalFAB: Bool = false
    @State private var selectedZone: BodyZone?
    @State private var pulsing = false
    @State private var scene: BodyMapScene = {
        let sc = BodyMapScene()
        sc.scaleMode = .resizeFill
        return sc
    }()
    
    var currentStage: LifeStage {
        LifeStage(rawValue: selectedStageString) ?? .reproductive
    }
    
    var body: some View {
        ZStack {
            LumaBackground()
                
                VStack {
                    Text("Your Body Map")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                        .padding(.top)
                    
                    Text("Tap any area to explore what's happening")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(currentStage.title)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.lumaPinkBubble)
                        .clipShape(Capsule())
                        .padding(.top, 4)
                    
                    Spacer()
                    
                    SpriteView(scene: scene, options: [.allowsTransparency])
                        .padding()
                }
            }
            .sheet(item: $selectedZone) { zone in
                BodyZoneDetailView(info: BodyMapContent.info(for: zone, stage: currentStage))
            }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            hideGlobalFAB = true
            pulsing = true
            scene.zoneTapped = { zone in
                selectedZone = zone
            }
        }
        .onDisappear {
            hideGlobalFAB = false
        }
    }
}
