import SwiftUI

import Foundation

struct PerimenopauseContent {
  
  static let data = StageContent(

    
    commonInfo: """
    Perimenopause is the transitional phase before menopause.
    
    It usually begins in the early to mid-40s, but can start earlier.
    
    During this time:
    • Ovulation becomes irregular
    • Estrogen levels fluctuate (up & down)
    • Progesterone gradually declines
    • Cycle length may shorten first, then become irregular
    
    Periods still occur — but unpredictably.
   """,
    
    hormoneInfo: """
    The ovaries begin reducing hormone production.
    
    Key changes:
    
    • Estrogen fluctuates unpredictably
    • Progesterone declines due to skipped ovulation
    • FSH levels gradually increase
    
    Hormonal instability (not absence) causes most symptoms.
    
    This phase can last 4–8 years before menopause.
   """,
    
    
    
    concerns: """
    Common experiences include:
    
    • Irregular or heavy periods
    • Shorter cycles
    • Hot flashes
    • Night sweats
    • Sleep disturbance
    • Mood shifts
    • Brain fog
    • Weight changes
    
    These are due to hormone fluctuation — not weakness.
   """,
    
        
    careTips: """
    Supportive habits during perimenopause:
    
    • Strength training for bone support
    • Adequate protein intake
    • Vitamin D & calcium awareness
    • Sleep hygiene routines
    • Stress management (breathing, yoga)
    • Regular health checkups
    
    Small consistent habits matter more than extremes.
   """,
    
  
    
    miniInsights: [
      
      MiniInsight(
        title: "Cycle Confusion",
        text: "Shorter cycles are often the first sign of perimenopause."
      ),
      
      MiniInsight(
        title: "Mood & Brain Changes",
        text: "Estrogen affects brain chemistry, influencing mood and focus."
      ),
      
      MiniInsight(
        title: "Heavy Bleeding",
        text: "Very heavy or prolonged bleeding should be medically evaluated."
      ),
      
      MiniInsight(
        title: "Not Menopause Yet",
        text: "Menopause is confirmed only after 12 months without a period."
      )
    ],
    
   
    
    didYouKnow: [
     "Perimenopause can last several years before menopause.",
     "You can still become pregnant during perimenopause.",
     "Symptoms vary widely between individuals.",
     "Stress can intensify hot flashes and sleep issues."
    ],
    
    
    
    conditions: [
      
      StageCondition(
        name: "Heavy Menstrual Bleeding",
        shortDescription: "Unusually heavy or prolonged periods during transition.",
        overview: """
        Hormonal imbalance during perimenopause can cause the uterine lining to build up excessively, leading to heavy bleeding.
       """,
        imageName: "heavy_bleeding_peri",
        symptoms: [
         "Bleeding lasting more than 8 days",
         "Soaking pads every 1–2 hours",
         "Large blood clots",
         "Fatigue from blood loss"
        ],
        basicCare: [
         "Track cycle changes",
         "Iron-rich diet",
         "Medical evaluation if severe"
        ],
        whenToSeeDoctor: "If bleeding interferes with daily life or causes dizziness."
      ),
      
      
      StageCondition(
        name: "Thyroid Imbalance",
        shortDescription: "Hormone shifts may overlap with thyroid symptoms.",
        overview: """
        Thyroid disorders can mimic perimenopause symptoms like fatigue, weight changes, and mood shifts.
       """,
        imageName: "thyroid_awareness",
        symptoms: [
         "Extreme fatigue",
         "Sudden weight changes",
         "Hair thinning",
         "Cold sensitivity"
        ],
        basicCare: [
         "Routine thyroid testing",
         "Balanced nutrition",
         "Medical consultation"
        ],
        whenToSeeDoctor: "If symptoms are persistent or worsening."
      )
    ]
  )
}
