import SwiftUI

struct PhasesView: View {
    
   
    @State private var selectedStage: LifeStage?
    @State private var showPlayground = false
    @State private var showUterusSimulator = false
    
    let stages: [LifeStage] = [
        .prePuberty, .puberty,
        .reproductive, .perimenopause,
        .menopause, .postMenopause
    ]
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 24) {
                    
                    Text("Explore every life stage — anytime.")
                        .font(.subheadline)
                        .foregroundColor(.lumaMidGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Interactive Playground Banner
                    Button {
                        showPlayground = true
                    } label: {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Cycle Insights")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Explore hormone cycles visually")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "waveform.path.ecg")
                                .font(.title)
                                .foregroundColor(.lumaPinkBubble)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.lumaPinkBubble.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.lumaPinkBubble.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: Color.lumaPinkBubble.opacity(0.08), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                    
                    // Uterus Simulator Banner
                    Button {
                        showUterusSimulator = true
                    } label: {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Phase Simulator")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Visually explore Phases, Conditions, and Organs")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "sparkles")
                                .font(.title)
                                .foregroundColor(.purple.opacity(0.7))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.purple.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.purple.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: Color.purple.opacity(0.08), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {
                        ForEach(stages, id: \.self) { stage in
                            
                            Button {
                                selectedStage = stage
                            } label: {
                                LifeStageCard(stage: stage)
                            }
                        }
                    }
                }
                .padding()
            }
        .background {
            LumaBackground()
        }
        .navigationTitle("Phases")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                GlobalInfoButton(tab: .phases)
            }
        }
        .navigationDestination(item: $selectedStage) { stage in
            LifeStageDetailView(stage: stage)
        }
        .navigationDestination(isPresented: $showPlayground) {
            InteractivePlaygroundView()
        }
        .navigationDestination(isPresented: $showUterusSimulator) {
            UterusSimulatorView()
        }
        
    }
}

struct LifeStageCard: View {
    
    let stage: LifeStage
    
    var body: some View {
        VStack(spacing: 12) {
            
           
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.lumaPinkLight.opacity(0.25))
                
                if let uiImage = UIImage(named: stage.imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding(12)
                } else {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.lumaPinkBubble)
                }
            }
            .frame(height: 110)
            
           
            Text(stage.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
                
            HStack(spacing: 4) {
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.purple)
                Text("Live the Story")
                    .font(.caption2)
                    .foregroundColor(.purple)
            }
            .padding(.top, -4)
        }
        .padding()
        .frame(height: 190) 
        .liquidGlass(cornerRadius: 22)
    }
}


struct InfoBlock: View {
    
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.lumaPinkBubble)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}


