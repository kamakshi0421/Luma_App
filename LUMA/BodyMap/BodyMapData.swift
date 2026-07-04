import SwiftUI

enum BodyZone: String, CaseIterable, Identifiable {
  case brain, skin, breasts, heart, uterus, ovaries, bones, joints
  
  var id: String { rawValue }
  
  var displayName: String {
    return rawValue.capitalized
  }
  
  var icon: String {
    switch self {
    case .brain: return "brain"
    case .skin: return "face.smiling"
    case .breasts: return "circle.circle"
    case .heart: return "heart.fill"
    case .uterus: return "drop.fill" // Represents menstrual cycle/flow
    case .ovaries: return "circle.grid.2x2.fill"
    case .bones: return "dumbbell.fill" // Represents bone density and strength
    case .joints: return "link"
    }
  }
  
  var position: CGPoint {
    // Relative coordinates (0.0 to 1.0) on a body outline
    switch self {
    case .brain: return CGPoint(x: 0.50, y: 0.23)
    case .skin: return CGPoint(x: 0.38, y: 0.35)
    case .breasts: return CGPoint(x: 0.48, y: 0.48)
    case .heart: return CGPoint(x: 0.58, y: 0.42)
    case .uterus: return CGPoint(x: 0.50, y: 0.62)
    case .ovaries: return CGPoint(x: 0.42, y: 0.56)
    case .bones: return CGPoint(x: 0.62, y: 0.66)
    case .joints: return CGPoint(x: 0.38, y: 0.66)
    }
  }
}

struct BodyZoneInfo {
  let zone: BodyZone
  let stage: LifeStage
  let title: String
  let description: String
  let hormoneEffect: String
  let careTip: String
}

struct BodyMapContent {
  static func info(for zone: BodyZone, stage: LifeStage) -> BodyZoneInfo {
    // Fallback default info for all zones/stages to ensure fast loading
    return BodyZoneInfo(
      zone: zone,
      stage: stage,
      title: "\(zone.displayName) & \(stage.title)",
      description: "Your \(zone.rawValue) undergoes amazing changes during \(stage.title).",
      hormoneEffect: "Hormonal shifts directly impact how your \(zone.rawValue) functions.",
      careTip: "Stay hydrated, exercise regularly, and listen to your body's signals."
    )
  }
}
