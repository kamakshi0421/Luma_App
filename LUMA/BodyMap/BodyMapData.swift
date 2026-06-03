import SwiftUI

enum BodyZone: String, CaseIterable, Identifiable {
    case brain, skin, breasts, heart, uterus, ovaries, bones, joints
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .brain: return "brain.head.profile"
        case .skin: return "sparkles"
        case .breasts: return "lungs.fill" // Approximation
        case .heart: return "heart.fill"
        case .uterus: return "oval.portrait.fill" // Approximation
        case .ovaries: return "circles.hexagongrid.fill"
        case .bones: return "figure.stand"
        case .joints: return "link"
        }
    }
    
    var position: CGPoint {
        // Relative coordinates (0.0 to 1.0) on a body outline
        switch self {
        case .brain: return CGPoint(x: 0.5, y: 0.1)
        case .skin: return CGPoint(x: 0.25, y: 0.3)
        case .breasts: return CGPoint(x: 0.5, y: 0.35)
        case .heart: return CGPoint(x: 0.55, y: 0.4)
        case .uterus: return CGPoint(x: 0.5, y: 0.6)
        case .ovaries: return CGPoint(x: 0.4, y: 0.65)
        case .bones: return CGPoint(x: 0.3, y: 0.75)
        case .joints: return CGPoint(x: 0.5, y: 0.85)
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
