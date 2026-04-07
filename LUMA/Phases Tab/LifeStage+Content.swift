import SwiftUI
import SwiftUI
import Foundation

extension LifeStage {
    
    var content: StageContent {
        switch self {
        
        case .prePuberty:
            return PrePubertyContent.data
            
        case .puberty:
            return PubertyContent.data 
            
        case .reproductive:
            return ReproductiveContent.data
        
        case .perimenopause:
            return PerimenopauseContent.data
            
        case .menopause:
            return MenopauseContent.data
    
            
        case .postMenopause:
            return PostMenopauseContent.data
            
            
        }
    }
}
