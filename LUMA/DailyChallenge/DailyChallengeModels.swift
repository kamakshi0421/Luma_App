import Foundation

enum ChallengeType: String, Codable {
  case quiz
  case breathing
  case bodyCheckIn
  case mythBuster
  case microStory
}

struct DailyChallenge: Identifiable, Codable {
  var id = UUID()
  let type: ChallengeType
  let title: String
  let description: String
  let stage: LifeStage
  
  // Quiz properties
  var question: String?
  var options: [String]?
  var correctIndex: Int?
  var explanation: String?
  
  // Breathing properties
  var inhaleSeconds: Int?
  var holdSeconds: Int?
  var exhaleSeconds: Int?
  var rounds: Int?
  
  // MythBuster properties
  var myth: String?
  var fact: String?
  var isMyth: Bool?
  
  // MicroStory properties
  var storyText: String?
  var moral: String?
  
  // BodyCheckIn properties
  var prompts: [String]?
}

struct ChallengeProgress: Codable {
  let date: Date
  let completed: Bool
  let challengeId: UUID?
}
