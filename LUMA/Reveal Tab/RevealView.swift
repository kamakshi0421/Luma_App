import SwiftUI


@available(iOS 26.0, *)
struct RevealView: View {
  
  var onNavigateToAarohi: () -> Void = {}
  
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
            .padding(.top, 4)
          
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
      RevealSectionHeader(title: "Myth of the Day")
      
      if searchText.isEmpty {
        filterSection
      }
      
      if let myth = dailyMyth {
        MythFactInteractiveCard(
          myth: myth.myth,
          fact: myth.fact,
          onNavigateToAarohi: onNavigateToAarohi,
          imageName: currentStage.imageName
        )
        .id(myth.id)
      }
    }
  }

}

// MARK: - Section Header
private struct RevealSectionHeader: View {
  let title: String
  
  var body: some View {
    HStack(spacing: 6) {
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
            HStack(spacing: 6) {
              Image(systemName: category.icon)
                .font(.system(size: 13, weight: .semibold))
              
              Text(category.rawValue)
                .font(.footnote.weight(.medium))
            }
            .foregroundColor(
              selectedCategory == category ? .white : .primary.opacity(0.8)
            )
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
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
      .padding(.horizontal, 20)
      .padding(.vertical, 8)
    }
    .padding(.horizontal, -20) // Extend scrollview to screen edges
  }
}


@available(iOS 26.0, *)
private extension RevealView {
  
  var scenarioSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      RevealSectionHeader(title: "Real Life Scenarios")
      
      PastelActionCard(
        title: "What Would You Do?",
        subtitle: "Real-life choices, real learning.",
        icon: "play.circle.fill",
        tint: .blue,
        iconColor: .blue
      ) { showScenarios = true }
      
      PastelActionCard(
        title: "Symptom Decoder",
        subtitle: "Reveal hidden patterns in your body.",
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
      
      RevealSectionHeader(title: "Is It Normal?")
      
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
      
      RevealSectionHeader(title: "When to See a Doctor")
      
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
  var onNavigateToAarohi: () -> Void = {}
  var imageName: String? = nil
  
  @State private var flipped = false
  @State private var bookmarked = false
  @State private var dragPoints: [CGPoint] = []
  
  @State private var pollAnswer: String? = nil
  
  var body: some View {
    
    ZStack {
      // Fact card always underneath
      factCard
      
      if !flipped {
        mythCard
          .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
              flipped = true
            }
          }
          .transition(.opacity)
      }
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(flipped ? "Fact. \(fact)": "Myth. \(myth)")
    .accessibilityHint(flipped ? "Truth revealed": "Tap to reveal the truth")
    .accessibilityAddTraits(.isButton)
    .frame(minHeight: 230)
    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: flipped)
  }
}

// MARK: - Myth Card (Scratch Surface)
private extension MythFactInteractiveCard {
  
  var themeColor: Color {
    let colors: [Color] = [
      .lumaPinkBubble,
      .lumaAccent,
      Color(red: 0.85, green: 0.4, blue: 0.5), // Deep Rose
      Color(red: 0.9, green: 0.5, blue: 0.4),  // Warm Peach
      Color(red: 0.6, green: 0.3, blue: 0.8),  // Soft Violet
      Color(red: 0.9, green: 0.3, blue: 0.5)   // Coral Pink
    ]
    let index = abs(myth.hashValue) % colors.count
    return colors[index]
  }
  
  var mythCard: some View {
    ZStack {
      // Subtle Watermark
      if let imgName = imageName, let uiImage = UIImage(named: imgName) {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFit()
          .frame(width: 180, height: 180)
          .opacity(0.12)
          .frame(maxWidth: .infinity, alignment: .center)
          .offset(y: -10)
      } else {
        Image(systemName: "quote.opening")
          .font(.system(size: 80))
          .foregroundColor(themeColor.opacity(0.08))
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .offset(x: -10, y: -20)
      }
      
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
          .foregroundColor(themeColor)
          
          Spacer()
          
          Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
              bookmarked.toggle()
            }
          } label: {
            Image(systemName: bookmarked ? "bookmark.fill": "bookmark")
              .font(.body)
              .foregroundColor(themeColor)
              .scaleEffect(bookmarked ? 1.2 : 1.0)
          }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
        
        // Myth text
        Text(myth)
          .font(.system(size: 22, weight: .bold, design: .serif))
          .foregroundColor(.primary.opacity(0.9))
          .multilineTextAlignment(.leading)
          .lineSpacing(4)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 24)
        
        Spacer(minLength: 16)
      
      // Clean, premium text link (no background)
      HStack(spacing: 6) {
        Text("Tap to reveal truth")
          .font(.subheadline.weight(.medium))
        Image(systemName: "arrow.right")
      }
      .foregroundColor(themeColor)
      .padding(.vertical, 8)
      .padding(.bottom, 24)
      }
    }
    .liquidGlass(cornerRadius: 24)
  }
}

// MARK: - Fact Card (Revealed)
private extension MythFactInteractiveCard {
  
  var factCard: some View {
    ZStack {
      if let imgName = imageName, let uiImage = UIImage(named: imgName) {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFit()
          .frame(width: 180, height: 180)
          .opacity(0.12)
          .frame(maxWidth: .infinity, alignment: .center)
          .offset(y: -10)
      }
      
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
      
      // Navigate to Aarohi Button
      HStack {
        Button(action: onNavigateToAarohi) {
          HStack(spacing: 4) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
              .font(.caption)
            Text("Ask Aarohi to learn more")
              .font(.footnote.weight(.medium))
          }
          .foregroundColor(themeColor)
          .padding(.horizontal, 16)
          .padding(.vertical, 10)
          .background(themeColor.opacity(0.15))
          .clipShape(Capsule())
          .overlay(
            Capsule()
              .stroke(themeColor.opacity(0.4), lineWidth: 1)
          )
        }
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 20)
    }
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
      .foregroundColor(.primary)
      .padding(.horizontal, 20)
      .padding(.vertical, 10)
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(color.opacity(0.2))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .stroke(color.opacity(0.5), lineWidth: 1.5)
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


private let pastelColors: [Color] = [
  Color.pink.opacity(0.15),
  Color.purple.opacity(0.15),
  Color.blue.opacity(0.15),
  Color.green.opacity(0.15),
  Color.orange.opacity(0.15)
]

private let pastelStrokes: [Color] = [
  Color.pink,
  Color.purple,
  Color.blue,
  Color.green,
  Color.orange
]
