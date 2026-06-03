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
                )
            ]
        }
    }
}
