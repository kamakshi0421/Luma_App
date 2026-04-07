import SwiftUI

struct PhasesView: View {
    
   
    @State private var selectedStage: LifeStage?
    
    let stages: [LifeStage] = [
        .prePuberty, .puberty,
        .reproductive, .perimenopause,
        .menopause, .postMenopause
    ]
    
    var body: some View {
        
        ZStack {
            
            LumaBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    HStack {
                        
                        Spacer()
                        
                        VStack(spacing: 6) {
                            Text("Phases")
                                .font(.title2.bold())
                                .foregroundColor(.lumaDarkGray)
                            
                            Text("Explore every life stage — anytime.")
                                .font(.subheadline)
                                .foregroundColor(.lumaMidGray)
                        }
                        
                        Spacer()
                        
                        GlobalInfoButton(tab: .phases)
                    }
                    .padding(.horizontal)
                    
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
        }
        .navigationDestination(item: $selectedStage) { stage in
            LifeStageDetailView(stage: stage)
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
                .foregroundColor(.lumaDarkGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(height: 190) 
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
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
                .foregroundColor(.lumaMidGray)
        }
    }
}


