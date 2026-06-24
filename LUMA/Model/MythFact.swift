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
      fact: "Ovulation (the release of an egg) actually occurs before the first visible period bleeding happens, so pregnancy is biologically possible even before a girl gets her very first period.",
      stage: .puberty
    ),
    
    MythFact(
      myth: "Stress cannot delay periods.",
      fact: "High physical or emotional stress levels drastically increase cortisol, which can suppress reproductive hormones and delay ovulation, ultimately causing a late or missed period.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Hot flashes only happen after menopause.",
      fact: "Hot flashes are actually most common during perimenopause (the transition phase leading up to menopause) and can begin years before periods fully stop.",
      stage: .perimenopause
    ),
    
    MythFact(
      myth: "Bone health doesn’t need attention after menopause.",
      fact: "The sharp decline in estrogen after menopause significantly increases the risk of osteoporosis, making calcium, Vitamin D, and weight-bearing exercise absolutely critical.",
      stage: .postMenopause
    ),
    
    MythFact(
      myth: "Periods sync up when women spend time together.",
      fact: "While 'menstrual synchrony' is a popular cultural belief, rigorous scientific studies show that cycles overlapping is largely a mathematical coincidence due to differing cycle lengths, not a biological syncing.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "You shouldn't exercise during your period.",
      fact: "Light to moderate exercise (like yoga or walking) increases blood circulation and releases endorphins, which act as natural painkillers and can significantly relieve menstrual cramps.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "PMS is all in your head.",
      fact: "Premenstrual Syndrome is a clinically recognized medical condition caused by intense hormonal fluctuations (especially dropping progesterone) that directly affect serotonin and other mood-regulating neurotransmitters in the brain.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Menopause means you instantly lose your sex drive.",
      fact: "While hormonal changes can cause physical symptoms like vaginal dryness, many women maintain a healthy libido, and some even experience an increased sex drive post-menopause due to the absence of pregnancy anxiety.",
      stage: .postMenopause
    ),
    
    MythFact(
      myth: "A normal menstrual cycle is always exactly 28 days.",
      fact: "A perfectly healthy menstrual cycle can range anywhere from 21 to 35 days, and it is completely normal for it to fluctuate slightly from month to month based on stress, travel, or diet.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Cramps are a sign of weakness or low pain tolerance.",
      fact: "Menstrual cramps (dysmenorrhea) are a real biological response caused by prostaglandins forcing the uterus to contract. Extremely severe pain may indicate underlying conditions like endometriosis and should be evaluated by a doctor.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "You lose a massive amount of blood during a period.",
      fact: "Despite how it may look, the average blood loss during an entire menstrual period is only about 2 to 3 tablespoons (30-40ml) of actual blood.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Using tampons can cause you to lose your virginity.",
      fact: "Virginity is a social concept related to sexual intercourse. Using a tampon simply stretches or passes through the hymen, but it absolutely does not change your virginity status.",
      stage: .puberty
    ),
    
    MythFact(
      myth: "Hormonal birth control makes you gain weight permanently.",
      fact: "Some methods may cause temporary water retention or increased appetite initially, but extensive medical studies show no direct biological link between modern birth control pills and long-term permanent fat gain.",
      stage: .reproductive
    ),
    
    MythFact(
      myth: "Menopause happens overnight.",
      fact: "The transition into menopause, called perimenopause, is a highly gradual process involving widely fluctuating hormones that can last anywhere from 4 to 10 years before menstrual periods fully and permanently stop.",
      stage: .perimenopause
    ),
    
    MythFact(
      myth: "You can't swim in the ocean on your period because of sharks.",
      fact: "There is absolutely no scientific evidence that menstruating increases your risk of a shark attack.",
      stage: .puberty
    )
  ]
}
