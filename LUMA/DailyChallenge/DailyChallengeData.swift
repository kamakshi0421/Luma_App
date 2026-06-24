import Foundation

struct ChallengeLibrary {
  static func allChallenges(for stage: LifeStage) -> [DailyChallenge] {
    return [
      DailyChallenge(
        type: .quiz,
        title: "Cycle Knowledge",
        description: "Test your knowledge about menstrual cycles.",
        stage: stage,
        question: "True or false: A perfectly normal, healthy menstrual cycle must be exactly 28 days long for everyone.",
        options: ["True", "False"],
        correctIndex: 1,
        explanation: "False! A normal cycle can range anywhere from 21 to 35 days, and it can even fluctuate slightly from month to month due to stress, travel, or normal hormonal shifts. Every body is wonderfully unique."
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
        description: "Let's uncover the biological truth and bust a common health myth today.",
        stage: stage,
        myth: "You should completely avoid exercise and physical activity during your period.",
        fact: "Actually, light to moderate exercise (like yoga, walking, or gentle stretching) increases blood flow and releases endorphins. This acts as a natural painkiller and can significantly help relieve painful cramps and boost your overall mood!",
        isMyth: true
      ),
      DailyChallenge(
        type: .microStory,
        title: "A Quick Story",
        description: "Read a short, relatable story and learn a valuable life lesson.",
        stage: stage,
        storyText: "Priya woke up feeling incredibly drained and tired, even after getting a full 8 hours of sleep. Instead of pushing herself, she checked her Luma app and realized her period was starting soon. Her body was working extra hard behind the scenes to prepare.",
        moral: "Listen closely to your body's whispers. It is completely okay to pause, rest, and give yourself grace when you need it."
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
