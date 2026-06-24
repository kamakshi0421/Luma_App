import SwiftUI

import Foundation

import FoundationModels


struct LumaInsightResponse: Codable {
  let validation: String
  let explanation: String
  let support: String
  let reassurance: String
}

@available(iOS 26.0, *)
final class LumaAIEngine {
  
  private let model = SystemLanguageModel.default
  
  @available(iOS 26.0, *)
  func generateInsight(from summary: WeeklyPatternSummary) async throws -> LumaInsightResponse {
    
    let personalityPrompt = """
    You are Luma — a calm therapist and elder sister.
    
    Your tone:
    - Gentle
    - Emotionally validating
    - Science-backed but simple
    - Never alarming
    - Never diagnostic
    - Always reassuring
    
    Always:
    1. Start with validation.
    2. Explain simply.
    3. Offer 1–2 gentle suggestions.
    4. End with reassurance.
    
    Return output strictly in JSON format with keys:
    validation, explanation, support, reassurance.
   """
    
    let userPrompt = """
    User Stage: \(summary.stage)
    Average Stress: \(summary.averageStress)
    Sleep Trend: \(summary.sleepTrend)
    Mood Trend: \(summary.moodTrend)
    Cycle Status: \(summary.cycleStatus)
    
    Generate a gentle body insight.
   """
    
    let fullPrompt = personalityPrompt + "\n\n" + userPrompt
    
    
    let session = LanguageModelSession(model: model)
    let response = try await session.respond(to : fullPrompt)
    let text = response.content
    
    guard let data = text.data(using: String.Encoding.utf8) else {
      throw NSError(domain: "InvalidResponse", code: 0)
    }
    
    return try JSONDecoder().decode(LumaInsightResponse.self, from: data)
  }
}
