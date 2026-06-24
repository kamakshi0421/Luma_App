import SwiftUI
import Foundation

enum LifeStage: String, CaseIterable, Identifiable, Codable {
  
  case prePuberty
  case puberty
  case reproductive
  case perimenopause
  case menopause
  case postMenopause
  
  var id: String { rawValue }
  
  static func stage(for age: Int) -> LifeStage {
    switch age {
    case 0...9:
      return .prePuberty
    case 10...15:
      return .puberty
    case 16...44:
      return .reproductive
    case 45...50:
      return .perimenopause
    case 51...55:
      return .menopause
    default:
      return .postMenopause
    }
  }
}
extension LifeStage {
  
  var title: String {
    switch self {
    case .prePuberty: return "Pre-Puberty"
    case .puberty: return "Puberty"
    case .reproductive: return "Reproductive Phase"
    case .perimenopause: return "Perimenopause"
    case .menopause: return "Menopause"
    case .postMenopause: return "Post-Menopause"
    }
  }
  
  var description: String {
    switch self {
    case .prePuberty:
      return "Your body is gradually preparing for future changes."
    case .puberty:
      return "Hormones activate growth and your cycle may begin."
    case .reproductive:
      return "Hormones are active and cycles are more stable."
    case .perimenopause:
      return "Your body is transitioning toward menopause."
    case .menopause:
      return "Periods stop and hormone levels shift significantly."
    case .postMenopause:
      return "Your body has adjusted to a new hormonal balance."
    }
  }
  
  var imageName: String {
    switch self {
    case .prePuberty: return "stage_pre_puberty"
    case .puberty: return "stage_puberty"
    case .reproductive: return "stage_reproductive"
    case .perimenopause: return "stage_perimenopause"
    case .menopause: return "stage_menopause"
    case .postMenopause: return "stage_post_menopause"
    }
  }
}
extension LifeStage {
  
  static func from(title: String) -> LifeStage {
    return LifeStage.allCases.first {
      $0.title == title
    } ?? .reproductive
  }
}
extension LifeStage {
  
  var order: Int {
    switch self {
    case .prePuberty: return 0
    case .puberty: return 1
    case .reproductive: return 2
    case .perimenopause: return 3
    case .menopause: return 4
    case .postMenopause: return 5
    }
  }
}
