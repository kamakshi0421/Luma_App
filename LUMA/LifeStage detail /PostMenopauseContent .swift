import SwiftUI
import Foundation

struct PostMenopauseContent {
  
  static let data = StageContent(
    
    
    commonInfo: """
    Post-menopause begins after 12 consecutive months without a period.
    
    Your reproductive years have ended,
    but your body continues adjusting hormonally.
    
    Common experiences:
    • No menstrual cycles
    • Reduced estrogen levels
    • Slower metabolism
    • Skin thinning
    • Vaginal dryness
    
    Many women feel more emotionally stable in this phase.
   """,
    
    
    hormoneInfo: """
    Estrogen and progesterone remain at consistently low levels.
    
    Effects of lower estrogen:
    • Reduced bone density
    • Higher cholesterol changes
    • Skin elasticity decline
    • Vaginal tissue thinning
    
    The body shifts toward long-term metabolic balance.
   """,
    
  
    concerns: """
    • Osteoporosis risk
    • Cardiovascular health risk
    • Urinary tract infections
    • Vaginal dryness
    • Joint stiffness
    • Weight changes
    
    Regular screening becomes important in this stage.
   """,
    
    
    careTips: """
    • Bone density scans
    • Calcium + Vitamin D
    • Strength training
    • Heart health monitoring
    • Hydration
    • Pelvic floor exercises
    
    Preventive care supports long-term wellbeing.
   """,
    
    
    miniInsights: [
      MiniInsight(
        title: "Bone Density Monitoring",
        text: "Fracture risk increases without estrogen support."
      ),
      MiniInsight(
        title: "Heart Health Priority",
        text: "Heart disease risk rises after menopause."
      ),
      MiniInsight(
        title: "Muscle Strength Matters",
        text: "Strength training protects bones and metabolism."
      )
    ],
    
    
    didYouKnow: [
     "Post-menopause lasts for the rest of life.",
     "Bone loss is fastest in the first few years after menopause.",
     "Regular exercise reduces fracture risk significantly."
    ],
    
    
    
    conditions: [
      
      StageCondition(
        name: "Osteoporosis",
        shortDescription: "Bone weakening after estrogen decline.",
        overview: "Post-menopause significantly increases the risk of bone density loss, leading to fragile bones.",
        imageName: "osteoporosis_awareness",
        symptoms: [
         "Frequent fractures",
         "Back pain",
         "Loss of height",
         "Stooped posture"
        ],
        basicCare: [
         "Calcium-rich diet",
         "Vitamin D supplementation",
         "Weight-bearing exercise",
         "Bone density tests"
        ],
        whenToSeeDoctor: "If you experience fractures or persistent back pain."
      ),
      
      StageCondition(
        name: "Cardiovascular Disease Risk",
        shortDescription: "Increased heart and blood vessel risk.",
        overview: "Lower estrogen levels may increase cholesterol and blood pressure, raising heart disease risk.",
        imageName: "heart_health_awareness",
        symptoms: [
         "Chest discomfort",
         "Shortness of breath",
         "Unusual fatigue",
         "High blood pressure"
        ],
        basicCare: [
         "Routine blood pressure checks",
         "Healthy diet",
         "Regular exercise",
         "Cholesterol monitoring"
        ],
        whenToSeeDoctor: "Immediately if chest pain or breathing difficulty occurs."
      )
    ]
  )
}
