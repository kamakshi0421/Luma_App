import SwiftUI

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
                    title: "PMS Cravings",
                    situation: "A week before your period, you're craving chocolate and junk food non-stop and feeling guilty about it.",
                    stage: .reproductive,
                    choices: [
                        ScenarioChoice(text: "Restrict all food and feel guilty.", quality: .notIdeal, explanation: "Restricting food can worsen mood swings and energy crashes. Your body needs extra fuel during the luteal phase.", learnMore: "Caloric needs during luteal phase."),
                        ScenarioChoice(text: "Give in completely and binge eat.", quality: .okay, explanation: "Honoring cravings is fine, but binge eating can make you feel worse physically.", learnMore: "Serotonin and carb cravings."),
                        ScenarioChoice(text: "Enjoy treats mindfully and add magnesium-rich foods.", quality: .best, explanation: "Progesterone increases metabolism before your period, so cravings are biological! Dark chocolate is rich in magnesium which helps cramps.", learnMore: "Progesterone and metabolism.")
                    ],
                    icon: "cup.and.saucer"
                )
            ]
        case .perimenopause:
            return [
                Scenario(
                    title: "Sudden Heat",
                    situation: "You're in a meeting and suddenly feel an intense wave of heat and start sweating.",
                    stage: .perimenopause,
                    choices: [
                        ScenarioChoice(text: "Try to ignore it and power through.", quality: .notIdeal, explanation: "Ignoring it might make you feel more uncomfortable and anxious.", learnMore: "Managing hot flashes."),
                        ScenarioChoice(text: "Apologize and leave the room.", quality: .okay, explanation: "Leaving is an option if you need a moment, but you don't always have to apologize.", learnMore: "Hot flashes in public."),
                        ScenarioChoice(text: "Drink cold water and take a slow, deep breath.", quality: .best, explanation: "Hydration and deep breathing help regulate your body's temperature and calm the nervous system.", learnMore: "Cooling strategies.")
                    ],
                    icon: "flame.fill"
                ),
                Scenario(
                    title: "Irregular Bleeding",
                    situation: "Your periods have become unpredictable — sometimes heavy, sometimes skipping months entirely.",
                    stage: .perimenopause,
                    choices: [
                        ScenarioChoice(text: "Assume something is seriously wrong.", quality: .notIdeal, explanation: "While changes can be alarming, irregular periods are the hallmark of perimenopause.", learnMore: "Fluctuating hormones in perimenopause."),
                        ScenarioChoice(text: "Ignore the changes entirely.", quality: .okay, explanation: "Some irregularity is expected, but tracking helps you notice patterns that might need attention.", learnMore: "When to worry about irregular bleeding."),
                        ScenarioChoice(text: "Track the patterns and discuss them with your doctor.", quality: .best, explanation: "Tracking gives your doctor valuable data. Fluctuating estrogen and progesterone cause these changes, and your doctor can rule out other causes.", learnMore: "Hormonal shifts in your 40s.")
                    ],
                    icon: "waveform.path.ecg"
                ),
                Scenario(
                    title: "Brain Fog",
                    situation: "You keep forgetting things at work — names, deadlines, even where you put your keys.",
                    stage: .perimenopause,
                    choices: [
                        ScenarioChoice(text: "Worry you're developing a serious memory condition.", quality: .notIdeal, explanation: "Perimenopausal brain fog is extremely common and is not a sign of dementia.", learnMore: "Estrogen and cognitive function."),
                        ScenarioChoice(text: "Load up on caffeine to stay sharp.", quality: .okay, explanation: "Caffeine can help short-term focus but may disrupt sleep, worsening the fog.", learnMore: "Caffeine and hormonal balance."),
                        ScenarioChoice(text: "Use lists, get quality sleep, and exercise regularly.", quality: .best, explanation: "Declining estrogen affects memory centers in the brain. Sleep, exercise, and organizational tools are the most effective strategies.", learnMore: "Neuroplasticity and menopause.")
                    ],
                    icon: "brain.head.profile"
                )
            ]
        case .menopause:
            return [
                Scenario(
                    title: "Sleepless Nights",
                    situation: "You haven't slept well for a week due to night sweats waking you up.",
                    stage: .menopause,
                    choices: [
                        ScenarioChoice(text: "Accept that you will never sleep well again.", quality: .notIdeal, explanation: "Poor sleep affects your overall health. There are ways to manage it.", learnMore: "Sleep and menopause."),
                        ScenarioChoice(text: "Take sleep medication every night.", quality: .okay, explanation: "Medication might help temporarily, but it doesn't address the root cause of night sweats.", learnMore: "Medication risks."),
                        ScenarioChoice(text: "Keep the room cool, wear breathable fabrics, and talk to your doctor.", quality: .best, explanation: "Environmental changes and medical advice are the most effective ways to manage symptoms.", learnMore: "Tips for night sweats.")
                    ],
                    icon: "moon.zzz.fill"
                ),
                Scenario(
                    title: "Mood Changes",
                    situation: "You feel more anxious and irritable than usual, and your family doesn't understand why.",
                    stage: .menopause,
                    choices: [
                        ScenarioChoice(text: "Bottle up your feelings to avoid conflict.", quality: .notIdeal, explanation: "Suppressing emotions can lead to depression and physical symptoms. Your feelings are valid.", learnMore: "Menopause and mental health."),
                        ScenarioChoice(text: "Snap at your family when frustrated.", quality: .okay, explanation: "It's understandable but damages relationships. Finding healthier outlets is important.", learnMore: "Emotional regulation strategies."),
                        ScenarioChoice(text: "Explain what you're going through and consider therapy or support groups.", quality: .best, explanation: "Declining estrogen affects serotonin and mood. Open communication and professional support can make a huge difference.", learnMore: "HRT and mood stabilization.")
                    ],
                    icon: "heart.circle"
                ),
                Scenario(
                    title: "Vaginal Dryness",
                    situation: "You're experiencing vaginal dryness that makes intimacy uncomfortable, and you feel embarrassed to talk about it.",
                    stage: .menopause,
                    choices: [
                        ScenarioChoice(text: "Avoid intimacy altogether.", quality: .notIdeal, explanation: "Avoidance can affect your relationship and emotional well-being. Solutions exist.", learnMore: "Vaginal health in menopause."),
                        ScenarioChoice(text: "Use a generic lubricant and hope it helps.", quality: .okay, explanation: "Lubricants provide temporary relief, but they don't address the underlying tissue changes.", learnMore: "Types of lubricants."),
                        ScenarioChoice(text: "Talk to your doctor about vaginal moisturizers or local estrogen therapy.", quality: .best, explanation: "Low estrogen causes vaginal tissue to thin and dry. Local estrogen therapy is safe and highly effective for most women.", learnMore: "Genitourinary Syndrome of Menopause.")
                    ],
                    icon: "hand.raised"
                )
            ]
        case .postMenopause:
            return [
                Scenario(
                    title: "Morning Stiffness",
                    situation: "You notice your joints feel stiff and achy every morning when you wake up.",
                    stage: .postMenopause,
                    choices: [
                        ScenarioChoice(text: "Avoid moving to prevent pain.", quality: .notIdeal, explanation: "Lack of movement actually makes joint stiffness worse over time.", learnMore: "Joint health."),
                        ScenarioChoice(text: "Take a painkiller immediately.", quality: .okay, explanation: "Painkillers offer temporary relief, but regular movement is a better long-term strategy.", learnMore: "Managing pain safely."),
                        ScenarioChoice(text: "Start the day with gentle stretching or yoga.", quality: .best, explanation: "Gentle movement lubricates the joints and reduces stiffness effectively.", learnMore: "Exercise for joints.")
                    ],
                    icon: "figure.walk"
                ),
                Scenario(
                    title: "Bone Health Scare",
                    situation: "Your doctor tells you your bone density has decreased and you're at risk for osteoporosis.",
                    stage: .postMenopause,
                    choices: [
                        ScenarioChoice(text: "Feel hopeless — bones can't get stronger at this age.", quality: .notIdeal, explanation: "Bones can absolutely improve with the right diet, exercise, and sometimes medication.", learnMore: "Bone remodeling at any age."),
                        ScenarioChoice(text: "Just take a calcium supplement.", quality: .okay, explanation: "Calcium helps, but without Vitamin D and weight-bearing exercise, absorption is limited.", learnMore: "Calcium absorption and Vitamin D."),
                        ScenarioChoice(text: "Start weight-bearing exercises, ensure calcium + Vitamin D intake, and discuss medication with your doctor.", quality: .best, explanation: "After menopause, estrogen's protective effect on bones is gone. A combined approach of exercise, nutrition, and medical guidance is most effective.", learnMore: "Estrogen and bone density.")
                    ],
                    icon: "figure.strengthtraining.traditional"
                ),
                Scenario(
                    title: "Heart Health",
                    situation: "You read that heart disease risk increases significantly after menopause and feel worried.",
                    stage: .postMenopause,
                    choices: [
                        ScenarioChoice(text: "Decide it's genetic and out of your control.", quality: .notIdeal, explanation: "While genetics play a role, lifestyle choices have a massive impact on heart health.", learnMore: "Modifiable heart disease risk factors."),
                        ScenarioChoice(text: "Start an extreme diet to lose weight fast.", quality: .okay, explanation: "Crash diets can stress the heart and lead to nutrient deficiencies. Sustainable changes work better.", learnMore: "Heart-healthy eating patterns."),
                        ScenarioChoice(text: "Focus on regular cardio, a Mediterranean-style diet, and get your cholesterol checked.", quality: .best, explanation: "Estrogen previously helped keep cholesterol in check. After menopause, proactive heart health management through exercise, diet, and regular checkups is essential.", learnMore: "Estrogen and cardiovascular protection.")
                    ],
                    icon: "heart.text.square"
                )
            ]
        }
    }
}
