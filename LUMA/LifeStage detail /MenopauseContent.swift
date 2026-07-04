import SwiftUI

import Foundation

struct MenopauseContent {
  
  static let data = StageContent(
   
    
    commonInfo: """
    Menopause is confirmed after 12 consecutive months without a menstrual period.
    
    It usually occurs between ages 45–55.
    
    This stage marks the natural end of reproductive years.
    
    Common physical changes:
    • Hot flashes
    • Night sweats
    • Irregular cycles before stopping
    • Sleep disturbances
    • Vaginal dryness
    
    Every experience is unique.
   """,
    
    
    hormoneInfo: """
    Estrogen and progesterone levels decline significantly.
    
    This affects:
    • Body temperature regulation
    • Bone density
    • Skin elasticity
    • Mood balance
    • Metabolism
    
    The ovaries gradually stop releasing eggs.
   """,
    
    
    concerns: """
    • Hot flashes
    • Mood shifts
    • Weight gain (especially abdomen)
    • Brain fog
    • Joint stiffness
    • Reduced libido
    
    Symptoms vary in intensity and duration.
   """,
    
    careTips: """
    • Strength training for bone health
    • Calcium & Vitamin D
    • Balanced nutrition
    • Regular physical activity
    • Stress management
    • Hydration
    
    Medical support may help if symptoms are severe.
   """,
    
    miniInsights: [
      MiniInsight(
        title: "Bone Health Matters",
        text: "Estrogen decline increases osteoporosis risk."
      ),
      MiniInsight(
        title: "Heart Health Awareness",
        text: "Cardiovascular risk increases after menopause."
      )
    ],
    
    didYouKnow: [
     "Hot flashes can last 1–5 years.",
     "Sleep changes are hormone-related.",
     "Skin may become thinner due to estrogen loss."
    ],
    
    conditions: [
      
      StageCondition(
        name: "Insomnia & Sleep Disturbances",
        shortDescription: "Disrupted sleep patterns due to hormonal shifts.",
        overview: "Fluctuating hormones, especially drops in estrogen and progesterone, can severely disrupt sleep architecture, leading to frequent waking, night sweats, and difficulty falling asleep.",
        imageName: "insomnia_awareness",
        symptoms: [
         "Difficulty falling asleep",
         "Waking up frequently during the night",
         "Night sweats and hot flashes",
         "Daytime fatigue and brain fog"
        ],
        basicCare: [
         "Maintain a cool sleeping environment",
         "Establish a relaxing bedtime routine",
         "Limit caffeine and screen time before bed",
         "Consider cognitive behavioral therapy for insomnia (CBT-I)"
        ],
        whenToSeeDoctor: "If sleep disturbances significantly impact your daily life, mood, or cognitive function."
      ),
      
      StageCondition(
        name: "Cardiovascular Risk",
        shortDescription: "Increased heart health risk after menopause.",
        overview: "Hormonal shifts can increase cholesterol and blood pressure.",
        imageName: "heart_health_awareness",
        symptoms: [
         "Chest discomfort",
         "Shortness of breath",
         "Fatigue",
         "Irregular heartbeat"
        ],
        basicCare: [
         "Regular health screening",
         "Balanced diet",
         "Exercise routine",
         "Stress reduction"
        ],
        whenToSeeDoctor: "Immediately if experiencing chest pain or breathing difficulty."
      ),
      
      StageCondition(
        name: "Osteoporosis",
        shortDescription: "Bone thinning and increased fracture risk.",
        overview: "The drop in estrogen levels during menopause significantly accelerates bone loss, leading to fragile bones and a higher risk of fractures.",
        imageName: "osteoporosis_awareness",
        symptoms: [
         "Back pain (caused by fractured or collapsed vertebra)",
         "Loss of height over time",
         "A stooped posture",
         "Bone fractures that occur much more easily than expected"
        ],
        basicCare: [
         "Adequate calcium and Vitamin D intake",
         "Weight-bearing exercises",
         "Fall prevention strategies"
        ],
        whenToSeeDoctor: "For routine DEXA scans or if you experience a bone fracture from a minor fall."
      )
    ]
  )
}
