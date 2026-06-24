import Foundation

struct ChallengeLibrary {
  static func allChallenges(for stage: LifeStage) -> [DailyChallenge] {
    return [
      DailyChallenge(
        type: .quiz,
        title: "Cycle Knowledge",
        description: "Test your knowledge about menstrual cycles.",
        stage: stage,
        question: "True or false: A normal menstrual cycle is exactly 28 days for everyone.",
        options: ["True", "False"],
        correctIndex: 1,
        explanation: "False! A normal cycle can range anywhere from 21 to 35 days. Everyone's body is different."
      ),
      DailyChallenge(
        type: .breathing,
        title: "Calm Your Mind",
        description: "Take a moment to center yourself.",
        stage: stage,
        inhaleSeconds: 4,
        holdSeconds: 7,
        exhaleSeconds: 8,
        rounds: 3
      ),
      DailyChallenge(
        type: .mythBuster,
        title: "Myth or Fact?",
        description: "Let's bust a common myth.",
        stage: stage,
        myth: "You shouldn't exercise during your period.",
        fact: "Light to moderate exercise can actually help relieve cramps and boost your mood!",
        isMyth: true
      ),
      DailyChallenge(
        type: .microStory,
        title: "A Quick Story",
        description: "Read a short story and learn a lesson.",
        stage: stage,
        storyText: "Priya woke up feeling incredibly tired, even after 8 hours of sleep. She realized her period was starting soon and her body was working extra hard.",
        moral: "Listen to your body. It's okay to rest when you need it."
      ),
      DailyChallenge(
        type: .bodyCheckIn,
        title: "Body Check-In",
        description: "How are you feeling today?",
        stage: stage,
        prompts: ["How is your energy level today?", "Any physical discomfort?", "How is your mood?"]
      )
    ]
  }
  
  static func challengeOfTheDay(for stage: LifeStage) -> DailyChallenge {
    let challenges = allChallenges(for: stage)
    let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    return challenges[dayOfYear % challenges.count]
  }
}
