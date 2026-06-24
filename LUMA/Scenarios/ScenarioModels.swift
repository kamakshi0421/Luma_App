import SwiftUI

enum ChoiceQuality: String {
  case best
  case okay
  case notIdeal
  
  var color: Color {
    switch self {
    case .best: return .green
    case .okay: return .orange
    case .notIdeal: return .red
    }
  }
  
  var icon: String {
    switch self {
    case .best: return "checkmark.circle.fill"
    case .okay: return "exclamationmark.triangle.fill"
    case .notIdeal: return "xmark.circle.fill"
    }
  }
  
  var label: String {
    switch self {
    case .best: return "Great Choice!"
    case .okay: return "Okay, but..."
    case .notIdeal: return "Not Ideal"
    }
  }
}

struct ScenarioChoice: Identifiable {
  let id = UUID()
  let text: String
  let quality: ChoiceQuality
  let explanation: String
  let learnMore: String
}

struct Scenario: Identifiable {
  let id = UUID()
  let title: String
  let situation: String
  let stage: LifeStage
  let choices: [ScenarioChoice]
  let icon: String
}
