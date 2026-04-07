import SwiftUI
import Foundation

struct LumaInsightEngine {
    
    static func generateInsights(
        stage: LifeStage,
        logs: [SymptomLog]
    ) -> [String] {
        
        guard logs.count >= 3 else { return [] }
        
        var insights: [String] = []
        
        let heavyFlow = logs.filter { $0.flow == "Heavy" }.count
        let highStress = logs.filter { $0.stress >= 4 }.count
        
        switch stage {
            
        case .reproductive:
            
            if heavyFlow >= 2 {
                insights.append(
                    "Frequent heavy bleeding logged. Consider monitoring iron levels."
                )
            }
            
            if highStress >= 3 {
                insights.append(
                    "Elevated stress may influence cycle timing."
                )
            }
            
        case .menopause:
            
            if heavyFlow > 0 {
                insights.append(
                    "Bleeding after menopause should be medically evaluated."
                )
            }
            
        default:
            break
        }
        
        return insights
    }
}
