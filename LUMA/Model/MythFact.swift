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
    ),
    
    MythFact(
      myth: "Periods sync up when women spend time together.",
      fact: "While popular in culture, scientific studies show that 'menstrual synchrony' is largely a mathematical coincidence, not biology.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "You shouldn't exercise during your period.",
      fact: "Light to moderate exercise can actually relieve menstrual cramps and improve your mood by releasing endorphins.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "PMS is all in your head.",
      fact: "Premenstrual Syndrome is a recognized medical condition caused by intense hormonal fluctuations affecting serotonin levels.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Menopause means you instantly lose your sex drive.",
      fact: "While hormonal changes can cause vaginal dryness, many women maintain or even experience an increased libido post-menopause.",
      stage: .postMenopause
    ),
    
    MythFact(
      myth: "A normal menstrual cycle is always exactly 28 days.",
      fact: "A healthy cycle can range anywhere from 21 to 35 days, and it can fluctuate naturally month to month.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Cramps are a sign of weakness or low pain tolerance.",
      fact: "Menstrual cramps (dysmenorrhea) are caused by prostaglandins forcing the uterus to contract. Severe pain may indicate conditions like endometriosis.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "You lose a massive amount of blood during a period.",
      fact: "The average blood loss during a period is only about 2 to 3 tablespoons (30-40ml).",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Using tampons can cause you to lose your virginity.",
      fact: "Virginity is a social concept related to sexual intercourse. Using a tampon does not change your virginity status.",
      stage: .puberty
    ),
    
    MythFact(
      myth: "Hormonal birth control makes you gain weight permanently.",
      fact: "Some methods may cause temporary water retention, but studies show no direct link between most modern birth control pills and long-term fat gain.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Menopause happens overnight.",
      fact: "The transition, called perimenopause, is gradual and can last anywhere from 4 to 10 years before periods fully stop.",
      stage: .perimenopause
    ),
    
    MythFact(
      myth: "You can't swim in the ocean on your period because of sharks.",
      fact: "There is absolutely no scientific evidence that menstruating increases your risk of a shark attack.",
      stage: .puberty
    )
  ]
}
