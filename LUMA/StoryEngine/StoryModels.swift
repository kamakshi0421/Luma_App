import SwiftUI

struct StoryCharacter: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let stageName: String
    let avatarEmoji: String
    let accentColor: Color
}

struct StoryChoice: Identifiable {
    let id = UUID()
    let text: String
    let nextSceneIndex: Int
    let feedback: String
}

enum StoryAnimationType: String {
    case menstruation
    case sparkles
    case sweat
    case sleep
}

struct StoryScene: Identifiable {
    let id = UUID()
    let narration: String
    var characterDialogue: String? = nil
    var choices: [StoryChoice]? = nil
    var educationalReveal: String? = nil
    var isEndScene: Bool = false
    var animationType: StoryAnimationType? = nil
}

struct StoryChapter: Identifiable {
    let id = UUID()
    let title: String
    let scenes: [StoryScene]
    let stage: LifeStage
}
