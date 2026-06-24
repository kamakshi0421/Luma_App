import SwiftUI

import Foundation

struct PrePubertyContent {
  
  static let data = StageContent(
  
    
    commonInfo: """
    Pre-puberty is the childhood phase before hormonal activation begins.
    
    During this stage:
    • Growth and brain development are rapid
    • Reproductive system is inactive
    • Hormones remain at baseline levels
    
    The body is gradually preparing for future changes.
   """,
    
    
    
    hormoneInfo: """
    The hypothalamic–pituitary–ovarian (HPO) axis remains quiet.
    
    Estrogen and progesterone levels are very low.
    
    Growth hormone plays a major role in height and physical development.
    
    Puberty begins only when hormonal signaling activates.
   """,
    
    
    
    concerns: """
    Most children in this stage:
    
    • Have steady height growth
    • Do not show breast development
    • Do not have body hair changes
    • Do not menstruate
    
    Variation in growth patterns is normal.
   """,
    
    
    
    careTips: """
    • Balanced nutrition
    • Physical activity
    • Proper sleep (9–11 hours)
    • Emotional support
    • Regular pediatric checkups
    
    Healthy routines support long-term development.
   """,
    
    
    miniInsights: [
      
      MiniInsight(
        title: "Growth Matters",
        text: "Consistent height growth is a positive developmental sign."
      ),
      
      MiniInsight(
        title: "Puberty Timing Varies",
        text: "Every child enters puberty at a different age."
      ),
      
      MiniInsight(
        title: "Emotional Foundation",
        text: "Early emotional support strengthens adolescent wellbeing."
      )
    ],
    
    
    didYouKnow: [
     "The average age of puberty onset varies globally.",
     "Brain development continues rapidly in childhood.",
     "Genetics strongly influence growth patterns."
    ],
    
        
    conditions: [
      
      StageCondition(
        name: "Early Puberty (Precocious Puberty)",
        shortDescription: "Puberty signs appearing before age 8.",
        overview: "Early hormonal activation can cause breast development or body hair growth earlier than expected.",
        imageName: "early_puberty_awareness",
        symptoms: [
         "Breast development before age 8",
         "Early body hair",
         "Rapid height growth",
         "Body odor changes"
        ],
        basicCare: [
         "Monitor growth changes",
         "Consult pediatrician",
         "Hormonal evaluation if needed"
        ],
        whenToSeeDoctor: "If puberty signs appear unusually early."
      ),
      
      
      StageCondition(
        name: "Delayed Development",
        shortDescription: "Slower-than-expected physical growth.",
        overview: "Delayed growth or absence of developmental milestones may require medical assessment.",
        imageName: "delayed_growth_awareness",
        symptoms: [
         "No breast development by age 13",
         "Very slow height progression",
         "Low energy levels"
        ],
        basicCare: [
         "Growth tracking",
         "Balanced nutrition",
         "Medical evaluation if concerned"
        ],
        whenToSeeDoctor: "If development milestones are significantly delayed."
      )
    ]
  )
}
