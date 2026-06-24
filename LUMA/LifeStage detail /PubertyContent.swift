import SwiftUI
import Foundation

struct PubertyContent {
  
  static let data = StageContent(
    
    
    commonInfo: """
    Puberty is the developmental phase when the body begins maturing sexually and physically.
    
    It usually begins between ages 8–13 in girls.
    
    Physical changes may include:
    • Breast development (thelarche)
    • Growth spurts
    • Hip widening
    • Body and underarm hair
    • Oily skin and acne
    • First menstrual period (menarche)
    
    The first few years often involve irregular cycles.
    This happens because ovulation is still developing.
   """,
    
    
    hormoneInfo: """
    Puberty is controlled by the hypothalamic–pituitary–ovarian (HPO) axis.
    
    Key hormones involved:
    
    • GnRH – activates puberty signals
    • FSH – stimulates ovarian follicle growth
    • LH – triggers ovulation
    • Estrogen – develops breasts and uterus
    • Growth hormone – increases height
    
    Estrogen levels rise gradually, causing visible body changes.
    
    Early cycles may not release an egg (anovulatory cycles),
    which explains irregular periods.
   """,
    
    
    
    concerns: """
    Common and usually normal:
    
    • Irregular periods (first 1–3 years)
    • Mild to moderate cramps
    • Acne outbreaks
    • Mood swings
    • Vaginal discharge (clear/white)
    
    When to seek medical guidance:
    
    • No period by age 15
    • Periods lasting more than 8 days
    • Extremely heavy bleeding (soaking pad hourly)
    • Severe pain causing fainting
    • Periods stopping for 6+ months after starting
   """,
    
    
    
    careTips: """
    Physical Care:
    • Sleep 8–9 hours nightly
    • Iron-rich foods (lentils, spinach, beans)
    • Protein intake for growth
    • Hydration
    • Moderate exercise
    
    Skin Care:
    • Gentle cleanser
    • Avoid harsh scrubbing
    
    Emotional Care:
    • Open conversations with trusted adults
    • Journaling feelings
    • Avoid comparing body development
    
    Tracking periods builds confidence and body awareness.
   """,
    
    
    miniInsights: [
      
      MiniInsight(
        title: "Cycle Regulation Takes Time",
        text: "It may take 2–3 years after the first period for cycles to become predictable."
      ),
      
      MiniInsight(
        title: "Anovulatory Cycles Are Common",
        text: "Early cycles may not involve ovulation, which is why timing varies."
      ),
      
      MiniInsight(
        title: "PCOS Early Awareness",
        text: "Persistent irregular periods, severe acne, and excess hair growth may need evaluation."
      ),
      
      MiniInsight(
        title: "Iron & Fatigue",
        text: "Heavy bleeding can lower iron levels and cause tiredness."
      ),
      
      MiniInsight(
        title: "Brain Development",
        text: "Emotional regulation develops gradually; strong emotions are normal."
      )
    ],
    
    
    
    didYouKnow: [
     "Breast development often begins 2–3 years before the first period.",
     "Growth spurts usually occur before menstruation starts.",
     "Stress can delay periods temporarily.",
     "Clear vaginal discharge before periods is normal.",
     "The average age of first period worldwide is around 12–13 years."
    ]
    , conditions: [
      
      StageCondition(
        name: "Early PCOS Awareness",
        shortDescription: "Hormonal imbalance affecting cycle regulation.",
        overview: "PCOS (Polycystic Ovary Syndrome) can begin developing during late puberty and adolescence.",
         imageName: "pcos_awareness",
        symptoms: [
         "Very irregular periods",
         "Severe acne",
         "Excess facial/body hair",
         "Weight gain around abdomen"
        ],
        basicCare: [
         "Balanced nutrition",
         "Regular physical activity",
         "Stress management",
         "Medical consultation if persistent"
        ],
        whenToSeeDoctor: "If periods remain highly irregular 2–3 years after starting."
      ),
      
      StageCondition(
        name: "Iron Deficiency Anemia",
        shortDescription: "Low iron levels due to heavy bleeding.",
        overview: "Heavy periods can sometimes reduce iron levels in the body.",
         imageName: "anemia_awareness", 
          symptoms: [
         "Extreme tiredness",
         "Pale skin",
         "Shortness of breath",
         "Dizziness"
        ],
        basicCare: [
         "Iron-rich foods",
         "Doctor-advised supplements",
         "Monitoring heavy bleeding"
        ],
        whenToSeeDoctor: "If fatigue is severe or bleeding soaks pads hourly."
      ),
      
      StageCondition(
        name: "Dysmenorrhea",
        shortDescription: "Severe menstrual cramps.",
        overview: "While some cramping is normal, severe cramps that prevent you from attending school or doing normal activities are not.",
        imageName: "dysmenorrhea_awareness",
        symptoms: [
         "Debilitating lower abdominal pain",
         "Nausea or vomiting",
         "Radiating pain to the lower back"
        ],
        basicCare: [
         "Heating pads",
         "Over-the-counter pain relief",
         "Light exercise like stretching"
        ],
        whenToSeeDoctor: "If pain is not relieved by OTC medicine or causes you to miss school."
      )
    ]
    
  )
}

