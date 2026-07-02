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
    ),
    
    // --- HORMONES & SKIN ---
    MythFact(
      myth: "Acne right before your period means you have bad hygiene.",
      fact: "Pre-menstrual acne is triggered by a natural drop in estrogen and a relative rise in progesterone and testosterone. This hormonal shift increases oil production in the skin—it has nothing to do with how often you wash your face.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Hormonal imbalances only affect your reproductive organs.",
      fact: "Hormones are powerful chemical messengers that impact your entire body. They affect everything from your metabolism, sleep quality, and bone density, to your mood, skin health, and body temperature.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Testosterone is strictly a 'male hormone'.",
      fact: "Women naturally produce and require testosterone in smaller amounts. It plays a crucial role in maintaining bone strength, muscle mass, energy levels, and a healthy sex drive.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Eating chocolate causes hormonal breakouts.",
      fact: "While high-sugar diets can trigger insulin spikes that worsen acne, chocolate itself doesn't directly cause breakouts. However, cravings for sugar often peak during the luteal phase right when hormone-induced breakouts naturally occur.",
      stage: .reproductive
    ),
    
    // --- CYCLE & FERTILITY ---
    MythFact(
      myth: "You can get pregnant any day of your menstrual cycle.",
      fact: "Pregnancy can only occur during the 'fertile window,' which is the 5 days leading up to ovulation plus the day of ovulation itself, as sperm can survive up to 5 days inside the reproductive tract.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Irregular periods always mean you are infertile.",
      fact: "While irregular cycles make it harder to predict exactly when you ovulate, they do not automatically mean you cannot get pregnant. Many conditions that cause irregularity, like PCOS, can be managed to support healthy pregnancies.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Tracking your period is only useful if you want to get pregnant.",
      fact: "Your menstrual cycle is considered a vital sign. Tracking it helps you understand personal patterns in your energy, mood, sleep, and appetite, and can alert you to potential underlying health issues early on.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Taking the birth control pill 'resets' your natural cycle.",
      fact: "Combination birth control pills actually suppress your natural cycle and prevent ovulation entirely. The 'period' you get on the pill is not a true period, but a withdrawal bleed from the pause in synthetic hormones.",
      stage: .reproductive
    ),
    MythFact(
      myth: "You lose thousands of eggs every time you have a period.",
      fact: "During a normal menstrual cycle, only one mature egg is released during ovulation. However, hundreds of immature follicles that were also preparing to mature naturally dissolve and are reabsorbed by the body.",
      stage: .reproductive
    ),
    
    // --- MOOD & MENTAL HEALTH ---
    MythFact(
      myth: "Women are inherently 'too emotional' because of their hormones.",
      fact: "Both men and women experience hormonal fluctuations that impact mood. Societal biases often wrongly dismiss valid emotional responses in women as merely 'hormonal' rather than addressing the actual situation.",
      stage: .reproductive
    ),
    MythFact(
      myth: "PMDD is just another word for regular PMS.",
      fact: "Premenstrual Dysphoric Disorder (PMDD) is a severe, clinically diagnosed condition that causes debilitating depression, severe anxiety, and extreme mood shifts, far beyond the physical discomforts of typical PMS.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Your mood dropping before your period means you have depression.",
      fact: "A sudden, temporary drop in mood right before menstruation is a very common biological response to rapidly falling estrogen and progesterone levels. If the mood lifts a few days into your period, it is likely tied to your cycle.",
      stage: .reproductive
    ),
    
    // --- GENERAL HEALTH & CONDITIONS ---
    MythFact(
      myth: "PCOS is caused by being overweight.",
      fact: "Polycystic Ovary Syndrome (PCOS) is a complex endocrine disorder with strong genetic roots. While insulin resistance associated with PCOS can cause weight gain, the weight itself is a symptom, not the root cause.",
      stage: .reproductive
    ),
    MythFact(
      myth: "Endometriosis is just 'bad period cramps' that you have to endure.",
      fact: "Endometriosis is a chronic inflammatory disease where tissue similar to the uterine lining grows outside the uterus, causing severe, chronic pain that is not normal and requires specialized medical treatment.",
      stage: .reproductive
    ),
    MythFact(
      myth: "You only need to see a gynecologist once you become sexually active.",
      fact: "The American College of Obstetricians and Gynecologists recommends the first visit between ages 13 and 15 for general reproductive health education, tracking irregular cycles, and establishing a baseline for care.",
      stage: .puberty
    ),
    MythFact(
      myth: "Douching is necessary to keep the vagina clean.",
      fact: "The vagina is entirely self-cleaning. Douching physically flushes out healthy, protective bacteria, severely disrupts the natural acidic pH, and actually increases the risk of infections like bacterial vaginosis.",
      stage: .puberty
    ),
    MythFact(
      myth: "A hysterectomy immediately plunges you into menopause.",
      fact: "A hysterectomy (removal of the uterus) stops periods, but unless the ovaries (which produce estrogen and progesterone) are also removed in an oophorectomy, you will not enter immediate surgical menopause.",
      stage: .perimenopause
    ),
    
    // --- PERIMENOPAUSE & POST-MENOPAUSE ---
    MythFact(
      myth: "You cannot get pregnant during perimenopause.",
      fact: "Though fertility naturally declines, ovulation still occurs sporadically during perimenopause. As long as you are still having periods, even irregular ones, pregnancy is biologically possible.",
      stage: .perimenopause
    ),
    MythFact(
      myth: "Weight gain during menopause is completely unavoidable.",
      fact: "While metabolism naturally slows and dropping estrogen can change where fat is stored (often shifting to the abdomen), staying active and adjusting nutrition can absolutely maintain a healthy weight and body composition.",
      stage: .postMenopause
    ),
    MythFact(
      myth: "Menopause marks the end of a woman's active, vibrant life.",
      fact: "Many cultures view menopause as an empowering transition into wisdom and freedom. Relieved from the fluctuations of the menstrual cycle and pregnancy concerns, many women report their highest levels of confidence and energy post-menopause.",
      stage: .postMenopause
    ),
    
    // --- PRE-PUBERTY ---
    MythFact(
      myth: "Girls shouldn't learn about periods until they are teenagers.",
      fact: "Girls can get their first period as early as age 8. Education should start early so they feel prepared and safe, rather than scared, when it happens.",
      stage: .prePuberty
    ),
    MythFact(
      myth: "Vaginal discharge before a first period means there is an infection.",
      fact: "It is completely normal for girls to experience a clear or white vaginal discharge 6 to 12 months before their first period begins as estrogen levels naturally rise.",
      stage: .prePuberty
    ),
    MythFact(
      myth: "Breast development always starts on both sides at the exact same time.",
      fact: "It is highly common for one breast to start developing before the other. This uneven growth is entirely normal during early puberty and usually evens out over time.",
      stage: .prePuberty
    ),
    
    // --- PUBERTY ---
    MythFact(
      myth: "If you don't get your period by age 13, something is medically wrong.",
      fact: "While the average age is 12, it is perfectly normal to start anywhere between 8 and 15 years old. Genetics play a huge role in the timeline.",
      stage: .puberty
    ),
    MythFact(
      myth: "Using a menstrual cup or tampon early on will stretch you out permanently.",
      fact: "The vaginal canal is made of highly elastic muscle designed to expand and contract. Tampons and cups do not cause permanent stretching.",
      stage: .puberty
    ),
    MythFact(
      myth: "Teenagers have irregular periods because their bodies are unhealthy.",
      fact: "It takes up to 2-3 years for the brain and ovaries to fully communicate and regulate hormones. Irregular cycles are completely biologically normal in the first few years.",
      stage: .puberty
    ),
    
    // --- PERIMENOPAUSE ---
    MythFact(
      myth: "Perimenopause only lasts for about a year before periods stop.",
      fact: "Perimenopause can begin as early as your mid-30s and frequently lasts between 4 to 10 years as hormone levels slowly fluctuate and wind down.",
      stage: .perimenopause
    ),
    MythFact(
      myth: "You'll only experience hot flashes during perimenopause.",
      fact: "There are over 34 recognized symptoms of perimenopause, including brain fog, joint pain, heart palpitations, severe anxiety, and changes in body odor.",
      stage: .perimenopause
    ),
    MythFact(
      myth: "Heavy, erratic bleeding in perimenopause is something you just have to live with.",
      fact: "While erratic periods are common, flooding or extremely heavy bleeding should always be medically evaluated. There are many highly effective treatments available.",
      stage: .perimenopause
    ),
    
    // --- MENOPAUSE ---
    MythFact(
      myth: "Menopause is a long phase of life.",
      fact: "Medically, 'Menopause' is actually just a single day on the calendar: exactly 12 consecutive months after your very last period. Every day after that is technically Post-Menopause.",
      stage: .menopause
    ),
    MythFact(
      myth: "Hormone Replacement Therapy (HRT) is too dangerous and causes cancer.",
      fact: "For the vast majority of healthy women, modern HRT is highly safe, incredibly effective for symptoms, and actually protects against osteoporosis and heart disease when started early.",
      stage: .menopause
    ),
    MythFact(
      myth: "Your body stops producing hormones entirely at menopause.",
      fact: "While the ovaries stop producing high levels of estrogen and progesterone, your adrenal glands and fat tissue continue to produce necessary, lower levels of hormones for the rest of your life.",
      stage: .menopause
    ),
    
    // --- POST-MENOPAUSE ---
    MythFact(
      myth: "Vaginal dryness is permanent and untreatable.",
      fact: "While lower estrogen causes dryness, localized vaginal estrogen therapy (creams or rings) is extremely safe and can completely restore tissue health without affecting the whole body.",
      stage: .postMenopause
    ),
    MythFact(
      myth: "You don't need Pap smears after menopause.",
      fact: "Unless you have had a complete hysterectomy (including the cervix) for non-cancerous reasons, regular cervical screenings are still recommended well into your 60s.",
      stage: .postMenopause
    ),
    MythFact(
      myth: "Post-menopause causes severe, permanent depression.",
      fact: "While the fluctuating hormones of perimenopause can trigger mood swings, post-menopause is marked by hormonal stability. Many women experience significantly better mental health and emotional freedom.",
      stage: .postMenopause
    )
  ]
}
