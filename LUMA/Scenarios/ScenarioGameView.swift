import SwiftUI

// MARK: - Premium Scenario Game View

@available(iOS 26.0, *)
struct ScenarioGameView: View {
  let stage: LifeStage
  @Environment(\.dismiss) private var dismiss

  @State private var scenarios: [Scenario] = []
  @State private var currentScenarioIndex = 0
  @State private var selectedChoice: ScenarioChoice? = nil
  @State private var showResult = false
  @State private var score = 0
  @State private var isComplete = false
  @State private var iconPulse = false
  @State private var showLearnMore = false

  private var progress: CGFloat {
    guard !scenarios.isEmpty else { return 0 }
    return CGFloat(currentScenarioIndex + 1) / CGFloat(scenarios.count)
  }

  var body: some View {
    ZStack(alignment: .topTrailing) {
      LumaBackground()

      if isComplete {
        completionScreen
          .transition(.opacity.combined(with: .scale(scale: 0.9)))
      } else if let scenario = scenarios[safe: currentScenarioIndex] {
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 0) {
            progressBar
              .padding(.top, 16)
              .padding(.horizontal, 24)

            scenarioCard(scenario)
              .padding(.horizontal, 20)
              .padding(.top, 20)

            choicesList(scenario)
              .padding(.horizontal, 20)
              .padding(.top, 16)

            if showResult {
              nextButton
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer(minLength: 40)
          }
          .padding(.top, 40)
        }
      }
    }
    .onAppear {
      if scenarios.isEmpty {
        resetGame()
      }
      withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
        iconPulse = true
      }
    }
  }

  // MARK: - Progress Bar

  private var progressBar: some View {
    VStack(spacing: 8) {
      HStack {
        Text("Question \(currentScenarioIndex + 1) of \(scenarios.count)")
          .font(.subheadline.weight(.semibold))
          .foregroundColor(.secondary)
        Spacer()
        Text("\(Int(progress * 100))%")
          .font(.caption.weight(.bold))
          .foregroundColor(.lumaPinkBubble)
      }

      GeometryReader { geo in
        ZStack(alignment: .leading) {
          Capsule()
            .fill(Color.lumaPinkBubble.opacity(0.15))
            .frame(height: 8)

          Capsule()
            .fill(Color.lumaPinkBubble)
            .frame(width: geo.size.width * progress, height: 8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
        }
      }
      .frame(height: 8)
    }
  }

  // MARK: - Scenario Card

  private func scenarioCard(_ scenario: Scenario) -> some View {
    VStack(spacing: 16) {
      // Animated icon
      ZStack {
        Circle()
          .fill(Color.lumaPinkBubble.opacity(0.12))
          .frame(width: 80, height: 80)
          .scaleEffect(iconPulse ? 1.1 : 1.0)

        Circle()
          .fill(Color.lumaPinkBubble.opacity(0.06))
          .frame(width: 100, height: 100)
          .scaleEffect(iconPulse ? 1.15 : 0.95)

        Image(systemName: scenario.icon)
          .font(.system(size: 34))
          .foregroundColor(.lumaPinkBubble)
      }
      .padding(.top, 8)

      // Title pill
      Text(scenario.title)
        .font(.caption.weight(.semibold))
        .foregroundColor(.lumaPinkBubble)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          Capsule()
            .fill(Color.lumaPinkBubble.opacity(0.1))
        )

      // Situation text
      Text(scenario.situation)
        .font(.body.weight(.medium))
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)
        .lineSpacing(4)
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
    .padding(24)
    .frame(maxWidth: .infinity)
    .background(
      ZStack {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
          .fill(.ultraThinMaterial)

        RoundedRectangle(cornerRadius: 24, style: .continuous)
          .fill(
            LinearGradient(
              colors: [
                Color.lumaPinkBubble.opacity(0.05),
                Color.clear
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )

        RoundedRectangle(cornerRadius: 24, style: .continuous)
          .stroke(Color.lumaPinkBubble.opacity(0.1), lineWidth: 1)
      }
    )
    .shadow(color: Color.black.opacity(0.04), radius: 12, y: 6)
  }

  // MARK: - Choice Cards

  private func choicesList(_ scenario: Scenario) -> some View {
    VStack(spacing: 12) {
      ForEach(Array(scenario.choices.enumerated()), id: \.element.id) { index, choice in
        choiceCard(choice, index: index)
      }
    }
  }

  private func choiceCard(_ choice: ScenarioChoice, index: Int) -> some View {
    let isSelected = selectedChoice?.id == choice.id
    let letterLabels = ["A", "B", "C", "D", "E"]
    let letter = index < letterLabels.count ? letterLabels[index] : "\(index + 1)"
    let accentColor = isSelected ? choice.quality.color : Color.lumaPinkBubble.opacity(0.3)

    return Button {
      handleChoice(choice)
    } label: {
      VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: .top, spacing: 14) {
          // Letter circle
          Text(letter)
            .font(.subheadline.weight(.bold))
            .foregroundColor(isSelected ? .white : .lumaPinkBubble)
            .frame(width: 32, height: 32)
            .background(
              Circle()
                .fill(isSelected ? choice.quality.color : Color.lumaPinkBubble.opacity(0.12))
            )

          // Choice text
          Text(choice.text)
            .font(.subheadline.weight(.medium))
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .lineSpacing(2)
            .frame(maxWidth: .infinity, alignment: .leading)

          // Quality indicator (when selected)
          if isSelected && showResult {
            Image(systemName: choice.quality.icon)
              .font(.title3)
              .foregroundColor(choice.quality.color)
              .transition(.scale.combined(with: .opacity))
          }
        }

        // Expanded result area
        if isSelected && showResult {
          VStack(alignment: .leading, spacing: 10) {
            Divider()
              .padding(.vertical, 6)

            HStack(spacing: 6) {
              Image(systemName: choice.quality.icon)
                .font(.caption)
                .foregroundColor(choice.quality.color)
              Text(choice.quality.label)
                .font(.caption.weight(.bold))
                .foregroundColor(choice.quality.color)
            }

            Text(choice.explanation)
              .font(.subheadline)
              .foregroundColor(.secondary)
              .lineSpacing(3)
              .fixedSize(horizontal: false, vertical: true)

            if !choice.learnMore.isEmpty {
              HStack(spacing: 4) {
                Image(systemName: "book.fill")
                  .font(.caption2)
                Text("Learn More")
                  .font(.caption.weight(.semibold))
              }
              .foregroundColor(.lumaPinkBubble)
              .padding(.horizontal, 10)
              .padding(.vertical, 5)
              .background(
                Capsule()
                  .fill(Color.lumaPinkBubble.opacity(0.1))
              )
              .onTapGesture {
                showLearnMore = true
              }
              .sheet(isPresented: $showLearnMore) {
                learnMoreSheet(choice)
              }
            }
          }
          .padding(.leading, 46)
          .transition(.opacity.combined(with: .move(edge: .top)))
        }
      }
      .padding(16)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(
              isSelected
                ? choice.quality.color.opacity(0.06)
                : Color(.secondarySystemBackground)
            )

          // Left accent bar
          RoundedRectangle(cornerRadius: 2)
            .fill(accentColor)
            .frame(width: 4)
            .padding(.vertical, 8)
        }
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(
            isSelected ? choice.quality.color.opacity(0.3) : Color.clear,
            lineWidth: 1.5
          )
      )
      .opacity(showResult && !isSelected ? 0.45 : 1.0)
      .animation(.spring(response: 0.4, dampingFraction: 0.75), value: isSelected)
      .animation(.spring(response: 0.4, dampingFraction: 0.75), value: showResult)
    }
    .buttonStyle(.plain)
    .disabled(showResult)
  }

  // MARK: - Learn More Sheet

  private func learnMoreSheet(_ choice: ScenarioChoice) -> some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Text(choice.learnMore)
            .font(.body)
            .foregroundColor(.primary)
            .lineSpacing(4)
        }
        .padding(24)
      }
      .navigationTitle("Learn More")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") { showLearnMore = false }
        }
      }
    }
  }

  // MARK: - Next Button

  private var nextButton: some View {
    Button {
      nextScenario()
    } label: {
      HStack(spacing: 8) {
        Text(currentScenarioIndex < scenarios.count - 1 ? "Next": "See Results")
          .font(.headline.weight(.bold))
        Image(systemName: "arrow.right")
          .font(.subheadline.weight(.bold))
      }
      .foregroundColor(.white)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.lumaPinkBubble)
      )
      .shadow(color: Color.lumaPinkBubble.opacity(0.3), radius: 10, y: 5)
    }
  }

  // MARK: - Completion Screen

  private var completionScreen: some View {
    VStack(spacing: 28) {
      Spacer()

      // Animated checkmark with ring
      CompletionCheckmark()

      // Score display
      HStack(alignment: .firstTextBaseline, spacing: 2) {
        Text("\(score)")
          .font(.system(size: 64, weight: .bold, design: .rounded))
          .foregroundColor(.primary)
        Text("/\(scenarios.count)")
          .font(.system(size: 28, weight: .semibold, design: .rounded))
          .foregroundColor(.secondary)
      }

      Text("Best Choices")
        .font(.subheadline.weight(.medium))
        .foregroundColor(.secondary)

      // Motivational message
      Text(motivationalMessage)
        .font(.title3.weight(.semibold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)

      Text(motivationalSubtext)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)

      Spacer()

      // Play Again button
      Button {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
          resetGame()
        }
      } label: {
        HStack(spacing: 8) {
          Image(systemName: "arrow.counterclockwise")
            .font(.subheadline.weight(.bold))
          Text("Play Again")
            .font(.headline.weight(.bold))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.lumaPinkBubble)
        )
        .shadow(color: Color.lumaPinkBubble.opacity(0.3), radius: 10, y: 5)
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 40)
    }
  }

  private var motivationalMessage: String {
    guard !scenarios.isEmpty else { return ""}
    let percentage = Double(score) / Double(scenarios.count)
    switch percentage {
    case 0.8...1.0:
      return "Amazing! You're a natural! "
    case 0.6..<0.8:
      return "Great job! Keep learning! "
    case 0.4..<0.6:
      return "Good effort! Room to grow! "
    default:
      return "Keep exploring! You'll get there! "
    }
  }

  private var motivationalSubtext: String {
    guard !scenarios.isEmpty else { return ""}
    let percentage = Double(score) / Double(scenarios.count)
    switch percentage {
    case 0.8...1.0:
      return "You clearly understand how to navigate these situations with confidence."
    case 0.6..<0.8:
      return "You have a solid foundation. A few more scenarios and you'll be an expert."
    case 0.4..<0.6:
      return "Every scenario is a learning opportunity. Try again to boost your knowledge!"
    default:
      return "Don't worry — these are tricky! Review the explanations and give it another go."
    }
  }

  // MARK: - Actions

  func handleChoice(_ choice: ScenarioChoice) {
    selectedChoice = choice
    if choice.quality == .best {
      score += 1
    }
    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
      showResult = true
    }
  }

  func nextScenario() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
      if currentScenarioIndex < scenarios.count - 1 {
        currentScenarioIndex += 1
        selectedChoice = nil
        showResult = false
        showLearnMore = false
      } else {
        isComplete = true
      }
    }
  }

  func resetGame() {
    let allScenarios = ScenarioLibrary.scenarios(for: stage)
    scenarios = Array(allScenarios.shuffled().prefix(3))
    currentScenarioIndex = 0
    selectedChoice = nil
    showResult = false
    showLearnMore = false
    score = 0
    isComplete = false
  }
}

// MARK: - Completion Checkmark Animation

@available(iOS 26.0, *)
struct CompletionCheckmark: View {
  @State private var ringScale: CGFloat = 0.5
  @State private var ringOpacity: Double = 0
  @State private var checkScale: CGFloat = 0.3
  @State private var checkOpacity: Double = 0

  var body: some View {
    ZStack {
      // Outer ring
      Circle()
        .stroke(Color.green.opacity(0.2), lineWidth: 4)
        .frame(width: 100, height: 100)
        .scaleEffect(ringScale)
        .opacity(ringOpacity)

      // Inner filled circle
      Circle()
        .fill(Color.green.opacity(0.1))
        .frame(width: 90, height: 90)
        .scaleEffect(ringScale)
        .opacity(ringOpacity)

      // Checkmark
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 60))
        .foregroundColor(.green)
        .scaleEffect(checkScale)
        .opacity(checkOpacity)
    }
    .onAppear {
      withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
        ringScale = 1.0
        ringOpacity = 1.0
      }
      withAnimation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.3)) {
        checkScale = 1.0
        checkOpacity = 1.0
      }
    }
  }
}

// MARK: - Safe Collection Subscript

extension Collection {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
