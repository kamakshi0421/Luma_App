import SwiftUI

struct StoryLibrary {
    static let characters: [LifeStage: StoryCharacter] = [
        .prePuberty: StoryCharacter(name: "Mira", age: 9, stageName: "Pre-Puberty", avatarEmoji: "👧🏽", accentColor: .lumaPinkLight),
        .puberty: StoryCharacter(name: "Priya", age: 13, stageName: "Puberty", avatarEmoji: "👧🏾", accentColor: .lumaPinkBubble),
        .reproductive: StoryCharacter(name: "Ananya", age: 25, stageName: "Reproductive", avatarEmoji: "👩🏽", accentColor: .lumaAccent),
        .perimenopause: StoryCharacter(name: "Sunita", age: 46, stageName: "Perimenopause", avatarEmoji: "👩🏾", accentColor: .orange),
        .menopause: StoryCharacter(name: "Rekha", age: 52, stageName: "Menopause", avatarEmoji: "👩🏼", accentColor: .purple),
        .postMenopause: StoryCharacter(name: "Lakshmi", age: 60, stageName: "Post-Menopause", avatarEmoji: "👵🏽", accentColor: .teal)
    ]

    static func chapters(for stage: LifeStage) -> [StoryChapter] {
        switch stage {
        case .prePuberty:
            return prePubertyChapters()
        case .puberty:
            return pubertyChapters()
        case .reproductive:
            return reproductiveChapters()
        case .perimenopause:
            return perimenopauseChapters()
        case .menopause:
            return menopauseChapters()
        case .postMenopause:
            return postMenopauseChapters()
        }
    }
    
    static func prePubertyChapters() -> [StoryChapter] {
        return [
            StoryChapter(
                title: "A Big Changing World",
                scenes: [
                    StoryScene(narration: "Mira is 9 years old and has been feeling a little different lately.", characterDialogue: "My chest feels a bit tender today...", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She looks in the mirror and notices small bumps.", characterDialogue: "What are these?", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She wonders if this is normal.", characterDialogue: nil, choices: [
                        StoryChoice(text: "Ask mom", nextSceneIndex: 3, feedback: "Great idea! Talking to a trusted adult can ease worries."),
                        StoryChoice(text: "Ignore it", nextSceneIndex: 4, feedback: "It's normal to feel shy, but these changes are natural.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "Mira's mom explains that her body is starting to prepare for growing up.", characterDialogue: "These are called breast buds! It means your hormones are waking up.", choices: nil, educationalReveal: "Hormonal changes begin years before your first period. The hypothalamus starts sending signals, causing early signs like breast buds.", isEndScene: true),
                    StoryScene(narration: "Eventually, Mira realizes many of her friends are experiencing the same things.", characterDialogue: "Oh, it's just my body growing up!", choices: nil, educationalReveal: "Hormonal changes begin years before your first period. It's perfectly normal.", isEndScene: true)
                ],
                stage: .prePuberty,
                imageName: "mira_big_changing_world"
            ),
            StoryChapter(
                title: "The Emotional Rollercoaster",
                scenes: [
                    StoryScene(narration: "Mira is working on a puzzle but suddenly feels very frustrated.", characterDialogue: "Ugh, why won't this piece fit?! I'm so annoyed!", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She feels like she wants to cry for no reason.", characterDialogue: "Why am I getting so upset over a puzzle?", choices: [
                        StoryChoice(text: "Take a deep breath and step away", nextSceneIndex: 2, feedback: "Stepping away gives you time to calm down."),
                        StoryChoice(text: "Throw the puzzle", nextSceneIndex: 3, feedback: "Sometimes big feelings make us want to act out, but it's better to pause.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She steps away, drinks some water, and feels much better.", characterDialogue: "I guess I just needed a break.", choices: nil, educationalReveal: "As hormones begin to fluctuate, mood swings can happen even before puberty is fully visible. It's normal to have big feelings!", isEndScene: true),
                    StoryScene(narration: "Her dad helps her clean it up and they talk.", characterDialogue: "Sometimes our bodies make our feelings seem bigger than they are.", choices: nil, educationalReveal: "Hormones affect the brain's emotional centers. Learning to recognize and ride out these waves is a great skill.", isEndScene: true)
                ],
                stage: .prePuberty,
                imageName: "mira_emotional_rollercoaster"
            ),
            StoryChapter(
                title: "What's That Spot?",
                scenes: [
                    StoryScene(narration: "Mira is getting dressed and notices some white spots on her underwear.", characterDialogue: "Eww, what's this?", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She feels a bit grossed out and confused.", characterDialogue: "Is something wrong with me?", choices: [
                        StoryChoice(text: "Wash it quickly and forget it", nextSceneIndex: 2, feedback: "It's natural to want to hide it, but it's completely normal."),
                        StoryChoice(text: "Ask an older sister or mom", nextSceneIndex: 3, feedback: "They've been through it and can tell you what it is!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She learns later at school that it's called discharge.", characterDialogue: "Oh, the nurse said it's my body cleaning itself.", choices: nil, educationalReveal: "Vaginal discharge often starts 6-12 months before the first period. It's the vagina's natural way of cleaning itself.", isEndScene: true),
                    StoryScene(narration: "Her mom gives her pantyliners just in case.", characterDialogue: "So this just means my period is coming... eventually.", choices: nil, educationalReveal: "Vaginal discharge is completely normal and healthy. It's one of the signs that the body is preparing for menstruation.", isEndScene: true)
                ],
                stage: .prePuberty,
                imageName: "mira_whats_that_spot"
            ),
            StoryChapter(
                title: "Growing Pains",
                scenes: [
                    StoryScene(narration: "Mira wakes up in the middle of the night with aching legs.", characterDialogue: "Ouch, my knees and shins hurt so much.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She rubs her legs but it doesn't help much.", characterDialogue: "Why does it throb like that?", choices: [
                        StoryChoice(text: "Use a warm heating pad", nextSceneIndex: 2, feedback: "Heat helps relax the muscles around the growing bones."),
                        StoryChoice(text: "Stretch it out", nextSceneIndex: 3, feedback: "Gentle stretching can relieve the tension!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "The warmth soothes her legs and she falls back asleep.", characterDialogue: "Ah, that's better...", choices: nil, educationalReveal: "Growing pains are common during pre-puberty growth spurts. They usually happen at night and affect the legs.", isEndScene: true),
                    StoryScene(narration: "She does some gentle stretches and the ache lessens.", characterDialogue: "Okay, I think I can sleep now.", choices: nil, educationalReveal: "Rapid bone growth can cause muscle tension. Stretching and a warm bath before bed can help.", isEndScene: true)
                ],
                stage: .prePuberty,
                imageName: "mira_growing_pains"
            )
        ]
    }
    
    static func pubertyChapters() -> [StoryChapter] {
        return [
            StoryChapter(
                title: "The First Visit",
                scenes: [
                    StoryScene(narration: "Priya is at school when she feels something unexpected.", characterDialogue: "Oh no... Did my period just start?", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She rushes to the bathroom and sees a red spot.", characterDialogue: "What should I do now?", animationType: .menstruation),
                    StoryScene(narration: "She doesn't have any supplies with her.", characterDialogue: nil, choices: [
                        StoryChoice(text: "Use toilet paper", nextSceneIndex: 3, feedback: "A good temporary fix!"),
                        StoryChoice(text: "Ask the nurse for a pad", nextSceneIndex: 4, feedback: "The nurse is there to help with exactly this!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She wraps toilet paper in her underwear and heads to the nurse.", characterDialogue: "I just need a quick fix until I get home.", choices: nil, educationalReveal: "It's very common to be caught off guard by your first few periods. Toilet paper is a safe temporary solution.", isEndScene: true),
                    StoryScene(narration: "The nurse gives her a pad and a warm smile.", characterDialogue: "Thank you so much. I was panicking.", choices: nil, educationalReveal: "School nurses are equipped to help! Don't be afraid to ask for supplies.", isEndScene: true)
                ],
                stage: .puberty,
                imageName: "priya_first_period"
            ),
            StoryChapter(
                title: "Acne Attack!",
                scenes: [
                    StoryScene(narration: "Priya looks in the mirror before a friend's party and spots a huge pimple.", characterDialogue: "Oh no, why today?!", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She considers what to do with it.", characterDialogue: "Should I pop it?", choices: [
                        StoryChoice(text: "Pop it!", nextSceneIndex: 2, feedback: "Popping can cause scarring and spread bacteria!"),
                        StoryChoice(text: "Leave it alone and wash face gently", nextSceneIndex: 3, feedback: "Gentle care is the best way to handle breakouts.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She pops it, but it gets redder and angrier.", characterDialogue: "I should have just left it...", choices: nil, educationalReveal: "Hormonal shifts during puberty increase sebum (oil) production, leading to acne. Popping pushes bacteria deeper.", isEndScene: true),
                    StoryScene(narration: "She uses a gentle cleanser and puts a pimple patch on it.", characterDialogue: "At least I'm not making it worse.", choices: nil, educationalReveal: "Hormonal shifts increase sebum (oil) production. Gentle, consistent skincare helps manage breakouts.", isEndScene: true)
                ],
                stage: .puberty,
                imageName: "priya_acne_attack"
            ),
            StoryChapter(
                title: "The Sleepy Teen",
                scenes: [
                    StoryScene(narration: "It's 10 PM and Priya is wide awake, but the next morning she can't get out of bed.", characterDialogue: "Just five more minutes...", animationType: .sleep),
                    StoryScene(narration: "Her body clock feels completely off.", characterDialogue: "Why am I so tired during the day?", choices: [
                        StoryChoice(text: "Drink a lot of caffeine", nextSceneIndex: 2, feedback: "Caffeine might give a quick boost, but it disrupts sleep further."),
                        StoryChoice(text: "Try to get some sunlight in the morning", nextSceneIndex: 3, feedback: "Sunlight helps reset your circadian rhythm!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "The caffeine keeps her up again that night.", characterDialogue: "Now I'm wired AND tired.", choices: nil, educationalReveal: "During puberty, the brain's melatonin release shifts later at night, making teens naturally want to sleep later.", isEndScene: true),
                    StoryScene(narration: "She opens the blinds and the sunlight helps her wake up.", characterDialogue: "Okay, I feel a bit more alert now.", choices: nil, educationalReveal: "During puberty, the brain's melatonin release shifts later at night. Morning sunlight helps reset your internal clock.", isEndScene: true)
                ],
                stage: .puberty,
                imageName: "priya_sleepy_teen"
            ),
            StoryChapter(
                title: "Cramps in Class",
                scenes: [
                    StoryScene(narration: "Priya is sitting in math class when a sharp pain hits her lower abdomen.", characterDialogue: "Oww, my stomach...", animationType: .sweat),
                    StoryScene(narration: "She's having her period and the cramps are bad today.", characterDialogue: "I can't even focus on the board.", animationType: .menstruation),
                    StoryScene(narration: "What should she do?", characterDialogue: nil, choices: [
                        StoryChoice(text: "Quietly endure the pain", nextSceneIndex: 3, feedback: "You don't have to suffer in silence!"),
                        StoryChoice(text: "Ask to go to the nurse", nextSceneIndex: 4, feedback: "A hot water bottle or some rest can really help.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She suffers through the whole class, feeling miserable.", characterDialogue: "I wish I brought pain meds...", choices: nil, educationalReveal: "Uterine contractions cause cramps. Prostaglandins are the chemicals responsible for this pain.", isEndScene: true),
                    StoryScene(narration: "The nurse gives her a warm heating pad to hold against her stomach.", characterDialogue: "This feels so much better.", choices: nil, educationalReveal: "Heat increases blood flow to the pelvic area, helping to relax the muscles and relieve cramp pain.", isEndScene: true)
                ],
                stage: .puberty,
                imageName: "priya_cramps"
            )
        ]
    }
    
    static func reproductiveChapters() -> [StoryChapter] {
        return [
            StoryChapter(
                title: "The Waiting Game",
                scenes: [
                    StoryScene(narration: "Ananya has had a very stressful month at work.", characterDialogue: "My period is 5 days late...", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She tracks her cycle closely, so the delay is worrying her.", characterDialogue: "Could it be the stress?", choices: [
                        StoryChoice(text: "Take a pregnancy test", nextSceneIndex: 2, feedback: "Always good to rule it out if you're sexually active."),
                        StoryChoice(text: "Try to relax and wait", nextSceneIndex: 3, feedback: "Stress often delays ovulation!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "The test is negative. A few days later, her period arrives.", characterDialogue: "Phew! My body was just reacting to the busy week.", animationType: .menstruation),
                    StoryScene(narration: "She resolves to manage her stress better next month.", characterDialogue: nil, choices: nil, educationalReveal: "High cortisol levels from stress can suppress GnRH, delaying ovulation and pushing back your period.", isEndScene: true),
                    StoryScene(narration: "She tries to meditate, and a week later her period finally starts.", characterDialogue: "Okay, time to prioritize my mental health.", animationType: .menstruation),
                    StoryScene(narration: "She realizes stress was the culprit.", characterDialogue: nil, choices: nil, educationalReveal: "High cortisol levels from stress can suppress GnRH, delaying ovulation and pushing back your period.", isEndScene: true)
                ],
                stage: .reproductive,
                imageName: "ananya_waiting_game"
            ),
            StoryChapter(
                title: "The Energy Slump",
                scenes: [
                    StoryScene(narration: "Ananya is trying to work out, but she feels completely drained.", characterDialogue: "I usually love running, but today my legs feel like lead.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She checks her cycle app and sees she's in the late luteal phase.", characterDialogue: "Ah, my period is due in a few days.", choices: [
                        StoryChoice(text: "Push through a hard run", nextSceneIndex: 2, feedback: "Pushing too hard when energy is naturally low can increase cortisol."),
                        StoryChoice(text: "Do restorative yoga instead", nextSceneIndex: 3, feedback: "Listening to your body's energy levels is key!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She struggles through the run and feels exhausted for the rest of the day.", characterDialogue: "Maybe I should have taken it easy.", choices: nil, educationalReveal: "In the late luteal phase, progesterone peaks, which can have a sedative effect and lower energy levels.", isEndScene: true),
                    StoryScene(narration: "She does a gentle yoga flow and feels much more balanced.", characterDialogue: "That was exactly what I needed.", choices: nil, educationalReveal: "Progesterone peaks in the luteal phase, lowering energy. Adapting workouts to your cycle helps you stay active without burning out.", isEndScene: true)
                ],
                stage: .reproductive,
                imageName: "ananya_energy_slump"
            ),
            StoryChapter(
                title: "Ovulation Power",
                scenes: [
                    StoryScene(narration: "Ananya wakes up feeling incredibly energized and confident.", characterDialogue: "I feel like I can conquer the world today!", animationType: .sparkles),
                    StoryScene(narration: "She looks at her to-do list.", characterDialogue: "Should I tackle the big presentation today?", choices: [
                        StoryChoice(text: "Yes, go for it!", nextSceneIndex: 2, feedback: "Ovulation is a great time for social and high-energy tasks!"),
                        StoryChoice(text: "No, save it for later", nextSceneIndex: 3, feedback: "You might miss out on this natural energy boost.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She nails the presentation and charms her team.", characterDialogue: "That went amazingly well.", choices: nil, educationalReveal: "During ovulation, estrogen and testosterone peak, boosting energy, mood, and sociability.", isEndScene: true),
                    StoryScene(narration: "She delays it, and next week she feels much less motivated.", characterDialogue: "I should have done it when I had the energy.", choices: nil, educationalReveal: "Tracking your cycle can help you align demanding tasks with the high-energy ovulatory phase.", isEndScene: true)
                ],
                stage: .reproductive,
                imageName: "ananya_ovulation_power"
            ),
            StoryChapter(
                title: "PMS Cravings",
                scenes: [
                    StoryScene(narration: "It's 3 PM and Ananya cannot stop thinking about chocolate and chips.", characterDialogue: "I am SO hungry for junk food.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She is a few days away from her period.", characterDialogue: "Do I give in to the cravings?", choices: [
                        StoryChoice(text: "Eat the chocolate", nextSceneIndex: 2, feedback: "A little treat is totally fine!"),
                        StoryChoice(text: "Eat a balanced snack with dark chocolate", nextSceneIndex: 3, feedback: "Combining treats with protein/fiber stabilizes blood sugar.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She eats a huge chocolate bar, but feels a sugar crash an hour later.", characterDialogue: "Ugh, now I'm tired AND craving salt.", choices: nil, educationalReveal: "Hormonal shifts before your period can lower serotonin. Carbs and sweets temporarily boost it, but cause sugar crashes.", isEndScene: true),
                    StoryScene(narration: "She eats some almonds and a piece of dark chocolate.", characterDialogue: "Okay, craving satisfied, and I still have energy.", choices: nil, educationalReveal: "Dark chocolate has magnesium (good for cramps!), and pairing it with protein prevents a blood sugar roller coaster.", isEndScene: true)
                ],
                stage: .reproductive,
                imageName: "ananya_pms_cravings"
            )
        ]
    }
    
    static func perimenopauseChapters() -> [StoryChapter] {
        return [
            StoryChapter(
                title: "Suddenly Warm",
                scenes: [
                    StoryScene(narration: "Sunita is in the middle of a presentation when a wave of intense heat washes over her.", characterDialogue: "Is it really hot in here?", animationType: .sweat),
                    StoryScene(narration: "She realizes it's a hot flash.", characterDialogue: "I need to cool down.", choices: [
                        StoryChoice(text: "Drink cold water", nextSceneIndex: 2, feedback: "Staying hydrated helps regulate body temp!"),
                        StoryChoice(text: "Take off her jacket", nextSceneIndex: 3, feedback: "Layering is a great strategy for hot flashes.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "The cold water helps cool her core temperature quickly.", characterDialogue: "Much better.", choices: nil, educationalReveal: "Fluctuating estrogen levels can trigger the brain's thermostat, causing sudden hot flashes.", isEndScene: true),
                    StoryScene(narration: "Without her jacket, she feels the breeze and recovers quickly.", characterDialogue: "Just a small pause, I've got this.", choices: nil, educationalReveal: "Wearing breathable layers makes it much easier to manage sudden temperature shifts.", isEndScene: true)
                ],
                stage: .perimenopause,
                imageName: "sunita_suddenly_warm"
            ),
            StoryChapter(
                title: "The Brain Fog",
                scenes: [
                    StoryScene(narration: "Sunita is looking for her keys, but she can't remember where she put them. Again.", characterDialogue: "I swear I just had them. Why is my memory so fuzzy lately?", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She feels frustrated and worried.", characterDialogue: "Is something wrong with me?", choices: [
                        StoryChoice(text: "Worry about early dementia", nextSceneIndex: 2, feedback: "It's easy to jump to conclusions, but brain fog is very common in perimenopause."),
                        StoryChoice(text: "Start writing things down", nextSceneIndex: 3, feedback: "Using external tools like lists helps manage the temporary forgetfulness.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She spends the day anxious, which only makes it harder to focus.", characterDialogue: "I need to talk to my doctor.", choices: nil, educationalReveal: "Estrogen supports brain regions involved in memory. Fluctuations can cause temporary 'brain fog.'", isEndScene: true),
                    StoryScene(narration: "She starts keeping a small notebook. Writing things down eases her anxiety.", characterDialogue: "Okay, this helps. I just need a little extra support right now.", choices: nil, educationalReveal: "Estrogen supports brain regions involved in memory. This 'brain fog' is a common and usually temporary symptom of perimenopause.", isEndScene: true)
                ],
                stage: .perimenopause,
                imageName: "sunita_brain_fog"
            ),
            StoryChapter(
                title: "A Surprise Period",
                scenes: [
                    StoryScene(narration: "Sunita hasn't had a period in 3 months. She thought they were gone.", characterDialogue: "Wait, is that...?", animationType: .menstruation),
                    StoryScene(narration: "She suddenly starts bleeding while out running errands.", characterDialogue: "I didn't bring any pads with me!", choices: [
                        StoryChoice(text: "Rush home", nextSceneIndex: 2, feedback: "Sometimes you just gotta head back."),
                        StoryChoice(text: "Buy some at a nearby store", nextSceneIndex: 3, feedback: "Always good to be adaptable!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She makes it home and changes.", characterDialogue: "I guess I'm not in menopause yet.", choices: nil, educationalReveal: "Perimenopause is characterized by highly irregular periods. Cycles can skip months and then return unpredictably.", isEndScene: true),
                    StoryScene(narration: "She stops at a pharmacy and handles the situation.", characterDialogue: "Mental note: always carry a backup pad in my purse.", choices: nil, educationalReveal: "During perimenopause, ovulation becomes erratic. It's best to always be prepared for an unpredictable cycle.", isEndScene: true)
                ],
                stage: .perimenopause
            ),
            StoryChapter(
                title: "Mood Swing Mayhem",
                scenes: [
                    StoryScene(narration: "Sunita is making dinner, but everything her husband says is irritating her.", characterDialogue: "Why is he breathing so loudly?!", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She feels a sudden surge of anger, followed by wanting to cry.", characterDialogue: "What is going on with my emotions?", choices: [
                        StoryChoice(text: "Snap at him", nextSceneIndex: 2, feedback: "It happens, but communication is better."),
                        StoryChoice(text: "Explain she's feeling off", nextSceneIndex: 3, feedback: "Communicating your emotional state helps loved ones understand.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She snaps, an argument starts, and later she feels terrible.", characterDialogue: "I didn't mean it. It's just my hormones talking.", choices: nil, educationalReveal: "Hormonal shifts in perimenopause can cause severe mood swings, similar to intense PMS.", isEndScene: true),
                    StoryScene(narration: "She tells him she's feeling very sensitive. He gives her some space.", characterDialogue: "Thank you for understanding.", choices: nil, educationalReveal: "Being open about perimenopause symptoms can help partners provide the right support during mood swings.", isEndScene: true)
                ],
                stage: .perimenopause
            )
        ]
    }
    
    static func menopauseChapters() -> [StoryChapter] {
        return [
            StoryChapter(
                title: "A New Chapter",
                scenes: [
                    StoryScene(narration: "It has been 12 months since Rekha's last period.", characterDialogue: "I think I've officially reached menopause.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She reflects on how her body has changed.", characterDialogue: "I feel a strange sense of freedom, but also some mood swings.", choices: [
                        StoryChoice(text: "Talk to her doctor", nextSceneIndex: 2, feedback: "Doctors can help manage persistent symptoms."),
                        StoryChoice(text: "Start a new exercise routine", nextSceneIndex: 3, feedback: "Exercise is incredible for mood and physical health during this transition.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "The doctor prescribes a low-dose HRT.", characterDialogue: "This should help smooth out the transition.", choices: nil, educationalReveal: "Hormone Replacement Therapy (HRT) is highly effective for managing severe menopausal symptoms.", isEndScene: true),
                    StoryScene(narration: "Rekha embraces this new phase with daily yoga.", characterDialogue: "This isn't an ending. It's a new beginning.", choices: nil, educationalReveal: "Menopause is confirmed after 12 consecutive months without a period. It marks a transition to a new hormonal balance.", isEndScene: true)
                ],
                stage: .menopause
            ),
            StoryChapter(
                title: "The Sleep Thief",
                scenes: [
                    StoryScene(narration: "Rekha wakes up at 3 AM. She feels warm and completely awake.", characterDialogue: "Not again... I just want to sleep.", animationType: .sweat),
                    StoryScene(narration: "She lies in bed, her mind racing.", characterDialogue: "What should I do?", choices: [
                        StoryChoice(text: "Stay in bed and toss and turn", nextSceneIndex: 2, feedback: "This often leads to more frustration and anxiety about not sleeping."),
                        StoryChoice(text: "Get up and read a book", nextSceneIndex: 3, feedback: "Getting out of bed breaks the cycle of frustration.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She spends hours tossing and turning, feeling exhausted the next day.", characterDialogue: "I need to find a better way to handle this.", choices: nil, educationalReveal: "Night sweats and lowered estrogen can disrupt sleep architecture, leading to frequent waking.", isEndScene: true),
                    StoryScene(narration: "She reads for 20 minutes until she feels sleepy again, then goes back to bed.", characterDialogue: "That was much better than just lying there frustrated.", animationType: .sleep),
                    StoryScene(narration: "She wakes up feeling decently rested.", characterDialogue: nil, choices: nil, educationalReveal: "Night sweats and lowered estrogen can disrupt sleep. Leaving the bed when awake helps preserve it as a place for rest.", isEndScene: true)
                ],
                stage: .menopause
            ),
            StoryChapter(
                title: "Dry & Uncomfortable",
                scenes: [
                    StoryScene(narration: "Rekha has been feeling some physical discomfort and dryness.", characterDialogue: "Even sitting feels a bit uncomfortable today.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She's hesitant to bring it up with her doctor.", characterDialogue: "Is this just something I have to live with?", choices: [
                        StoryChoice(text: "Suffer in silence", nextSceneIndex: 2, feedback: "So many women do this, but there are treatments available!"),
                        StoryChoice(text: "Ask the gynecologist", nextSceneIndex: 3, feedback: "Doctors hear this all the time—it's very treatable.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She ignores it, but it gets worse over time.", characterDialogue: "I really should have asked for help.", choices: nil, educationalReveal: "Vaginal atrophy is caused by a drop in estrogen. Without treatment, it can lead to chronic pain and UTIs.", isEndScene: true),
                    StoryScene(narration: "The doctor prescribes a localized estrogen cream.", characterDialogue: "Oh wow, this made such a big difference.", choices: nil, educationalReveal: "Vaginal dryness is incredibly common due to low estrogen. Localized treatments are safe and highly effective.", isEndScene: true)
                ],
                stage: .menopause
            ),
            StoryChapter(
                title: "Rediscovering Intimacy",
                scenes: [
                    StoryScene(narration: "With the kids moved out and periods gone, Rekha feels a shift in her relationship.", characterDialogue: "It feels like it's just the two of us again.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She wants to reconnect with her partner, but feels different in her body.", characterDialogue: "How do we navigate this?", choices: [
                        StoryChoice(text: "Communicate openly", nextSceneIndex: 2, feedback: "Honesty is the foundation of intimacy."),
                        StoryChoice(text: "Plan a romantic date without pressure", nextSceneIndex: 3, feedback: "Removing expectations can help spark connection naturally.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "They talk honestly about their changing bodies and desires.", characterDialogue: "I'm glad we can talk about this.", choices: nil, educationalReveal: "Many women report an increase in sexual confidence after menopause once the fear of pregnancy is gone.", isEndScene: true),
                    StoryScene(narration: "They enjoy a lovely evening connecting emotionally first.", characterDialogue: "This is exactly what we needed.", choices: nil, educationalReveal: "Intimacy post-menopause might look different, but it can be deeply fulfilling with communication and patience.", isEndScene: true)
                ],
                stage: .menopause
            )
        ]
    }
    
    static func postMenopauseChapters() -> [StoryChapter] {
        return [
            StoryChapter(
                title: "Golden Strength",
                scenes: [
                    StoryScene(narration: "Lakshmi is enjoying her morning walk when she notices a bit of stiffness.", characterDialogue: "My joints aren't as smooth as they used to be.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She knows bone and joint health are priorities now.", characterDialogue: "What should I add to my routine?", choices: [
                        StoryChoice(text: "Yoga", nextSceneIndex: 2, feedback: "Yoga improves flexibility and balance!"),
                        StoryChoice(text: "Weight-bearing exercises", nextSceneIndex: 3, feedback: "Weight training helps preserve bone density!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She starts a daily yoga practice.", characterDialogue: "My flexibility is improving nicely.", choices: nil, educationalReveal: "Yoga helps lubricate the joints and improves balance, reducing the risk of falls in later years.", isEndScene: true),
                    StoryScene(narration: "She starts lifting light dumbbells.", characterDialogue: "I feel so strong!", choices: nil, educationalReveal: "Lower estrogen levels accelerate bone density loss. Weight-bearing exercise and calcium are essential for post-menopausal health.", isEndScene: true)
                ],
                stage: .postMenopause
            ),
            StoryChapter(
                title: "A Heart to Heart",
                scenes: [
                    StoryScene(narration: "Lakshmi is at her annual checkup. Her doctor mentions her cholesterol has slightly increased.", characterDialogue: "But my diet hasn't changed much!", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She wants to be proactive about her heart health.", characterDialogue: "What can I do?", choices: [
                        StoryChoice(text: "Eat more fiber and healthy fats", nextSceneIndex: 2, feedback: "Diet is a great way to support heart health naturally."),
                        StoryChoice(text: "Ask about medication", nextSceneIndex: 3, feedback: "Medication is an option, but lifestyle changes are often the first step.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She starts adding more oats and avocados to her diet.", characterDialogue: "This is delicious and good for my heart.", choices: nil, educationalReveal: "Estrogen has a protective effect on the cardiovascular system. After menopause, heart health becomes a primary focus.", isEndScene: true),
                    StoryScene(narration: "Her doctor suggests trying dietary changes first.", characterDialogue: "I'll start with oatmeal for breakfast.", choices: nil, educationalReveal: "Estrogen protects the cardiovascular system. After menopause, heart disease risk increases, making diet and exercise crucial.", isEndScene: true)
                ],
                stage: .postMenopause
            ),
            StoryChapter(
                title: "Finding Purpose",
                scenes: [
                    StoryScene(narration: "Lakshmi recently retired and suddenly has a lot of free time.", characterDialogue: "The house is so quiet now.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She feels a bit lost without her daily work routine.", characterDialogue: "What should I do with all this time?", choices: [
                        StoryChoice(text: "Join a local community group", nextSceneIndex: 2, feedback: "Social connection is vital for longevity and mental health!"),
                        StoryChoice(text: "Take up a new hobby", nextSceneIndex: 3, feedback: "Learning new things keeps the brain sharp.")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She joins a gardening club and makes new friends.", characterDialogue: "I love learning about native plants from everyone.", choices: nil, educationalReveal: "Strong social connections are one of the biggest predictors of a long, healthy, and happy post-menopausal life.", isEndScene: true),
                    StoryScene(narration: "She starts learning to paint.", characterDialogue: "I never knew I had a creative side!", choices: nil, educationalReveal: "Engaging in new hobbies stimulates neuroplasticity, keeping your brain healthy as you age.", isEndScene: true)
                ],
                stage: .postMenopause
            ),
            StoryChapter(
                title: "Pelvic Floor Power",
                scenes: [
                    StoryScene(narration: "Lakshmi sneezes forcefully and notices a tiny leak.", characterDialogue: "Oh dear, that's new.", choices: nil, educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She feels a bit embarrassed but wants to address it.", characterDialogue: "Is this just a normal part of aging?", choices: [
                        StoryChoice(text: "Wear a liner and ignore it", nextSceneIndex: 2, feedback: "It's a common coping mechanism, but you don't have to just live with it."),
                        StoryChoice(text: "Start doing pelvic floor exercises", nextSceneIndex: 3, feedback: "Kegels and pelvic floor therapy are incredibly effective!")
                    ], educationalReveal: nil, isEndScene: false),
                    StoryScene(narration: "She relies on liners, but the leaking happens more often.", characterDialogue: "I should probably tell my doctor.", choices: nil, educationalReveal: "Loss of estrogen weakens the pelvic floor muscles. Ignoring it can lead to worse incontinence over time.", isEndScene: true),
                    StoryScene(narration: "She looks up Kegel exercises and starts doing them daily.", characterDialogue: "I can already feel the difference after a few weeks.", choices: nil, educationalReveal: "Loss of estrogen weakens pelvic muscles. Regular pelvic floor exercises can significantly improve or cure mild incontinence.", isEndScene: true)
                ],
                stage: .postMenopause
            )
        ]
    }
}
