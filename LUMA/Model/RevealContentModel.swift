import Foundation

struct RevealContent: Codable {
    let myths: [DecodedMyth]
    let commonConcerns: [CommonConcern]
    let redFlags: [StageRedFlag]
}

enum MythCategory: String, Codable, CaseIterable, Identifiable {
    case hormones
    case cycle
    case mood
    case health
    
    var id: String { rawValue }
    
    var title: String {
        rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .hormones: return "waveform.path.ecg"
        case .cycle: return "arrow.triangle.2.circlepath"
        case .mood: return "face.smiling"
        case .health: return "heart.text.square"
        }
    }
}

struct DecodedMyth: Codable, Identifiable, Hashable {
    var id: String { stage.rawValue + category.rawValue + myth }
    
    let stage: LifeStage
    let category: MythCategory
    let myth: String
    let fact: String
    let source: String
}

struct CommonConcern: Codable, Identifiable, Hashable {
    var id: String { stage.rawValue + title }
    
    let stage: LifeStage
    let title: String
    let explanation: String
}

struct StageRedFlag: Codable, Identifiable, Hashable {
    var id: String { stage.rawValue }
    
    let stage: LifeStage
    let points: [String]
}
