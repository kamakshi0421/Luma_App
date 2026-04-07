import SwiftUI

import Foundation

struct MythFact: Identifiable {
    let id = UUID()
    let myth: String
    let fact: String
    let stage: LifeStage
}

extension MythFact {
    
    static let sampleData: [MythFact] = [
        
        MythFact(
            myth: "You cannot get pregnant during your first period.",
            fact: "Ovulation can happen before the first visible period, so pregnancy is biologically possible.",
            stage: .puberty
        ),
        
        MythFact(
            myth: "Stress cannot delay periods.",
            fact: "High stress levels can affect hormone balance and delay ovulation, which may delay periods.",
            stage: .reproductive
        ),
        
        MythFact(
            myth: "Hot flashes only happen after menopause.",
            fact: "Hot flashes often begin during perimenopause, before periods fully stop.",
            stage: .perimenopause
        ),
        
        MythFact(
            myth: "Bone health doesn’t need attention after menopause.",
            fact: "Estrogen decline after menopause increases osteoporosis risk, making bone health very important.",
            stage: .postMenopause
        )
    ]
}
