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
                name: "Osteoporosis",
                shortDescription: "Bone weakening due to estrogen decline.",
                overview: "Lower estrogen levels reduce bone density, increasing fracture risk.",
                imageName: "osteoporosis_awareness",
                symptoms: [
                    "Back pain",
                    "Loss of height",
                    "Frequent fractures",
                    "Stooped posture"
                ],
                basicCare: [
                    "Calcium & Vitamin D intake",
                    "Weight-bearing exercise",
                    "Bone density testing",
                    "Medical consultation"
                ],
                whenToSeeDoctor: "If you experience fractures or severe back pain."
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
            )
        ]
    )
}
