import SwiftUI

struct DailyChallengeView: View {
  let stage: LifeStage
  @StateObject private var streakManager = StreakManager()
  @State private var challenge: DailyChallenge?
  @State private var showCompletion = false
  
  // Quiz state
  @State private var selectedOption: Int?
  @State private var showExplanation = false
  
  // Check-in state
  @State private var currentPromptIndex = 0
  
  // Myth state
  @State private var showMythResult = false
  @State private var guessedMyth: Bool?
  
  var body: some View {
    VStack(spacing: 20) {
      // Header
      HStack {
        Text("Today's Challenge")
          .font(.title2.bold())
          .foregroundColor(.primary)
        
        Spacer()
        
        StreakBadgeView(streakManager: streakManager)
      }
      .padding(.horizontal)
      .padding(.top)
      
      if streakManager.todayCompleted {
        completedStateView
      } else if let challenge = challenge {
        challengeContent(for: challenge)
      } else {
        ProgressView()
      }
      
      Spacer()
    }
    .background(LumaBackground())
    .onAppear {
      challenge = ChallengeLibrary.challengeOfTheDay(for: stage)
    }
  }
  
  @ViewBuilder
  func challengeContent(for challenge: DailyChallenge) -> some View {
    VStack(spacing: 16) {
      Text(challenge.title)
        .font(.title3.bold())
        .foregroundColor(.primary)
      
      Text(challenge.description)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      
      // Removed extra divider and padding
      
      switch challenge.type {
      case .quiz:
        quizView(challenge)
      case .breathing:
        BreathingExerciseView(
          inhaleSeconds: challenge.inhaleSeconds ?? 4,
          holdSeconds: challenge.holdSeconds ?? 7,
          exhaleSeconds: challenge.exhaleSeconds ?? 8,
          rounds: challenge.rounds ?? 3,
          onComplete: completeChallenge
        )
      case .bodyCheckIn:
        bodyCheckInView(challenge)
      case .mythBuster:
        mythBusterView(challenge)
      case .microStory:
        microStoryView(challenge)
      }
    }
    .padding()
    .liquidGlass(cornerRadius: 24)
    .padding()
  }
  
  var completedStateView: some View {
    VStack(spacing: 24) {
      Image(systemName: "checkmark.seal.fill")
        .font(.system(size: 60))
        .foregroundColor(.green)
      
      Text("Challenge Complete!")
        .font(.title2.bold())
        .foregroundColor(.primary)
      
      Text("Come back tomorrow for a new challenge.")
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      StreakDetailView(streakManager: streakManager)
        .padding()
    }
    .padding()
  }
  
  // MARK: - Specific Challenge Views
  
  @ViewBuilder
  func quizView(_ challenge: DailyChallenge) -> some View {
    VStack(spacing: 16) {
      Text(challenge.question ?? "")
        .font(.headline)
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)
      
      if let options = challenge.options {
        ForEach(0..<options.count, id: \.self) { index in
          Button {
            selectedOption = index
            showExplanation = true
            
            if index == challenge.correctIndex {
              DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                completeChallenge()
              }
            }
          } label: {
            Text(options[index])
              .font(.headline)
              .foregroundColor(.primary)
              .padding()
              .frame(maxWidth: .infinity)
              .background(quizOptionColor(index: index, correctIndex: challenge.correctIndex))
              .liquidGlass(cornerRadius: 16)
          }
          .disabled(showExplanation)
        }
      }
      
      if showExplanation {
        Text(challenge.explanation ?? "")
          .font(.subheadline)
          .foregroundColor(selectedOption == challenge.correctIndex ? .green : .orange)
          .padding()
          .liquidGlass(cornerRadius: 12)
          .transition(.opacity)
        
        if selectedOption != challenge.correctIndex {
          Button("Try Again") {
            selectedOption = nil
            showExplanation = false
          }
          .padding(.top, 8)
        }
      }
    }
  }
  
  func quizOptionColor(index: Int, correctIndex: Int?) -> Color {
    guard showExplanation else { return .clear }
    if index == correctIndex {
      return .green.opacity(0.2)
    } else if index == selectedOption {
      return .red.opacity(0.2)
    }
    return .clear
  }
  
  @ViewBuilder
  func bodyCheckInView(_ challenge: DailyChallenge) -> some View {
    VStack(spacing: 20) {
      if let prompts = challenge.prompts, currentPromptIndex < prompts.count {
        Text(prompts[currentPromptIndex])
          .font(.headline)
          .foregroundColor(.primary)
          .multilineTextAlignment(.center)
        
        HStack(spacing: 20) {
          ForEach(["face.smiling", "face.dashed", "circle.dotted", "cloud.rain", "cloud.heavyrain"], id: \.self) { emoji in
            Button {
              withAnimation {
                currentPromptIndex += 1
                if currentPromptIndex >= prompts.count {
                  completeChallenge()
                }
              }
            } label: {
              Text(emoji)
                .font(.system(size: 40))
            }
          }
        }
      }
    }
    .padding(.vertical)
  }
  
  @ViewBuilder
  func mythBusterView(_ challenge: DailyChallenge) -> some View {
    VStack(spacing: 20) {
      Text(challenge.myth ?? "")
        .font(.headline)
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)
        .padding()
        .background(Color.lumaPinkLight.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      
      if !showMythResult {
        HStack(spacing: 16) {
          Button {
            guessedMyth = true
            showMythResult = true
          } label: {
            Text("MYTH")
              .font(.headline)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.lumaPinkBubble)
              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          }
          
          Button {
            guessedMyth = false
            showMythResult = true
          } label: {
            Text("FACT")
              .font(.headline)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.lumaAccent)
              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          }
        }
      } else {
        VStack(spacing: 12) {
          let isCorrect = guessedMyth == challenge.isMyth
          HStack {
            Image(systemName: isCorrect ? "checkmark.circle.fill": "xmark.circle.fill")
              .foregroundColor(isCorrect ? .green : .orange)
            Text(isCorrect ? "Correct!": "Not quite!")
              .font(.headline)
              .foregroundColor(isCorrect ? .green : .orange)
          }
          
          Text(challenge.fact ?? "")
            .font(.subheadline)
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
          
          Button("Finish") {
            completeChallenge()
          }
          .padding(.top)
        }
        .padding()
        .liquidGlass(cornerRadius: 16)
        .transition(.scale)
      }
    }
  }
  
  @ViewBuilder
  func microStoryView(_ challenge: DailyChallenge) -> some View {
    VStack(spacing: 20) {
      Text(challenge.storyText ?? "")
        .font(.body)
        .foregroundColor(.primary)
        .padding()
        .background(Color.lumaPinkLight.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      
      if showExplanation {
        VStack(spacing: 8) {
          Text("The Lesson")
            .font(.headline)
            .foregroundColor(.purple)
          
          Text(challenge.moral ?? "")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .transition(.opacity)
        
        Button("Done") {
          completeChallenge()
        }
      } else {
        Button("Reveal Lesson") {
          withAnimation {
            showExplanation = true
          }
        }
      }
    }
  }
  
  func completeChallenge() {
    withAnimation {
      streakManager.markTodayComplete()
    }
  }
}
