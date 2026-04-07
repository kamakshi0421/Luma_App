import Foundation

struct ReproductiveContent {
    
    static let data = StageContent(
        
      
        commonInfo: """
        The reproductive phase is when menstrual cycles become more regular.
        
        Ovulation typically occurs monthly,
        and fertility is highest in this stage.
        
        Common experiences:
        • Predictable cycles (21–35 days)
        • Ovulation symptoms (mild pain, discharge)
        • PMS before periods
        • Hormonal mood shifts
        
        Energy levels may fluctuate across the cycle.
        """,
        
        
        hormoneInfo: """
        The menstrual cycle follows a hormonal rhythm:
        
        • FSH – stimulates egg development
        • Estrogen – thickens uterine lining
        • LH – triggers ovulation
        • Progesterone – supports potential pregnancy
        
        Hormones rise and fall in a monthly pattern.
        These fluctuations influence mood, sleep, appetite, and skin.
        """,
        
        
        
        concerns: """
        • PMS symptoms
        • Painful periods (dysmenorrhea)
        • Heavy bleeding
        • Cycle irregularity
        • Acne or hormonal breakouts
        
        Most symptoms are manageable,
        but persistent irregularities need evaluation.
        """,
        
        
        
        careTips: """
        • Track menstrual cycle
        • Balanced nutrition
        • Iron intake if heavy bleeding
        • Regular physical activity
        • Stress management
        • Annual gynecological check-ups
        
        Body awareness builds long-term reproductive health.
        """,
        
        
        
        miniInsights: [
            
            MiniInsight(
                title: "Ovulation Window",
                text: "Fertility peaks 1–2 days before ovulation."
            ),
            
            MiniInsight(
                title: "PMS vs PMDD",
                text: "Severe mood changes before periods may indicate PMDD."
            ),
            
            MiniInsight(
                title: "Cycle Phases Matter",
                text: "Energy and metabolism shift in each phase of the cycle."
            )
        ],
        
      
        
        didYouKnow: [
            "Basal body temperature rises after ovulation.",
            "Cervical mucus changes during fertile days.",
            "Cycle length may vary slightly month to month."
        ],
        
        
        
        conditions: [
            
            StageCondition(
                name: "Polycystic Ovary Syndrome (PCOS)",
                shortDescription: "Hormonal imbalance affecting ovulation.",
                overview: "PCOS is a hormonal disorder that can cause irregular periods, acne, weight gain, and difficulty with ovulation.",
                imageName: "pcos_awareness",
                symptoms: [
                    "Irregular or absent periods",
                    "Excess facial/body hair",
                    "Persistent acne",
                    "Weight gain around abdomen"
                ],
                basicCare: [
                    "Balanced low-glycemic diet",
                    "Regular exercise",
                    "Stress management",
                    "Medical consultation for treatment options"
                ],
                whenToSeeDoctor: "If cycles remain highly irregular or pregnancy is difficult after trying."
            ),
            
            StageCondition(
                name: "Endometriosis",
                shortDescription: "Painful condition affecting uterine lining.",
                overview: "Endometriosis occurs when tissue similar to the uterine lining grows outside the uterus, causing pain and inflammation.",
                imageName: "endometriosis_awareness",
                symptoms: [
                    "Severe menstrual pain",
                    "Pain during intercourse",
                    "Chronic pelvic pain",
                    "Heavy periods"
                ],
                basicCare: [
                    "Pain management strategies",
                    "Medical evaluation",
                    "Hormonal treatment (if prescribed)",
                    "Regular monitoring"
                ],
                whenToSeeDoctor: "If pain disrupts daily life or periods are extremely painful."
            )
        ]
    )
}
