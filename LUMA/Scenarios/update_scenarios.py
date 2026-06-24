import os

scenarios_code = """import SwiftUI

struct ScenarioLibrary {
  static func scenarios(for stage: LifeStage) -> [Scenario] {
    switch stage {
    case .prePuberty:
      return [
        Scenario(
          title: "Noticing Changes",
          situation: "You notice your chest feeling a little tender and there are small bumps starting to grow.",
          stage: .prePuberty,
          choices: [
            ScenarioChoice(text: "Ignore it, maybe it will go away.", quality: .notIdeal, explanation: "Ignoring changes can lead to worry. It's better to understand what's happening.", learnMore: "Changes are normal!"),
            ScenarioChoice(text: "Try to hide them with baggy clothes.", quality: .okay, explanation: "Many girls do this because they feel self-conscious, but there's nothing to hide.", learnMore: "Breast buds are the first sign of puberty."),
            ScenarioChoice(text: "Talk to a trusted adult like a parent.", quality: .best, explanation: "Talking to an adult helps you understand that these are breast buds, a normal part of growing up.", learnMore: "Communication is key.")
          ],
          icon: "person.bust"
        ),
        Scenario(
          title: "New Body Odor",
          situation: "After gym class, you notice you smell different than usual and feel embarrassed.",
          stage: .prePuberty,
          choices: [
            ScenarioChoice(text: "Skip gym to avoid sweating.", quality: .notIdeal, explanation: "Exercise is important for your health. Body odor is a normal sign of growing up.", learnMore: "Why body odor starts during puberty."),
            ScenarioChoice(text: "Use lots of perfume to cover it up.", quality: .okay, explanation: "Perfume masks the smell temporarily, but it doesn't solve the issue.", learnMore: "Sweat glands activate during puberty."),
            ScenarioChoice(text: "Start using deodorant and shower after exercise.", quality: .best, explanation: "Good hygiene habits like deodorant and regular showers are the best way to manage body odor.", learnMore: "Building healthy hygiene habits.")
          ],
          icon: "wind"
        ),
        Scenario(
          title: "Growth Spurt",
          situation: "You've suddenly grown taller than most of your classmates and feel awkward about it.",
          stage: .prePuberty,
          choices: [
            ScenarioChoice(text: "Slouch to look shorter.", quality: .notIdeal, explanation: "Slouching can hurt your back and posture long-term. Your height is something to be proud of!", learnMore: "Growth spurts in puberty."),
            ScenarioChoice(text: "Avoid standing next to shorter friends.", quality: .okay, explanation: "It's natural to feel self-conscious, but true friends won't care about height differences.", learnMore: "Everyone grows at their own pace."),
            ScenarioChoice(text: "Stand tall and remember everyone grows at different rates.", quality: .best, explanation: "Growth spurts are temporary and totally normal. Embracing your body builds confidence.", learnMore: "Height and genetics.")
          ],
          icon: "arrow.up.heart"
        ),
        Scenario(
          title: "First Body Hair",
          situation: "You notice some new hair growing under your arms and aren't sure what to do.",
          stage: .prePuberty,
          choices: [
            ScenarioChoice(text: "Secretly shave it with someone else's razor.", quality: .notIdeal, explanation: "Sharing razors is unhygienic and can cause infections. It's best to use your own.", learnMore: "Safe shaving habits."),
            ScenarioChoice(text: "Wear long sleeves all the time to hide it.", quality: .okay, explanation: "You can hide it if it makes you comfortable, but it's completely natural and nothing to be ashamed of.", learnMore: "Body hair is natural."),
            ScenarioChoice(text: "Ask a parent about getting your own razor if you want to remove it.", quality: .best, explanation: "Talking to an adult ensures you learn how to remove it safely if you choose to do so.", learnMore: "Hair removal options.")
          ],
          icon: "scissors"
        ),
        Scenario(
          title: "Sudden Emotions",
          situation: "You suddenly feel very sad and want to cry, but nothing bad has happened.",
          stage: .prePuberty,
          choices: [
            ScenarioChoice(text: "Hold it in and pretend everything is fine.", quality: .notIdeal, explanation: "Suppressing emotions can make you feel worse. It's okay to let it out.", learnMore: "Healthy emotional expression."),
            ScenarioChoice(text: "Cry in your room alone.", quality: .okay, explanation: "Crying alone is fine, but sharing your feelings can help you feel supported.", learnMore: "Why we cry."),
            ScenarioChoice(text: "Tell a family member you feel down but aren't sure why.", quality: .best, explanation: "Hormonal changes can cause unexplained moods. Sharing helps you realize it's normal.", learnMore: "Hormones and emotions.")
          ],
          icon: "cloud.rain"
        ),
        Scenario(
          title: "Pimples Appearing",
          situation: "You see a few small red spots on your forehead and worry everyone will stare.",
          stage: .prePuberty,
          choices: [
            ScenarioChoice(text: "Pick at them to make them go away.", quality: .notIdeal, explanation: "Picking causes scars and introduces bacteria. Never pick pimples!", learnMore: "Why picking is bad."),
            ScenarioChoice(text: "Wash your face 5 times a day.", quality: .okay, explanation: "Overwashing can irritate your skin and make it produce more oil.", learnMore: "Gentle skin care."),
            ScenarioChoice(text: "Start washing your face twice a day with a gentle cleanser.", quality: .best, explanation: "A simple routine keeps skin clean without irritating it. Pimples are a normal sign of puberty.", learnMore: "Basic skin care routine.")
          ],
          icon: "sparkles"
        )
      ]
    case .puberty:
      return [
        Scenario(
          title: "Unexpected Start",
          situation: "You're at school and you suddenly realize your period has started.",
          stage: .puberty,
          choices: [
            ScenarioChoice(text: "Panic and leave school.", quality: .notIdeal, explanation: "Leaving school isn't necessary. Many resources are available right there.", learnMore: "Periods are a normal part of school life."),
            ScenarioChoice(text: "Use toilet paper as a temporary pad.", quality: .okay, explanation: "This works in a pinch, but a real pad is much more comfortable and secure.", learnMore: "Always keep an emergency pad."),
            ScenarioChoice(text: "Ask the school nurse or a friend for a pad.", quality: .best, explanation: "Nurses and friends are there to help! It happens to everyone.", learnMore: "Support systems at school.")
          ],
          icon: "drop.fill"
        ),
        Scenario(
          title: "Mood Roller Coaster",
          situation: "You suddenly feel angry at your best friend for no real reason and want to say something hurtful.",
          stage: .puberty,
          choices: [
            ScenarioChoice(text: "Say what's on your mind immediately.", quality: .notIdeal, explanation: "Saying hurtful things in the moment can damage friendships. Hormonal mood swings are real.", learnMore: "Hormones and emotional regulation."),
            ScenarioChoice(text: "Walk away without explaining.", quality: .okay, explanation: "Walking away prevents conflict, but your friend might feel confused or hurt.", learnMore: "Communicating during mood swings."),
            ScenarioChoice(text: "Take a deep breath and tell your friend you need a moment.", quality: .best, explanation: "Recognizing mood swings and communicating them is emotionally mature and protects your friendships.", learnMore: "Estrogen and mood changes.")
          ],
          icon: "theatermasks"
        ),
        Scenario(
          title: "Skin Breakout",
          situation: "You wake up before a big event and notice several pimples on your face.",
          stage: .puberty,
          choices: [
            ScenarioChoice(text: "Pop them all immediately.", quality: .notIdeal, explanation: "Popping pimples can cause scarring, infection, and make them look worse.", learnMore: "Why popping pimples is harmful."),
            ScenarioChoice(text: "Cover them with heavy makeup.", quality: .okay, explanation: "Makeup can help you feel confident, but heavy products might clog pores further.", learnMore: "Non-comedogenic products."),
            ScenarioChoice(text: "Apply a gentle spot treatment and remember acne is temporary.", quality: .best, explanation: "Spot treatments with salicylic acid or benzoyl peroxide help. Acne during puberty is caused by hormonal changes and is completely normal.", learnMore: "Androgens and skin changes.")
          ],
          icon: "face.smiling"
        ),
        Scenario(
          title: "Period Cramps at School",
          situation: "You get severe cramps during math class and find it hard to concentrate.",
          stage: .puberty,
          choices: [
            ScenarioChoice(text: "Suffer in silence and try to ignore it.", quality: .notIdeal, explanation: "You don't have to suffer. There are ways to manage the pain.", learnMore: "Managing period pain."),
            ScenarioChoice(text: "Put your head on the desk and try to sleep.", quality: .okay, explanation: "Resting helps, but it might get you in trouble during class. It's better to ask for help.", learnMore: "When cramps interfere with school."),
            ScenarioChoice(text: "Ask to visit the school nurse for a heating pad or pain reliever.", quality: .best, explanation: "Nurses are equipped to help with menstrual cramps. Using heat or medication is very effective.", learnMore: "How heat helps cramps.")
          ],
          icon: "bolt.heart.fill"
        ),
        Scenario(
          title: "Stained Clothes",
          situation: "You stand up from your chair and realize your period leaked through your clothes.",
          stage: .puberty,
          choices: [
            ScenarioChoice(text: "Run out of the room crying.", quality: .notIdeal, explanation: "It's embarrassing, but running away doesn't solve the problem. Everyone has accidents.", learnMore: "Dealing with period leaks."),
            ScenarioChoice(text: "Tie a sweater around your waist.", quality: .okay, explanation: "This is a great quick fix, but you'll eventually need to change and clean up.", learnMore: "Quick fixes for leaks."),
            ScenarioChoice(text: "Tie a sweater, then go to the bathroom or nurse for a change of clothes.", quality: .best, explanation: "Handling it calmly and getting fresh clothes is the best approach. It happens to almost everyone!", learnMore: "Preparing an emergency kit.")
          ],
          icon: "drop.triangle"
        ),
        Scenario(
          title: "Irregular Cycles",
          situation: "You got your period two months ago, but it hasn't come back since.",
          stage: .puberty,
          choices: [
            ScenarioChoice(text: "Worry that something is terribly wrong.", quality: .notIdeal, explanation: "Irregularity is very common in the first few years as hormones balance out.", learnMore: "Why early cycles are irregular."),
            ScenarioChoice(text: "Ignore it completely.", quality: .okay, explanation: "It's normal, but it's still good to track it so you know your body's patterns.", learnMore: "Tracking your cycle."),
            ScenarioChoice(text: "Keep tracking it and know that irregular periods are normal at first.", quality: .best, explanation: "It can take 1-2 years for cycles to become regular. Tracking helps you and your doctor see the pattern.", learnMore: "The maturing reproductive system.")
          ],
          icon: "calendar.badge.clock"
        )
      ]
    case .reproductive:
      return [
        Scenario(
          title: "Late Cycle",
          situation: "Your cycle is 10 days late and you've been very stressed at work lately.",
          stage: .reproductive,
          choices: [
            ScenarioChoice(text: "Assume you are pregnant immediately.", quality: .notIdeal, explanation: "While pregnancy is a possibility, stress is also a very common cause.", learnMore: "Causes of a late period."),
            ScenarioChoice(text: "Wait another week without changing anything.", quality: .okay, explanation: "Waiting is okay, but addressing the stress is also important.", learnMore: "How stress affects your cycle."),
            ScenarioChoice(text: "Take a pregnancy test to be sure, then focus on stress relief.", quality: .best, explanation: "Taking a test gives peace of mind, and managing stress helps regulate hormones.", learnMore: "Cortisol and ovulation.")
          ],
          icon: "calendar.badge.exclamationmark"
        ),
        Scenario(
          title: "Severe Cramps",
          situation: "Your period cramps are so bad you can barely get out of bed, and this happens every month.",
          stage: .reproductive,
          choices: [
            ScenarioChoice(text: "Just tough it out, pain is normal.", quality: .notIdeal, explanation: "While some cramping is normal, severe pain that disrupts your life could be a sign of conditions like endometriosis.", learnMore: "When cramps aren't normal."),
            ScenarioChoice(text: "Take over-the-counter painkillers every month.", quality: .okay, explanation: "Pain relief helps manage symptoms, but it's important to understand the root cause.", learnMore: "NSAIDs and prostaglandins."),
            ScenarioChoice(text: "Track the pain pattern and consult a gynecologist.", quality: .best, explanation: "Tracking helps your doctor diagnose conditions accurately. Severe monthly pain deserves medical attention.", learnMore: "Endometriosis and adenomyosis.")
          ],
          icon: "bolt.heart"
        ),
        Scenario(
          title: "Ovulation Pain",
          situation: "Midway through your cycle, you feel a sharp pinch on one side of your lower abdomen.",
          stage: .reproductive,
          choices: [
            ScenarioChoice(text: "Go to the emergency room immediately.", quality: .notIdeal, explanation: "Unless the pain is severe or accompanied by a fever, it's likely just normal ovulation pain (mittelschmerz).", learnMore: "What is Mittelschmerz?"),
            ScenarioChoice(text: "Ignore it and hope it goes away.", quality: .okay, explanation: "It will likely go away, but it's helpful to note it in your tracker to predict your cycle.", learnMore: "Signs of ovulation."),
            ScenarioChoice(text: "Note it in your tracker as a likely sign of ovulation.", quality: .best, explanation: "Many women feel a small pinch when an egg is released. Tracking it helps you understand your fertility window.", learnMore: "The ovulation process.")
          ],
          icon: "waveform.path.ecg"
        ),
        Scenario(
          title: "PMS Cravings",
          situation: "A few days before your period, you have an intense craving for sugary snacks.",
          stage: .reproductive,
          choices: [
            ScenarioChoice(text: "Eat an entire box of cookies.", quality: .notIdeal, explanation: "A sugar crash can worsen your mood swings and energy levels during PMS.", learnMore: "Sugar and PMS."),
            ScenarioChoice(text: "Deny yourself completely.", quality: .okay, explanation: "Being too strict can cause stress. It's okay to have a little treat.", learnMore: "Diet and hormones."),
            ScenarioChoice(text: "Have a small treat, but focus on complex carbs and protein.", quality: .best, explanation: "Complex carbs stabilize blood sugar, while a small treat satisfies the craving healthily.", learnMore: "Nutrition for a balanced cycle.")
          ],
          icon: "cup.and.saucer"
        ),
        Scenario(
          title: "Heavy Bleeding",
          situation: "You find yourself soaking through a super tampon or pad in less than two hours.",
          stage: .reproductive,
          choices: [
            ScenarioChoice(text: "Ignore it and just change products more often.", quality: .notIdeal, explanation: "Heavy bleeding can lead to anemia and shouldn't be ignored.", learnMore: "Signs of menorrhagia."),
            ScenarioChoice(text: "Take iron supplements just in case.", quality: .okay, explanation: "Iron helps replace lost blood, but you still need to find the cause of the bleeding.", learnMore: "Iron and periods."),
            ScenarioChoice(text: "Schedule an appointment with your doctor to discuss heavy periods.", quality: .best, explanation: "Soaking through products that fast is considered heavy menstrual bleeding and warrants medical advice.", learnMore: "Causes of heavy periods.")
          ],
          icon: "drop.circle"
        ),
        Scenario(
          title: "Spotting Between Periods",
          situation: "You notice light spotting a week after your period ended.",
          stage: .reproductive,
          choices: [
            ScenarioChoice(text: "Assume you have a serious illness.", quality: .notIdeal, explanation: "Don't panic! Spotting can be caused by ovulation, stress, or changes in birth control.", learnMore: "Causes of spotting."),
            ScenarioChoice(text: "Wait and see if it happens again next month.", quality: .okay, explanation: "Monitoring is good, but if it's new or persistent, it's better to get it checked.", learnMore: "When to worry about spotting."),
            ScenarioChoice(text: "Note it in your tracker and consult a doctor if it persists.", quality: .best, explanation: "Tracking helps identify patterns (like ovulation spotting), but a doctor can rule out infections or hormonal imbalances.", learnMore: "Hormonal fluctuations.")
          ],
          icon: "sparkles"
        )
      ]
    case .perimenopause:
      return [
        Scenario(
          title: "Sudden Heat",
          situation: "During a meeting, your face suddenly flushes, and you start sweating profusely.",
          stage: .perimenopause,
          choices: [
            ScenarioChoice(text: "Pretend nothing is happening.", quality: .notIdeal, explanation: "It's hard to hide a hot flash, and ignoring it might make you feel more stressed.", learnMore: "The stress-hot flash connection."),
            ScenarioChoice(text: "Excuse yourself to the bathroom to cool down.", quality: .okay, explanation: "Taking a break is helpful, but you can also manage it right at your desk.", learnMore: "Quick cooling techniques."),
            ScenarioChoice(text: "Take a deep breath, drink cold water, and dress in layers.", quality: .best, explanation: "Dressing in layers and sipping cold water are effective, practical ways to manage hot flashes.", learnMore: "Vasomotor symptoms.")
          ],
          icon: "flame"
        ),
        Scenario(
          title: "Sleepless Nights",
          situation: "You're waking up multiple times at night feeling restless and hot.",
          stage: .perimenopause,
          choices: [
            ScenarioChoice(text: "Stay in bed and toss and turn.", quality: .notIdeal, explanation: "Tossing and turning increases anxiety about not sleeping.", learnMore: "Sleep hygiene basics."),
            ScenarioChoice(text: "Start taking over-the-counter sleep aids every night.", quality: .okay, explanation: "Sleep aids can help short-term, but they don't address the hormonal cause (night sweats).", learnMore: "Hormones and sleep disturbances."),
            ScenarioChoice(text: "Keep the room cool, use breathable sheets, and talk to your doctor.", quality: .best, explanation: "Environmental changes make a huge difference, and a doctor can discuss HRT or other options if needed.", learnMore: "Managing night sweats.")
          ],
          icon: "moon.zzz"
        ),
        Scenario(
          title: "Skipped Periods",
          situation: "You haven't had a period in three months, but you don't feel pregnant.",
          stage: .perimenopause,
          choices: [
            ScenarioChoice(text: "Assume you are fully in menopause.", quality: .notIdeal, explanation: "Menopause is officially reached only after 12 consecutive months without a period.", learnMore: "Defining menopause vs perimenopause."),
            ScenarioChoice(text: "Do nothing, skipping is normal now.", quality: .okay, explanation: "It is normal for perimenopause, but pregnancy is still a slight possibility if you're sexually active.", learnMore: "Fertility during perimenopause."),
            ScenarioChoice(text: "Take a test if active, otherwise track the gap as a perimenopause sign.", quality: .best, explanation: "Tracking the gaps helps you know when you finally reach the 12-month mark of menopause.", learnMore: "Cycle changes in perimenopause.")
          ],
          icon: "calendar.badge.minus"
        ),
        Scenario(
          title: "Brain Fog",
          situation: "You walk into a room and completely forget why you're there, and this happens often lately.",
          stage: .perimenopause,
          choices: [
            ScenarioChoice(text: "Worry that you are developing early dementia.", quality: .notIdeal, explanation: "While scary, memory slips and 'brain fog' are very common symptoms of fluctuating estrogen.", learnMore: "Estrogen and cognitive function."),
            ScenarioChoice(text: "Just laugh it off every time.", quality: .okay, explanation: "A good sense of humor helps, but there are ways to support your brain health during this transition.", learnMore: "Coping with brain fog."),
            ScenarioChoice(text: "Start using lists, prioritize sleep, and know it's a common symptom.", quality: .best, explanation: "Organization tools and good sleep help manage brain fog, which often improves post-menopause.", learnMore: "Strategies for better focus.")
          ],
          icon: "brain.head.profile"
        ),
        Scenario(
          title: "Unpredictable Moods",
          situation: "You feel fine one minute, and overwhelmed with tearfulness the next.",
          stage: .perimenopause,
          choices: [
            ScenarioChoice(text: "Blame everyone around you for making you upset.", quality: .notIdeal, explanation: "Projecting the mood swings onto others can damage relationships.", learnMore: "Communication during perimenopause."),
            ScenarioChoice(text: "Isolate yourself until you feel better.", quality: .okay, explanation: "Taking space is okay, but chronic isolation isn't healthy.", learnMore: "Support systems are vital."),
            ScenarioChoice(text: "Acknowledge the hormonal shift and practice self-compassion.", quality: .best, explanation: "Recognizing that fluctuating hormones are driving the mood changes helps you respond with kindness to yourself.", learnMore: "Emotional wellness strategies.")
          ],
          icon: "cloud.sun.rain"
        ),
        Scenario(
          title: "Changes in Flow",
          situation: "Your period arrives, but it's much heavier and lasts longer than it used to.",
          stage: .perimenopause,
          choices: [
            ScenarioChoice(text: "Just buy more pads and ignore it.", quality: .notIdeal, explanation: "Heavy bleeding can cause anemia and should be evaluated by a doctor, even during perimenopause.", learnMore: "Risks of heavy bleeding."),
            ScenarioChoice(text: "Wait to see if the next one is lighter.", quality: .okay, explanation: "Flow varies wildly in perimenopause, but severe heaviness still needs monitoring.", learnMore: "Tracking irregular flows."),
            ScenarioChoice(text: "Consult a doctor to rule out fibroids or other conditions.", quality: .best, explanation: "While heavy flow can be a normal part of perimenopause, a doctor needs to rule out other causes.", learnMore: "When to see a doctor.")
          ],
          icon: "drop.fill"
        )
      ]
    case .menopause:
      return [
        Scenario(
          title: "Bone Health",
          situation: "Your doctor mentions your bone density might be decreasing now that estrogen is lower.",
          stage: .menopause,
          choices: [
            ScenarioChoice(text: "Ignore it, you feel fine.", quality: .notIdeal, explanation: "Bone loss (osteoporosis) is silent until you break a bone. Preventative care is crucial.", learnMore: "The silent nature of osteoporosis."),
            ScenarioChoice(text: "Start drinking a glass of milk every day.", quality: .okay, explanation: "Calcium is good, but bone health also requires Vitamin D and weight-bearing exercise.", learnMore: "Nutrition for bones."),
            ScenarioChoice(text: "Add weight-bearing exercises and discuss calcium/Vitamin D with your doctor.", quality: .best, explanation: "A comprehensive approach involving diet, supplements, and exercise is the best defense against bone loss.", learnMore: "Weight-bearing exercises.")
          ],
          icon: "figure.walk"
        ),
        Scenario(
          title: "Vaginal Dryness",
          situation: "You're experiencing uncomfortable dryness and irritation during intimacy.",
          stage: .menopause,
          choices: [
            ScenarioChoice(text: "Stop all intimacy to avoid the pain.", quality: .notIdeal, explanation: "You don't have to give up intimacy. There are many effective treatments available.", learnMore: "Maintaining intimacy."),
            ScenarioChoice(text: "Use standard body lotion to moisturize.", quality: .okay, explanation: "Body lotions can cause irritation. It's better to use products specifically designed for vaginal health.", learnMore: "Safe lubricants and moisturizers."),
            ScenarioChoice(text: "Try water-based lubricants and discuss local estrogen with your doctor.", quality: .best, explanation: "Lubricants help immediately, and local estrogen is highly effective for long-term tissue health.", learnMore: "Genitourinary Syndrome of Menopause (GSM).")
          ],
          icon: "heart.text.square"
        ),
        Scenario(
          title: "Heart Health Check",
          situation: "You read that heart disease risk increases after menopause.",
          stage: .menopause,
          choices: [
            ScenarioChoice(text: "Assume it won't happen to you.", quality: .notIdeal, explanation: "Heart disease is the leading cause of death for women post-menopause. Awareness is key.", learnMore: "Estrogen's protective effect on the heart."),
            ScenarioChoice(text: "Cut out all fats from your diet.", quality: .okay, explanation: "Healthy fats (like those in avocados and nuts) are actually good for your heart.", learnMore: "Heart-healthy diets."),
            ScenarioChoice(text: "Schedule a checkup for cholesterol and blood pressure.", quality: .best, explanation: "Knowing your numbers allows you to make targeted lifestyle changes to protect your heart.", learnMore: "Cardiovascular screening.")
          ],
          icon: "heart.circle"
        ),
        Scenario(
          title: "The 'Meno-Pot'",
          situation: "You notice your weight shifting and accumulating more around your midsection.",
          stage: .menopause,
          choices: [
            ScenarioChoice(text: "Go on an extreme crash diet.", quality: .notIdeal, explanation: "Crash diets slow your metabolism further and lead to muscle loss.", learnMore: "Metabolism changes in menopause."),
            ScenarioChoice(text: "Buy looser clothing and accept it.", quality: .okay, explanation: "Acceptance is great, but maintaining a healthy weight reduces health risks.", learnMore: "Visceral fat risks."),
            ScenarioChoice(text: "Focus on strength training and a balanced, protein-rich diet.", quality: .best, explanation: "Building muscle boosts metabolism, and protein helps maintain mass as hormones shift.", learnMore: "Exercise strategies for menopause.")
          ],
          icon: "figure.strengthtraining.traditional"
        ),
        Scenario(
          title: "Thinning Hair",
          situation: "You notice more hair in your brush and your scalp is becoming more visible.",
          stage: .menopause,
          choices: [
            ScenarioChoice(text: "Wear hats all the time to hide it.", quality: .notIdeal, explanation: "Hiding it doesn't address the root cause, and there are treatments that can help.", learnMore: "Hormonal hair loss."),
            ScenarioChoice(text: "Buy expensive over-the-counter thickening shampoos.", quality: .okay, explanation: "These can add volume temporarily, but they don't stop hair loss.", learnMore: "Managing hair changes."),
            ScenarioChoice(text: "See a dermatologist to discuss treatments like Minoxidil.", quality: .best, explanation: "A doctor can confirm if it's hormonal and prescribe effective treatments to preserve your hair.", learnMore: "Medical options for hair loss.")
          ],
          icon: "comb"
        ),
        Scenario(
          title: "Joint Aches",
          situation: "You wake up feeling stiff, and your knees ache when walking up stairs.",
          stage: .menopause,
          choices: [
            ScenarioChoice(text: "Stop exercising completely to rest your joints.", quality: .notIdeal, explanation: "Stopping exercise actually increases stiffness and weakens the muscles supporting your joints.", learnMore: "Movement as medicine."),
            ScenarioChoice(text: "Take ibuprofen daily.", quality: .okay, explanation: "NSAIDs help with pain, but daily use can cause stomach issues. You need a sustainable plan.", learnMore: "Managing joint pain."),
            ScenarioChoice(text: "Switch to low-impact exercises like swimming or cycling.", quality: .best, explanation: "Low-impact exercise keeps joints mobile and muscles strong without causing excess strain.", learnMore: "Joint health and estrogen.")
          ],
          icon: "figure.walk.motion"
        )
      ]
    case .postMenopause:
      return [
        Scenario(
          title: "Staying Active",
          situation: "You want to start an exercise routine but worry about injuring your joints.",
          stage: .postMenopause,
          choices: [
            ScenarioChoice(text: "Decide it's too late to start exercising.", quality: .notIdeal, explanation: "It's never too late! Exercise is crucial for maintaining mobility and independence.", learnMore: "Benefits of exercise later in life."),
            ScenarioChoice(text: "Start running 5 miles a day.", quality: .okay, explanation: "Going from zero to intense exercise increases injury risk. Start slow.", learnMore: "Pacing your workouts."),
            ScenarioChoice(text: "Begin with low-impact activities like swimming or brisk walking.", quality: .best, explanation: "Low-impact exercises build strength and cardiovascular health safely.", learnMore: "Safe exercise routines.")
          ],
          icon: "figure.pool.swim"
        ),
        Scenario(
          title: "Unexpected Bleeding",
          situation: "It's been three years since your last period, but you suddenly notice spotting.",
          stage: .postMenopause,
          choices: [
            ScenarioChoice(text: "Assume it's just a random hormone fluctuation.", quality: .notIdeal, explanation: "Post-menopausal bleeding is never considered normal and must be investigated.", learnMore: "Why post-menopausal bleeding is serious."),
            ScenarioChoice(text: "Wait to see if it becomes a full period.", quality: .okay, explanation: "Waiting delays potential treatment. It's better to act quickly.", learnMore: "Time is of the essence."),
            ScenarioChoice(text: "Contact your doctor immediately for an evaluation.", quality: .best, explanation: "Any bleeding after menopause needs a doctor's check to rule out serious conditions.", learnMore: "Medical evaluations.")
          ],
          icon: "exclamationmark.triangle"
        ),
        Scenario(
          title: "Mental Sharpness",
          situation: "You want to make sure you're keeping your brain active and healthy.",
          stage: .postMenopause,
          choices: [
            ScenarioChoice(text: "Watch TV all day.", quality: .notIdeal, explanation: "Passive activities don't stimulate the brain enough to build new connections.", learnMore: "Neuroplasticity."),
            ScenarioChoice(text: "Do a crossword puzzle once a week.", quality: .okay, explanation: "Puzzles are good, but combining mental and social activities is even better.", learnMore: "Cognitive exercises."),
            ScenarioChoice(text: "Learn a new skill, read, and stay socially engaged.", quality: .best, explanation: "Continuous learning and social interaction are the best ways to maintain cognitive health.", learnMore: "Active aging.")
          ],
          icon: "brain.head.profile"
        ),
        Scenario(
          title: "Bone Density Scan",
          situation: "Your doctor suggests a DEXA scan to check your bone density.",
          stage: .postMenopause,
          choices: [
            ScenarioChoice(text: "Refuse the scan, you feel fine.", quality: .notIdeal, explanation: "Osteoporosis has no symptoms until a bone breaks. Scans are essential.", learnMore: "Understanding DEXA scans."),
            ScenarioChoice(text: "Agree, but assume the results will be bad.", quality: .okay, explanation: "Anxiety is normal, but the scan simply provides a baseline to guide your care.", learnMore: "Interpreting T-scores."),
            ScenarioChoice(text: "Get the scan to establish a baseline and guide preventative care.", quality: .best, explanation: "Knowing your bone density allows you and your doctor to take proactive steps to protect your skeleton.", learnMore: "Preventing fractures.")
          ],
          icon: "waveform.path.ecg"
        ),
        Scenario(
          title: "Skin Changes",
          situation: "You notice your skin is becoming thinner, drier, and bruises more easily.",
          stage: .postMenopause,
          choices: [
            ScenarioChoice(text: "Stop going outside to protect your skin.", quality: .notIdeal, explanation: "You still need Vitamin D and fresh air. Just use sun protection.", learnMore: "Sun protection and aging."),
            ScenarioChoice(text: "Buy anti-aging creams advertised on TV.", quality: .okay, explanation: "Some creams help, but basic hydration and sun protection are more important.", learnMore: "Effective skincare ingredients."),
            ScenarioChoice(text: "Use a gentle moisturizer daily, wear sunscreen, and stay hydrated.", quality: .best, explanation: "Consistent hydration (inside and out) and sun protection are the best ways to care for thinning skin.", learnMore: "Collagen and aging skin.")
          ],
          icon: "hand.raised"
        ),
        Scenario(
          title: "Pelvic Floor Weakness",
          situation: "You notice slight urine leakage when you cough or laugh.",
          stage: .postMenopause,
          choices: [
            ScenarioChoice(text: "Stop drinking water so you don't leak.", quality: .notIdeal, explanation: "Dehydration is dangerous and can actually irritate the bladder, worsening leaks.", learnMore: "Hydration and bladder health."),
            ScenarioChoice(text: "Just wear a pad every day and accept it.", quality: .okay, explanation: "Pads manage the symptom, but you can actually improve the underlying weakness.", learnMore: "Incontinence management."),
            ScenarioChoice(text: "Start doing Kegel exercises and consult a pelvic floor physical therapist.", quality: .best, explanation: "Pelvic floor therapy is highly effective for strengthening the muscles and stopping leakage.", learnMore: "Pelvic floor physical therapy.")
          ],
          icon: "figure.walk.motion"
        )
      ]
    }
  }
}
"""

with open("/Users/kamakshi/Documents/GitHub/Luma_App/LUMA/Scenarios/ScenarioData.swift", "w") as f:
    f.write(scenarios_code)
print("ScenarioData.swift updated successfully with many more scenarios!")
