import SwiftUI


@available(iOS 26.0, *)
struct RevealView: View {
  
  
  @AppStorage("selectedStage")
  private var savedStageRaw: String = LifeStage.reproductive.rawValue

  private var currentStage: LifeStage {
    LifeStage(rawValue: savedStageRaw) ?? .reproductive
  }
  @State private var content = DecodedContentLoader.load()
  
  @State private var selectedTopic: NormalTopic?
  @State private var selectedCategory: MythCategory = .hormones
  @State private var showScenarios = false
  @State private var searchText = ""
  @State private var dailyMyth: DecodedMyth?
  @State private var showConstellation = false
  
  private var stageTopics: [NormalTopic] {
    NormalTopic.allTopics.filter {
      $0.relevantStages.contains(currentStage)
    }
  }

  private func topicForConcern(_ concern: CommonConcern) -> NormalTopic? {
    stageTopics.first {
      $0.relevantStages.contains(currentStage) &&
      $0.title.lowercased() == concern.title.lowercased()
    }
  }
  
  private var stageMyths: [DecodedMyth] {
    content.myths.filter {
      $0.stage == currentStage &&
      $0.category == selectedCategory
    }
  }
  
  private var stageConcerns: [CommonConcern] {
    content.commonConcerns.filter {
      $0.stage == currentStage
    }
  }
  
  private var stageRedFlag: StageRedFlag? {
    content.redFlags.first {
      $0.stage == currentStage
    }
  }
  
  private var filteredMyths: [DecodedMyth] {
    if searchText.isEmpty {
      return stageMyths
    } else {
      return content.myths.filter {
        $0.stage == currentStage &&
        ($0.myth.localizedCaseInsensitiveContains(searchText) ||
         $0.fact.localizedCaseInsensitiveContains(searchText))
      }
    }
  }
  
  private var filteredConcerns: [CommonConcern] {
    if searchText.isEmpty {
      return stageConcerns
    } else {
      return stageConcerns.filter {
        $0.title.localizedCaseInsensitiveContains(searchText) ||
        $0.explanation.localizedCaseInsensitiveContains(searchText)
      }
    }
  }
  
  var body: some View {
    
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
          
          Text("Uncover the truth about your body.")
            .font(.subheadline)
            .foregroundColor(.lumaMidGray)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          heroSection
          

          if searchText.isEmpty {
            scenarioSection
            concernsSection
            redFlagSection
          } else if !filteredConcerns.isEmpty {
            concernsSection
          }
          
          Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.bottom, 130)
      }
    .background {
      LumaBackground()
    }
    .navigationTitle("Reveal")
    .onAppear {
      if dailyMyth == nil {
        let randomMyth = content.myths.filter { $0.stage == currentStage }.randomElement()
        dailyMyth = randomMyth
        if let cat = randomMyth?.category {
          selectedCategory = cat
        }
      }
    }
    .onChange(of: currentStage) { _, newStage in
      content = DecodedContentLoader.load()
      let randomMyth = content.myths.filter { $0.stage == newStage }.randomElement()
      dailyMyth = randomMyth
      if let cat = randomMyth?.category {
        selectedCategory = cat
      }
    }
    .sheet(item: $selectedTopic) { topic in
      ConcernDetailSheet(topic: topic)
        .presentationDetents([.large])
        .presentationCornerRadius(28)
    }
    .navigationDestination(isPresented: $showScenarios) {
      ScenarioGameView(stage: currentStage)
    }
    .fullScreenCover(isPresented: $showConstellation) {
      SymptomConstellationView()
    }
  }
}
@available(iOS 26.0, *)
private extension RevealView {
  
  var heroSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      RevealSectionHeader(title: "Myth of the Day", icon: "star.fill")
      
      if searchText.isEmpty {
        filterSection
      }
      
      if let myth = dailyMyth {
        MythFactInteractiveCard(
          myth: myth.myth,
          fact: myth.fact
        )
        .id(myth.id)
      }
    }
  }

}

// MARK: - Section Header
private struct RevealSectionHeader: View {
  let title: String
  let icon: String
  
  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: icon)
        .font(.subheadline)
        .foregroundColor(.lumaPinkBubble)
      Text(title)
        .font(.headline)
        .foregroundColor(.primary)
    }
  }
}


@available(iOS 26.0, *)
private extension RevealView {
  
  var filterSection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(MythCategory.allCases) { category in
          Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
              selectedCategory = category
              let newMyth = content.myths.filter {
                $0.stage == currentStage &&
                $0.category == category
              }.randomElement()
              if let newMyth = newMyth {
                dailyMyth = newMyth
              }
            }
          } label: {
            HStack(spacing: 8) {
              Image(systemName: category.icon)
                .font(.system(size: 15, weight: .semibold))
              
              Text(category.rawValue)
                .font(.subheadline.weight(.medium))
            }
            .foregroundColor(
              selectedCategory == category ? .white : .primary.opacity(0.8)
            )
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
              Capsule()
                .fill(selectedCategory == category ? Color.lumaPinkBubble : Color.clear)
            )
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
              Capsule()
                .stroke(selectedCategory == category ? Color.clear : Color.white.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(selectedCategory == category ? 1.05 : 1.0)
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.vertical, 10)
    }
  }
}


@available(iOS 26.0, *)
private extension RevealView {
  
  var scenarioSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      RevealSectionHeader(title: "Real Life Scenarios", icon: "play.rectangle.fill")
      
      PastelActionCard(
        title: "What Would You Do?",
        subtitle: "Practice making choices in real-life situations.",
        icon: "play.circle.fill",
        tint: .blue,
        iconColor: .blue
      ) { showScenarios = true }
      
      PastelActionCard(
        title: "Symptom Decoder",
        subtitle: "Connect the dots to reveal hidden patterns in your body.",
        icon: "sparkles",
        tint: .purple,
        iconColor: .purple
      ) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        showConstellation = true
      }
    }
  }
}

@available(iOS 26.0, *)
private extension RevealView {
  
  var concernsSection: some View {
    
    VStack(alignment: .leading, spacing: 12) {
      
      RevealSectionHeader(title: "Is It Normal?", icon: "questionmark.bubble.fill")
      
      ForEach(Array(filteredConcerns.enumerated()), id: \.element.id) { index, concern in
        
        let bgColor = pastelColors[index % pastelColors.count]
        let strokeColor = pastelStrokes[index % pastelStrokes.count]
        
        PastelActionCard(
          title: concern.title,
          subtitle: concern.explanation,
          icon: "lightbulb",
          tint: strokeColor,
          iconColor: strokeColor
        ) {
          selectedTopic = topicForConcern(concern)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(concern.title). \(concern.explanation)")
        .accessibilityHint("Double tap to learn more")
        .accessibilityAddTraits(.isButton)
      }
    }
  }
}


@available(iOS 26.0, *)
private extension RevealView {
  
  var redFlagSection: some View {
    
    VStack(alignment: .leading, spacing: 12) {
      
      RevealSectionHeader(title: "When to See a Doctor", icon: "stethoscope")
      
      if let redFlag = stageRedFlag {
        
        HStack(alignment: .top, spacing: 14) {
          ZStack {
            Circle()
              .fill(Color.red.opacity(0.15))
              .frame(width: 44, height: 44)
            
            Image(systemName: "stethoscope")
              .font(.system(size: 20, weight: .semibold))
              .foregroundColor(.red)
          }
          
          VStack(alignment: .leading, spacing: 6) {
            ForEach(redFlag.points, id: \.self) { point in
              Text("• \(point)")
                .foregroundColor(.primary)
                .font(.subheadline)
            }
          }
          .padding(.top, 4)
          
          Spacer(minLength: 0)
        }
        .padding()
        .liquidGlass(cornerRadius: 22)
      }
    }
  }
}
import SwiftUI

struct MythFactInteractiveCard: View {
  
  let myth: String
  let fact: String
  
  @State private var flipped = false
  @State private var bookmarked = false
  @State private var showConfetti = false
  @State private var dragPoints: [CGPoint] = []
  
  @State private var pollAnswer: String? = nil
  @State private var shimmerOffset: CGFloat = -200
  
  var body: some View {
    
    ZStack {
      if showConfetti {
        ConfettiBurstView()
          .transition(.opacity)
      }
      
      // Fact card always underneath
      factCard
      
      if !flipped {
        mythCard
          .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
              flipped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
              triggerConfetti()
            }
          }
          .transition(.opacity)
      }
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(flipped ? "Fact. \(fact)": "Myth. \(myth)")
    .accessibilityHint(flipped ? "Truth revealed": "Tap to reveal the truth")
    .accessibilityAddTraits(.isButton)
    .frame(minHeight: 280)
    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: flipped)
    .onAppear {
      // Start shimmer animation
      withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
        shimmerOffset = 400
      }
    }
  }
}

// MARK: - Myth Card (Scratch Surface)
private extension MythFactInteractiveCard {
  
  var mythCard: some View {
    VStack(spacing: 0) {
      // Top label
      HStack {
        HStack(spacing: 6) {
          Image(systemName: "sparkles")
            .font(.caption)
          Text("MYTH")
            .font(.caption.weight(.heavy))
            .tracking(2.0)
        }
        .foregroundColor(Color.lumaPinkBubble)
        
        Spacer()
        
        Button {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            bookmarked.toggle()
          }
        } label: {
          Image(systemName: bookmarked ? "bookmark.fill": "bookmark")
            .font(.body)
            .foregroundColor(Color.lumaPinkBubble)
            .scaleEffect(bookmarked ? 1.2 : 1.0)
        }
      }
      .padding(.horizontal, 24)
      .padding(.top, 24)
      .padding(.bottom, 16)
      
      ZStack {
        // Subtle Watermark
        Image(systemName: "quote.opening")
          .font(.system(size: 80))
          .foregroundColor(Color.lumaPinkBubble.opacity(0.05))
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .offset(x: -10, y: -20)
        
        // Myth text
        Text(myth)
          .font(.system(size: 22, weight: .bold, design: .serif))
          .foregroundColor(.primary.opacity(0.9))
          .multilineTextAlignment(.leading)
          .lineSpacing(4)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 24)
      
      Spacer(minLength: 16)
      
      // Poll section
      pollSection(color: Color.lumaPinkBubble)
        .padding(.horizontal, 20)
      
      Spacer(minLength: 12)
      
      // Scratch prompt with shimmer
      ZStack {
        Capsule()
          .fill(Color.lumaPinkBubble.opacity(0.1))
          .frame(height: 48)
        
        // Shimmer overlay
        Capsule()
          .fill(Color.white.opacity(0.4))
          .frame(height: 48)
          .offset(x: shimmerOffset)
          .mask(
            Capsule()
              .frame(height: 48)
          )
        
        HStack(spacing: 8) {
          Image(systemName: "hand.tap.fill")
            .font(.subheadline)
          Text("Tap to reveal the truth")
            .font(.subheadline.weight(.semibold))
        }
        .foregroundColor(Color.lumaPinkBubble)
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 24)
    }
    .liquidGlass(cornerRadius: 24)
  }
}

// MARK: - Fact Card (Revealed)
private extension MythFactInteractiveCard {
  
  var factCard: some View {
    VStack(spacing: 0) {
      // Top label
      HStack {
        HStack(spacing: 6) {
          Image(systemName: "checkmark.seal.fill")
            .font(.caption)
            .foregroundColor(.green)
          Text("THE TRUTH")
            .font(.caption.weight(.heavy))
            .foregroundColor(.green)
            .tracking(2.0)
        }
        
        Spacer()
        
        Button {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            bookmarked.toggle()
          }
        } label: {
          Image(systemName: bookmarked ? "bookmark.fill": "bookmark")
            .font(.body)
            .foregroundColor(.green)
            .scaleEffect(bookmarked ? 1.2 : 1.0)
        }
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
      .padding(.bottom, 12)
      
      // Crossed out myth
      Text(myth)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .strikethrough(true, color: .red.opacity(0.6))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
      
      // Fact text
      Text(fact)
        .font(.title3.weight(.semibold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
      
      Spacer(minLength: 16)
      
      // Poll section
      pollSection(color: .green)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    .liquidGlass(cornerRadius: 24)
  }
}

// MARK: - Poll Section
private extension MythFactInteractiveCard {
  
  func pollSection(color: Color) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      
      // Thin divider
      Rectangle()
        .fill(color.opacity(0.15))
        .frame(height: 1)
        .padding(.bottom, 4)
      
      Text("Did you believe this?")
        .font(.caption.weight(.medium))
        .foregroundColor(.secondary)
        .accessibilityAddTraits(.isHeader)
      
      if pollAnswer == nil {
        HStack(spacing: 10) {
          pollButton("Yes", "hand.thumbsup", color)
          pollButton("No", "hand.thumbsdown", color)
        }
      } else {
        HStack(spacing: 10) {
          pollButton("Yes", "hand.thumbsup", color)
            .opacity(pollAnswer == "Yes" ? 1.0 : 0.4)
            .scaleEffect(pollAnswer == "Yes" ? 1.05 : 1.0)
          pollButton("No", "hand.thumbsdown", color)
            .opacity(pollAnswer == "No" ? 1.0 : 0.4)
            .scaleEffect(pollAnswer == "No" ? 1.05 : 1.0)
        }
        .disabled(true)
        
        Text("Thanks for sharing!")
          .font(.caption.weight(.medium))
          .foregroundColor(color)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.top, 4)
      }
    }
  }
  
  func pollButton(_ answer: String, _ icon: String, _ color: Color) -> some View {
    Button {
      registerVote(answer)
    } label: {
      HStack(spacing: 6) {
        Image(systemName: icon)
          .font(.caption)
        Text(answer)
          .font(.subheadline.weight(.semibold))
      }
      .foregroundColor(color)
      .padding(.horizontal, 20)
      .padding(.vertical, 10)
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(color.opacity(0.08))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .stroke(color.opacity(0.25), lineWidth: 1)
      )
    }
    .accessibilityLabel(answer)
    .accessibilityHint("Select your answer")
    .accessibilityAddTraits(.isButton)
  }
  
  func registerVote(_ answer: String) {
    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
      pollAnswer = answer
    }
    

    
    MythPollManager.shared.registerVote(for: myth, answer: answer)
    
    UIAccessibility.post(
      notification: .announcement,
      argument: "Vote recorded"
    )
  }
  

}

// MARK: - Confetti
private extension MythFactInteractiveCard {
  
  func triggerConfetti() {
    showConfetti = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
      showConfetti = false
    }
  }
}
struct ConfettiBurstView: View {
  
  @State private var animate = false
  
  var body: some View {
    GeometryReader { geo in
      ForEach(0..<25, id: \.self) { _ in
        Circle()
          .fill([
            Color.orange.opacity(0.7),
            Color.green.opacity(0.7),
            Color.lumaPinkBubble.opacity(0.7),
            Color.blue.opacity(0.7)
          ].randomElement()!)
          .frame(width: 8, height: 8)
          .position(
            x: CGFloat.random(in: 0...geo.size.width),
            y: animate ? geo.size.height + 40 : -20
          )
          .animation(
            .linear(duration: Double.random(in: 0.8...1.4)),
            value: animate
          )
      }
      .onAppear { animate = true }
    }
    .ignoresSafeArea()
    .accessibilityHidden(true)
  }
}
private let pastelColors: [Color] = [
  Color.pink.opacity(0.15),
  Color.purple.opacity(0.15),
  Color.blue.opacity(0.15),
  Color.green.opacity(0.15),
  Color.orange.opacity(0.15)
]

private let pastelStrokes: [Color] = [
  Color.pink.opacity(0.35),
  Color.purple.opacity(0.35),
  Color.blue.opacity(0.35),
  Color.green.opacity(0.35),
  Color.orange.opacity(0.35)
]
