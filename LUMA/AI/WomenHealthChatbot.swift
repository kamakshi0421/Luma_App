import Foundation
import Foundation
internal import Combine
import FoundationModels
import SwiftUI

@available(iOS 26.0, *)
class WomenHealthChatbot: ObservableObject {
  
  private let session = LanguageModelSession()
  
  
  
  @AppStorage("selectedStage")
  private var savedStageRaw: String = LifeStage.reproductive.rawValue
  
  private var currentStage: LifeStage {
    LifeStage(rawValue: savedStageRaw) ?? .reproductive
  }
  
  func ask(question: String) async -> String {
    
    if let emergencyItem = HealthKnowledgeService.shared.searchEmergencyContent(for: question) {
      
      let emergencyPrompt = """
      You are Aarohi, a calm and serious health assistant.
      
      This situation may be urgent.
      
      Topic:
      \(emergencyItem.topic)
      
      Explanation:
      \(emergencyItem.explanation ?? "")
      
      Red Flags:
      \(emergencyItem.redFlagSymptoms?.joined(separator: ", ") ?? "")
      
      Required Action:
      \(emergencyItem.action ?? "Seek immediate medical care.")
      
      USER QUESTION:
      \(question)
      
      Respond clearly and seriously.
      No playful tone.
      Encourage immediate professional care.
     """
      
      do {
        let response = try await session.respond(to: emergencyPrompt)
        return response.content
      } catch {
        return "️ This may require urgent medical attention. Please seek immediate professional care."
      }
    }
    
    var knowledge = HealthKnowledgeService.shared.searchRelevantContent(for: question)
    
    if let item = knowledge,
      let stages = item.lifeStage,
      !stages.contains(currentStage.title) {
      knowledge = nil
    }
    
    let prompt = PromptBuilder.buildPrompt(
      userQuestion: question,
      knowledge: knowledge,
      lifeStage: currentStage
    )
    
    do {
      let response = try await session.respond(to: prompt)
      return response.content
    } catch {
      return "I'm having trouble responding right now Please try again."
    }
  }
}
