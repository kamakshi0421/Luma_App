import SwiftUI
import Foundation

struct StageRisk: Identifiable {
  
  let id = UUID()
  let stage: LifeStage
  let title: String
  let shortNote: String
  let icon: String
  
  static let all: [StageRisk] = [
    
    
    StageRisk(
      stage: .puberty,
      title: "PCOS tendency",
      shortNote: "Irregular cycles may need tracking.",
      icon: "leaf"
    ),
    
    StageRisk(
      stage: .puberty,
      title: "Iron levels",
      shortNote: "Heavy periods can lower iron.",
      icon: "drop.fill"
    ),
    
    
    StageRisk(
      stage: .reproductive,
      title: "Endometriosis",
      shortNote: "Painful periods shouldn't be ignored.",
      icon: "waveform.path.ecg"
    ),
    
    StageRisk(
      stage: .reproductive,
      title: "Thyroid balance",
      shortNote: "Energy & cycles are connected.",
      icon: "bolt.heart"
    ),
    
    
    StageRisk(
      stage: .perimenopause,
      title: "Bone density",
      shortNote: "Estrogen shifts affect bones.",
      icon: "figure.walk"
    ),
    
    StageRisk(
      stage: .perimenopause,
      title: "Heart health",
      shortNote: "Cardio risk slowly increases.",
      icon: "heart.fill"
    ),
    
    
    StageRisk(
      stage: .menopause,
      title: "Osteoporosis",
      shortNote: "Bone protection becomes important.",
      icon: "figure.stand"
    ),
    
    StageRisk(
      stage: .menopause,
      title: "Cardiovascular risk",
      shortNote: "Heart care matters more now.",
      icon: "heart"
    )
  ]
}
