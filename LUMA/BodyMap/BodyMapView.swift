import SwiftUI

struct BodyMapView: View {
    @AppStorage("selectedStage") private var selectedStageString: String = LifeStage.reproductive.rawValue
    @State private var selectedZone: BodyZone?
    @State private var pulsing = false
    
    var currentStage: LifeStage {
        LifeStage(rawValue: selectedStageString) ?? .reproductive
    }
    
    var body: some View {
        ZStack {
            LumaBackground()
            
            VStack {
                Text("Your Body Map")
                    .font(.largeTitle.bold())
                    .foregroundColor(.lumaDarkGray)
                    .padding(.top)
                
                Text("Tap any area to explore what's happening")
                    .font(.subheadline)
                    .foregroundColor(.lumaMidGray)
                
                Text(currentStage.title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.lumaPinkBubble)
                    .clipShape(Capsule())
                    .padding(.top, 4)
                
                Spacer()
                
                GeometryReader { geo in
                    ZStack {
                        // Stylized female silhouette (simple rounded shapes approximation for now)
                        Path { path in
                            let width = geo.size.width * 0.5
                            let height = geo.size.height * 0.8
                            let originX = geo.size.width * 0.25
                            let originY = geo.size.height * 0.1
                            
                            // Head
                            path.addEllipse(in: CGRect(x: originX + width * 0.35, y: originY, width: width * 0.3, height: height * 0.15))
                            
                            // Torso
                            path.addRoundedRect(in: CGRect(x: originX + width * 0.25, y: originY + height * 0.2, width: width * 0.5, height: height * 0.4), cornerSize: CGSize(width: 30, height: 30))
                            
                            // Hips/Legs (approximation)
                            path.addRoundedRect(in: CGRect(x: originX + width * 0.2, y: originY + height * 0.6, width: width * 0.6, height: height * 0.3), cornerSize: CGSize(width: 20, height: 20))
                        }
                        .stroke(Color.lumaPinkBubble.opacity(0.5), lineWidth: 3)
                        .background(
                            Path { path in
                                let width = geo.size.width * 0.5
                                let height = geo.size.height * 0.8
                                let originX = geo.size.width * 0.25
                                let originY = geo.size.height * 0.1
                                
                                path.addEllipse(in: CGRect(x: originX + width * 0.35, y: originY, width: width * 0.3, height: height * 0.15))
                                path.addRoundedRect(in: CGRect(x: originX + width * 0.25, y: originY + height * 0.2, width: width * 0.5, height: height * 0.4), cornerSize: CGSize(width: 30, height: 30))
                                path.addRoundedRect(in: CGRect(x: originX + width * 0.2, y: originY + height * 0.6, width: width * 0.6, height: height * 0.3), cornerSize: CGSize(width: 20, height: 20))
                            }
                            .fill(Color.white.opacity(0.3))
                        )
                        
                        // Tappable zones
                        ForEach(BodyZone.allCases) { zone in
                            Button {
                                selectedZone = zone
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.lumaPinkBubble.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .scaleEffect(pulsing ? 1.2 : 1.0)
                                        .animation(.easeInOut(duration: 1.5).repeatForever().delay(Double.random(in: 0...1)), value: pulsing)
                                    
                                    Circle()
                                        .fill(Color.lumaPinkBubble)
                                        .frame(width: 24, height: 24)
                                    
                                    Image(systemName: zone.icon)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                }
                            }
                            .position(
                                x: geo.size.width * zone.position.x,
                                y: geo.size.height * zone.position.y
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(item: $selectedZone) { zone in
            BodyZoneDetailView(info: BodyMapContent.info(for: zone, stage: currentStage))
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            pulsing = true
        }
    }
}
