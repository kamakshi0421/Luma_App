
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
      shortDescription: "Early breast sensitivity and mild discomfort.",
      whyItHappens: "Rising estrogen levels activate new breast tissue growth and milk duct development.",
      whenItsNormal: "Very common and expected between the ages of 8 and 13.",
      whatHelps: "Wearing comfortable, supportive clothing or a soft training bra, along with gentle reassurance.",
      whenToSeekHelp: "If development begins extremely early (before age 8) or if there is severe, localized pain.",
      relevantStages: [.prePuberty],
      category: .hormones
    ),
    
    NormalTopic(
      title: "White Discharge",
      shortDescription: "Clear or slightly milky discharge before the first period.",
      whyItHappens: "New hormonal activity prepares the body for future menstruation and cleans the vaginal canal naturally.",
      whenItsNormal: "Typically begins 6 to 12 months before a girl gets her very first period.",
      whatHelps: "Wearing breathable cotton fabrics, maintaining gentle daily hygiene, and using panty liners if preferred.",
      whenToSeekHelp: "If accompanied by a strong odor, severe itching, burning, or a yellowish-green color.",
      relevantStages: [.prePuberty],
      category: .health
    ),
    
    NormalTopic(
      title: "Body Odor Changes",
      shortDescription: "A noticeable new body scent as puberty begins.",
      whyItHappens: "Hormones activate apocrine sweat glands, which produce a different type of sweat that interacts with skin bacteria.",
      whenItsNormal: "Perfectly normal during early puberty and throughout teenage years.",
      whatHelps: "Daily washing with mild soap, changing clothes regularly, and using a gentle deodorant.",
      whenToSeekHelp: "If persistent skin irritation or painful cysts occur in the underarms.",
      relevantStages: [.prePuberty],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Emotional Sensitivity",
      shortDescription: "Heightened emotional responses and sudden tearfulness.",
      whyItHappens: "Rapid hormonal shifts affect mood regulation centers in the brain, making emotions feel much more intense.",
      whenItsNormal: "Expected during early hormonal transitions and growth spurts.",
      whatHelps: "Open, non-judgmental conversations, reassurance, and ensuring adequate sleep.",
      whenToSeekHelp: "If there is severe anxiety, prolonged sadness, or distress that impacts daily functioning.",
      relevantStages: [.prePuberty],
      category: .mood
    ),
    
    NormalTopic(
      title: "Irregular Cycles",
      shortDescription: "Periods may not follow a predictable 28-day pattern initially.",
      whyItHappens: "The brain-ovary connection is still maturing, so ovulation is not yet happening consistently every month.",
      whenItsNormal: "Very common during the first 2 to 3 years after the first period.",
      whatHelps: "Consistent cycle tracking to learn patterns, along with a healthy sleep and nutrition routine.",
      whenToSeekHelp: "If there is no period for more than 3 months, or if bleeding is dangerously heavy.",
      relevantStages: [.puberty],
      category: .cycle
    ),
    
    NormalTopic(
      title: "Acne Flare-ups",
      shortDescription: "Skin breakouts, particularly during hormonal shifts.",
      whyItHappens: "Increased androgens cause sebaceous glands to produce more oil, which can clog pores.",
      whenItsNormal: "Normal throughout puberty and often peaks right before a period.",
      whatHelps: "A gentle, consistent daily skincare routine without harsh scrubbing.",
      whenToSeekHelp: "If acne is severe, painful, cystic, or is beginning to cause permanent scarring.",
      relevantStages: [.puberty],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Mood Swings",
      shortDescription: "Rapid emotional ups and downs without obvious triggers.",
      whyItHappens: "Fluctuations in estrogen and progesterone directly affect serotonin and other neurotransmitters.",
      whenItsNormal: "Most common in the days leading up to or during a menstrual period.",
      whatHelps: "Prioritizing sleep, stress management, light exercise, and emotional support.",
      whenToSeekHelp: "If the swings are severe enough to negatively affect school, relationships, or daily life.",
      relevantStages: [.puberty],
      category: .mood
    ),
    
    NormalTopic(
      title: "Cramps",
      shortDescription: "Lower abdominal pain or dull ache during a period.",
      whyItHappens: "Chemicals called prostaglandins trigger uterine muscle contractions to help shed the lining.",
      whenItsNormal: "Mild to moderate discomfort on the first few days of bleeding.",
      whatHelps: "Using a heating pad, staying hydrated, gentle stretching, and over-the-counter pain relief.",
      whenToSeekHelp: "If pain is so severe it causes vomiting or forces you to miss school/work regularly.",
      relevantStages: [.puberty],
      category: .cycle
    ),
    
    
    NormalTopic(
      title: "Delayed Cycle",
      shortDescription: "A period that arrives significantly later than expected, often triggered by physical or emotional stress.",
      whyItHappens: "High cortisol levels from stress can temporarily suppress the hypothalamus, delaying or preventing ovulation.",
      whenItsNormal: "An occasional delay of a few days to a week is completely normal during stressful months.",
      whatHelps: "Prioritizing stress management, ensuring adequate sleep, eating well, and giving the body time to recover.",
      whenToSeekHelp: "If cycles become consistently irregular, or if a period is missed for more than 3 consecutive months.",
      relevantStages: [.reproductive],
      category: .cycle
    ),
    
    NormalTopic(
      title: "Breast Tenderness",
      shortDescription: "Early breast sensitivity and mild discomfort.",
      whyItHappens: "Rising estrogen levels activate new breast tissue growth and milk duct development.",
      whenItsNormal: "Very common and expected between the ages of 8 and 13.",
      whatHelps: "Wearing comfortable, supportive clothing or a soft training bra, along with gentle reassurance.",
      whenToSeekHelp: "If development begins extremely early (before age 8) or if there is severe, localized pain.",
      relevantStages: [.reproductive],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Mild Cramps",
      shortDescription: "Gentle to moderate lower abdominal discomfort.",
      whyItHappens: "Prostaglandins trigger normal uterine contractions to expel the menstrual lining.",
      whenItsNormal: "Expected for 1–2 days just before or during the start of a period.",
      whatHelps: "Applying a heat pad, staying hydrated, resting, and light movement.",
      whenToSeekHelp: "If the pain becomes debilitating and doesn't respond to basic pain relievers.",
      relevantStages: [.reproductive],
      category: .cycle
    ),
    
    NormalTopic(
      title: "Spotting",
      shortDescription: "Very light bleeding or pinkish discharge between normal periods.",
      whyItHappens: "Can occur due to ovulation dips in estrogen or minor hormonal shifts during the luteal phase.",
      whenItsNormal: "Occasional mid-cycle spotting is generally harmless.",
      whatHelps: "Detailed cycle tracking to identify if it aligns with ovulation.",
      whenToSeekHelp: "If spotting happens frequently, is heavy, or occurs after sex.",
      relevantStages: [.reproductive],
      category: .cycle
    ),
 
    NormalTopic(
      title: "Hot Flashes",
      shortDescription: "Sudden, intense episodes of warmth often accompanied by sweating.",
      whyItHappens: "Erratic estrogen fluctuations confuse the brain's temperature-regulating center.",
      whenItsNormal: "A hallmark symptom of the perimenopause transition phase.",
      whatHelps: "Dressing in breathable layers, practicing cooling techniques, and avoiding spicy foods.",
      whenToSeekHelp: "If they are severe, frequent, and significantly disrupting daily life.",
      relevantStages: [.perimenopause],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Sleep Issues",
      shortDescription: "Difficulty falling asleep, staying asleep, or waking unrefreshed.",
      whyItHappens: "Hormonal changes, especially dropping progesterone, can disrupt the natural circadian rhythm.",
      whenItsNormal: "Very common during the transition years of perimenopause.",
      whatHelps: "Maintaining strict sleep hygiene, a cool bedroom, and a calming bedtime routine.",
      whenToSeekHelp: "If persistent insomnia leads to chronic exhaustion and affects daytime functioning.",
      relevantStages: [.perimenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Brain Fog",
      shortDescription: "Difficulty concentrating, memory slips, or a feeling of mental cloudiness.",
      whyItHappens: "Fluctuating estrogen levels can temporarily affect cognitive processing and memory centers.",
      whenItsNormal: "Common and usually temporary during the perimenopause transition.",
      whatHelps: "Getting adequate rest, mental stimulation, writing things down, and managing stress.",
      whenToSeekHelp: "If cognitive decline is severe, progressively worsening, or causing significant alarm.",
      relevantStages: [.perimenopause],
      category: .mood
    ),
    
    NormalTopic(
      title: "Irregular Periods",
      shortDescription: "Unpredictable cycle timing, varying lengths, or skipped months.",
      whyItHappens: "As the body transitions, ovulation becomes inconsistent and estrogen levels fluctuate wildly.",
      whenItsNormal: "Expected during the perimenopause transition phase before periods stop completely.",
      whatHelps: "Keeping a detailed tracking log of bleeding patterns and symptoms.",
      whenToSeekHelp: "If bleeding is excessively heavy (soaking a pad an hour) or lasts longer than a week.",
      relevantStages: [.perimenopause],
      category: .cycle
    ),
    
   
    
    NormalTopic(
      title: "Night Sweats",
      shortDescription: "Excessive sweating during sleep that may drench sleepwear.",
      whyItHappens: "Hormonal temperature shifts occur at night, triggering the body to rapidly cool itself.",
      whenItsNormal: "A frequent occurrence during the menopause transition.",
      whatHelps: "Using moisture-wicking sleepwear, maintaining a cool room, and keeping cold water nearby.",
      whenToSeekHelp: "If they are extreme and accompanied by unexplained weight loss or fever.",
      relevantStages: [.menopause],
      category: .hormones
    ),
    
    NormalTopic(
      title: "Vaginal Dryness",
      shortDescription: "Reduced natural lubrication and potential discomfort.",
      whyItHappens: "Lower estrogen levels cause vaginal tissues to become thinner and less naturally lubricated.",
      whenItsNormal: "A standard physiological change during and after menopause.",
      whatHelps: "Using over-the-counter moisturizers regularly and water-based lubricants during intimacy.",
      whenToSeekHelp: "If it causes severe pain, bleeding during sex, or persistent discomfort.",
      relevantStages: [.menopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Fatigue",
      shortDescription: "A persistent sense of deep tiredness or low energy.",
      whyItHappens: "Often a compounding effect of sleep disturbances, night sweats, and overall hormone shifts.",
      whenItsNormal: "Very common during the active stages of menopause.",
      whatHelps: "Prioritizing rest, gentle exercise, and maintaining a nutrient-dense, balanced diet.",
      whenToSeekHelp: "If fatigue is severe, unexplained by sleep loss, or accompanied by other concerning symptoms.",
      relevantStages: [.menopause],
      category: .health
    ),
    
    
    NormalTopic(
      title: "Joint Stiffness",
      shortDescription: "Achy joints or morning stiffness without a clear injury.",
      whyItHappens: "Lower estrogen levels can reduce joint lubrication and affect connective tissue elasticity.",
      whenItsNormal: "Mild stiffness is a common occurrence post-menopause.",
      whatHelps: "Regular gentle stretching, yoga, staying active, and maintaining a healthy weight.",
      whenToSeekHelp: "If accompanied by visible swelling, redness, or severe localized pain.",
      relevantStages: [.postMenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Bone Weakness",
      shortDescription: "A gradual reduction in bone density over time.",
      whyItHappens: "The decline in protective estrogen accelerates the natural process of bone loss.",
      whenItsNormal: "A gradual change that occurs steadily in the post-menopausal years.",
      whatHelps: "Ensuring adequate calcium and Vitamin D, alongside regular weight-bearing exercises.",
      whenToSeekHelp: "If you experience frequent, unexplained fractures or significant loss of height.",
      relevantStages: [.postMenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Dry Skin",
      shortDescription: "Skin feeling tighter, drier, and showing reduced elasticity.",
      whyItHappens: "Hormonal decline directly reduces collagen production and the skin's ability to retain moisture.",
      whenItsNormal: "A natural progression in the years following menopause.",
      whatHelps: "Consistent hydration, using thicker moisturizers, and protecting skin from harsh sun.",
      whenToSeekHelp: "If dry skin leads to severe irritation, cracking, or persistent itching.",
      relevantStages: [.postMenopause],
      category: .health
    ),
    
    NormalTopic(
      title: "Urinary Changes",
      shortDescription: "Increased bladder sensitivity or occasional mild leakage.",
      whyItHappens: "Decreased estrogen causes thinning and weakening of the pelvic floor and urethral tissues.",
      whenItsNormal: "Common physiological changes in the post-menopause phase.",
      whatHelps: "Practicing regular pelvic floor (Kegel) exercises and staying adequately hydrated.",
      whenToSeekHelp: "If accompanied by painful urination, blood in urine, or severe incontinence.",
      relevantStages: [.postMenopause],
      category: .health
    )
  ]
}
