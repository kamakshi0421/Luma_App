import Foundation
import FoundationModels
internal import Combine

@available(iOS 26.0, *)
@MainActor
class WeeklyInsightManager: ObservableObject {
  
  @Published var title: String = ""
  @Published var message: String = ""
  @Published var isLoading: Bool = false
  @Published var justUnlocked: Bool = false
  
  private let session = LanguageModelSession()
  


  private func logsThisWeek(from logs: [SymptomLog]) -> [SymptomLog] {
    let calendar = Calendar.current
    
    return logs.filter { log in
      calendar.isDate(
        log.date,
        equalTo: Date(),
        toGranularity: .weekOfYear
      )
    }
  }

  

  @Published var currentLogCount: Int = 0

  var hasEnoughData: Bool {
    currentLogCount >= 3
  }
  
  
  func generateInsight(from logs: [SymptomLog]) async {
    
    let weeklyLogs = logsThisWeek(from: logs)
    
    // Deduplicate to find unique days
    let calendar = Calendar.current
    var latestLogPerDay: [Date: SymptomLog] = [:]
    for log in weeklyLogs {
      let day = calendar.startOfDay(for: log.date)
      latestLogPerDay[day] = log
    }
    let distinctLogs = latestLogPerDay.values.sorted { $0.date < $1.date }
    
    currentLogCount = distinctLogs.count
    
    guard currentLogCount >= 3 else {
      title = ""
      message = ""
      isLoading = false
      return
    }
    
    isLoading = true
    
    let summary = distinctLogs.enumerated().map { index, log in
     "Day \(index+1): Stress \(log.stress), Mood \(log.mood)"
    }.joined(separator: "\n")
    
    let prompt = """
    You are a soft and supportive women's wellness companion.
    
    Look at the weekly stress and mood data.
    
    Write:
    A short title (max 4 words).
    Two gentle insight sentences.
    Two simple suggestions using dash bullets (-).
    
    Keep tone warm and comforting.
    No stars.
    No numbering.
    
    Data:
    \(summary)
   """
    
    do {
      let response = try await session.respond(to: prompt)
      let output = response.content
      
      let lines = output.split(separator: "\n").map { String($0) }
      
      if let first = lines.first {
        title = first
        message = lines.dropFirst().joined(separator: "\n")
      } else {
        title = "Weekly Reflection"
        message = output
      }
      
    } catch {
      title = "Weekly Reflection"
      message = """
      Your week had some shifts.
      - Try slower evenings.
      - Be gentle with yourself.
     """
    }
    
    isLoading = false
  }
}
import SwiftUI

struct InsightReadyBadge: View {
  
  @State private var animate = false
  
  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: "sparkles")
      Text("Insight Ready")
    }
    .font(.caption.weight(.semibold))
    .foregroundColor(.white)
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .background(
      Capsule()
        .fill(Color.lumaPinkBubble)
    )
    .scaleEffect(animate ? 1.05 : 1)
    .animation(
      .easeInOut(duration: 1)
      .repeatForever(autoreverses: true),
      value: animate
    )
    .onAppear { animate = true }
  }
}
