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
          
          // Interactive Playground Banner
          PastelActionCard(
            title: "Cycle Insights",
            subtitle: "Explore hormone cycles visually",
            icon: "waveform.path.ecg",
            tint: .lumaPinkBubble,
            iconColor: .lumaPinkBubble
          ) {
            showPlayground = true
          }
          
          // Uterus Simulator Banner
          PastelActionCard(
            title: "Phase Simulator",
            subtitle: "Interactive 3D organ explorer",
            icon: "sparkles",
            tint: .purple,
            iconColor: .purple
          ) {
            showUterusSimulator = true
          }
          
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
        .padding(.bottom, 130) // Ensure enough space for bottom tab bar and mascot
      }
    .background {
      LumaBackground()
    }
    .navigationTitle("Phases")
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
          .fill(stage.themeColor.opacity(0.25))
        
        if let uiImage = UIImage(named: stage.imageName) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .padding(12)
        } else {
          Image(systemName: "leaf.fill")
            .font(.system(size: 36))
            .foregroundColor(stage.themeColor)
        }
      }
      .frame(height: 110)
      
      Text(stage.title)
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity)
    }
    .padding()
    .frame(height: 170) // Reduced height since we removed the button
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


