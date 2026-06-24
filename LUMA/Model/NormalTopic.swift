
import Foundation

struct NormalTopic: Identifiable {
  
  let id = UUID()
  
  let title: String
  let shortDescription: String
  
  let whyItHappens: String
  let whenItsNormal: String
  let whatHelps: String
  let whenToSeekHelp: String
  
  let relevantStages: [LifeStage]
  let category: TopicCategory
}
enum TopicCategory: String, CaseIterable {
  case hormones
  case cycle
  case mood
  case health
  
  var displayName: String {
    switch self {
    case .hormones: return "Hormones"
    case .cycle: return "Cycle"
    case .mood: return "Mood"
    case .health: return "Health"
    }
  }
}

extension NormalTopic {
  
  static let allTopics: [NormalTopic] = [
    
   
    NormalTopic(
      title: "Breast Tenderness",
      shortDescription: "Early breast sensitivity.",
      whyItHappens: "Estrogen activates breast tissue growth.",
      whenItsNormal: "Common between ages 8–13.",
      whatHelps: "Supportive clothing and reassurance.",
      whenToSeekHelp: "If extremely early or painful.",
      relevantStages: [.prePuberty],
      category: .hormones
    ),
    
    NormalTopic(
      title: "White Discharge",
      shortDescription: "Clear or milky discharge before first period.",
      whyItHappens: "Hormones prepare the body for menstruation.",
      whenItsNormal: "6–12 months before first period.",
      whatHelps: "Breathable fabrics and hygiene.",
      whenToSeekHelp: "If odor, itching, or unusual color.",
      relevantStages: [.prePuberty],
      category: .health
    ),
    
    NormalTopic(
      title: "Body Odor Changes",
      shortDescription: "New body scent during puberty onset.",
      whyItHappens: "Hormones activate sweat glands.",
      whenItsNormal: "Early puberty.",
      whatHelps: "Daily hygiene, breathable clothing.",
      whenToSeekHelp: "If persistent irritation occurs.",
      relevantStages: [.prePuberty],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Emotional Sensitivity",
      shortDescription: "Heightened emotional responses.",
      whyItHappens: "Hormonal shifts affect mood regulation.",
      whenItsNormal: "Early hormonal transitions.",
      whatHelps: "Open conversations and reassurance.",
      whenToSeekHelp: "If severe anxiety or distress occurs.",
      relevantStages: [.prePuberty],
      category: .mood
    ),
    
    NormalTopic(
      title: "Irregular Cycles",
      shortDescription: "Cycles may not follow a fixed pattern.",
      whyItHappens: "Ovulation is still stabilizing.",
      whenItsNormal: "First 2–3 years after first period.",
      whatHelps: "Cycle tracking and healthy routine.",
      whenToSeekHelp: "If no period for 3+ months.",
      relevantStages: [.puberty],
      category: .cycle
    ),
    
    NormalTopic(
      title: "Acne Flare-ups",
      shortDescription: "Breakouts during hormonal changes.",
      whyItHappens: "Androgens increase oil production.",
      whenItsNormal: "Throughout puberty.",
      whatHelps: "Gentle skincare.",
      whenToSeekHelp: "If severe or scarring.",
      relevantStages: [.puberty],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Mood Swings",
      shortDescription: "Emotional ups and downs.",
      whyItHappens: "Hormone fluctuations affect neurotransmitters.",
      whenItsNormal: "Before or during periods.",
      whatHelps: "Sleep and stress support.",
      whenToSeekHelp: "If affecting school or daily life.",
      relevantStages: [.puberty],
      category: .mood
    ),
    
    NormalTopic(
      title: "Cramps",
      shortDescription: "Lower abdominal pain.",
      whyItHappens: "Uterine contractions from prostaglandins.",
      whenItsNormal: "Mild to moderate discomfort.",
      whatHelps: "Heat and stretching.",
      whenToSeekHelp: "If severe pain.",
      relevantStages: [.puberty],
      category: .cycle
    ),
    
    
    NormalTopic(
      title: "Delayed Cycle",
      shortDescription: "Late period during stress.",
      whyItHappens: "Cortisol delays ovulation.",
      whenItsNormal: "Occasional delay.",
      whatHelps: "Stress management.",
      whenToSeekHelp: "If consistently irregular.",
      relevantStages: [.reproductive],
      category: .cycle
    ),
    
    NormalTopic(
      title: "Breast Tenderness",
      shortDescription: "Soreness before period.",
      whyItHappens: "Progesterone increases fluid retention.",
      whenItsNormal: "Luteal phase.",
      whatHelps: "Supportive bra.",
      whenToSeekHelp: "If persistent.",
      relevantStages: [.reproductive],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Mild Cramps",
      shortDescription: "Lower abdominal discomfort.",
      whyItHappens: "Prostaglandins trigger contractions.",
      whenItsNormal: "1–2 days around period.",
      whatHelps: "Heat pad and hydration.",
      whenToSeekHelp: "If debilitating pain.",
      relevantStages: [.reproductive],
      category: .cycle
    ),
    
    NormalTopic(
      title: "Spotting",
      shortDescription: "Light bleeding between periods.",
      whyItHappens: "Ovulation or hormonal shifts.",
      whenItsNormal: "Mid-cycle spotting occasionally.",
      whatHelps: "Cycle tracking.",
      whenToSeekHelp: "If frequent or heavy.",
      relevantStages: [.reproductive],
      category: .cycle
    ),
 
    NormalTopic(
      title: "Hot Flashes",
      shortDescription: "Sudden warmth episodes.",
      whyItHappens: "Estrogen fluctuations.",
      whenItsNormal: "Perimenopause transition.",
      whatHelps: "Cooling techniques.",
      whenToSeekHelp: "If severe.",
      relevantStages: [.perimenopause],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Sleep Issues",
      shortDescription: "Difficulty sleeping.",
      whyItHappens: "Hormones affect circadian rhythm.",
      whenItsNormal: "Transition years.",
      whatHelps: "Sleep hygiene.",
      whenToSeekHelp: "If persistent insomnia.",
      relevantStages: [.perimenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Brain Fog",
      shortDescription: "Difficulty concentrating.",
      whyItHappens: "Hormonal shifts affect cognition.",
      whenItsNormal: "Perimenopause.",
      whatHelps: "Rest and mental stimulation.",
      whenToSeekHelp: "If severe.",
      relevantStages: [.perimenopause],
      category: .mood
    ),
    
    NormalTopic(
      title: "Irregular Periods",
      shortDescription: "Unpredictable cycle timing.",
      whyItHappens: "Ovulation becomes inconsistent.",
      whenItsNormal: "Transition phase.",
      whatHelps: "Tracking.",
      whenToSeekHelp: "If very heavy bleeding.",
      relevantStages: [.perimenopause],
      category: .cycle
    ),
    
   
    
    NormalTopic(
      title: "Night Sweats",
      shortDescription: "Excess sweating at night.",
      whyItHappens: "Hormonal temperature shifts.",
      whenItsNormal: "Menopause transition.",
      whatHelps: "Cool sleeping environment.",
      whenToSeekHelp: "If extreme.",
      relevantStages: [.menopause],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Vaginal Dryness",
      shortDescription: "Reduced lubrication.",
      whyItHappens: "Lower estrogen levels.",
      whenItsNormal: "After menopause.",
      whatHelps: "Moisturizers.",
      whenToSeekHelp: "If painful.",
      relevantStages: [.menopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Fatigue",
      shortDescription: "Persistent tiredness.",
      whyItHappens: "Sleep disturbance from hormone shifts.",
      whenItsNormal: "Common in menopause.",
      whatHelps: "Rest and balanced diet.",
      whenToSeekHelp: "If severe or unexplained.",
      relevantStages: [.menopause],
      category: .health
    ),
    
    
    NormalTopic(
      title: "Joint Stiffness",
      shortDescription: "Morning stiffness.",
      whyItHappens: "Lower estrogen affects connective tissue.",
      whenItsNormal: "Mild stiffness.",
      whatHelps: "Stretching.",
      whenToSeekHelp: "If swelling.",
      relevantStages: [.postMenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Bone Weakness",
      shortDescription: "Reduced bone density.",
      whyItHappens: "Estrogen decline accelerates bone loss.",
      whenItsNormal: "Gradual change.",
      whatHelps: "Calcium and exercise.",
      whenToSeekHelp: "Frequent fractures.",
      relevantStages: [.postMenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Dry Skin",
      shortDescription: "Reduced skin elasticity.",
      whyItHappens: "Hormonal decline reduces collagen.",
      whenItsNormal: "After menopause.",
      whatHelps: "Hydration.",
      whenToSeekHelp: "If severe irritation.",
      relevantStages: [.postMenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Urinary Changes",
      shortDescription: "Bladder sensitivity.",
      whyItHappens: "Pelvic tissue changes.",
      whenItsNormal: "Post-menopause.",
      whatHelps: "Pelvic exercises.",
      whenToSeekHelp: "If painful urination.",
      relevantStages: [.postMenopause],
      category: .health
    )
  ]
}
