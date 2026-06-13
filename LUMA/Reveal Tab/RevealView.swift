import SwiftUI


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
    
    var body: some View {
        
        ZStack {
            
            LumaBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    headerSection
                    mythFactSection
                    scenarioSection
                    concernsSection
                    redFlagSection
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .onChange(of: currentStage) { _, newStage in
            content = DecodedContentLoader.load()
        }
        .sheet(item: $selectedTopic) { topic in
            ConcernDetailSheet(topic: topic)
                .presentationDetents([.large])
                .presentationCornerRadius(28)
        }
        .sheet(isPresented: $showScenarios) {
            ScenarioGameView(stage: currentStage)
        }
    }
}
@available(iOS 26.0, *)
private extension RevealView {
    
    var headerSection: some View {
        HStack {
            
            Spacer()
            
            VStack(spacing: 8) {
                
                Text("Darpan")
                    .font(.title2.bold())
                    .foregroundColor(.lumaDarkGray)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Let’s uncover the truth.")
                    .font(.subheadline)
                    .foregroundColor(.lumaMidGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            GlobalInfoButton(tab: .reveal)
        }
        .padding(.top, 16)
        .padding(.horizontal)
    }
}


@available(iOS 26.0, *)
private extension RevealView {
    
    var filterSection: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                
                ForEach(MythCategory.allCases) { category in
                    
                    Button {
                        selectedCategory = category

                    } label: {
                        
                        VStack(spacing: 8) {
                            Image(systemName: category.icon)
                                .font(.system(size: 18))
                            
                            Text(category.rawValue)
                                .font(.caption2)
                        }
                        .foregroundColor(
                            selectedCategory == category
                            ? .white
                            : .lumaDarkGray
                        )
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(
                                    selectedCategory == category
                                    ? Color.lumaPinkBubble
                                    : Color.white
                                )
                                .shadow(color: .black.opacity(0.05), radius: 6)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
//            .padding(.vertical, 4)
        }
    }
}



@available(iOS 26.0, *)
private extension RevealView {
    
    var mythFactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Truth Behind Myths")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
            
          
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(MythCategory.allCases) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category.rawValue.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    selectedCategory == category
                                    ? Color.lumaPinkBubble
                                    : Color.white
                                )
                                .foregroundColor(
                                    selectedCategory == category
                                    ? .white
                                    : .lumaDarkGray
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            if stageMyths.isEmpty {
                Text("No myths available for this category.")
                    .font(.caption)
                    .foregroundColor(.lumaMidGray)
            } else {
                VStack(spacing: 16) {
                    ForEach(stageMyths) { myth in
                        MythFactInteractiveCard(
                            myth: myth.myth,
                            fact: myth.fact
                        )
                    }
                }
            }
        }
    }
}


@available(iOS 26.0, *)
private extension RevealView {
    
    var scenarioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Real Life Scenarios")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
            
            Button {
                showScenarios = true
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("What Would You Do?")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Practice making choices in real-life situations.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .shadow(color: .orange.opacity(0.3), radius: 8, y: 4)
            }
        }
    }
}

@available(iOS 26.0, *)
private extension RevealView {
    
    var concernsSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Is it normal?")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
                .accessibilityAddTraits(.isHeader)
            
            ForEach(Array(stageConcerns.enumerated()), id: \.element.id) { index, concern in
                
                let bgColor = pastelColors[index % pastelColors.count]
                let strokeColor = pastelStrokes[index % pastelStrokes.count]
                
                Button {
                    selectedTopic = topicForConcern(concern)
                } label: {
                    
                    HStack(spacing: 12) {
                        
                        Image(systemName: "lightbulb")
                            .foregroundColor(.lumaPinkBubble)
                            .font(.system(size: 18, weight: .medium))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text(concern.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.lumaDarkGray)
                            
                            Text(concern.explanation)
                                .font(.caption)
                                .foregroundColor(.lumaMidGray)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.lumaMidGray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(bgColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(strokeColor, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
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
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("When to See a Doctor")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
                .accessibilityAddTraits(.isHeader)
            
            if let redFlag = stageRedFlag {
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(redFlag.points, id: \.self) { point in
                        Text("• \(point)")
                            .foregroundColor(.lumaDarkGray)
                    }
                }
                .font(.caption)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.lumaPinkLight.opacity(0.5))
                .cornerRadius(22)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.lumaPinkBubble.opacity(0.3), lineWidth: 1)
                )
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
    
    @State private var pollAnswer: String? = nil
    @State private var yesCount: Int = 0
    @State private var noCount: Int = 0
    
    private var totalVotes: Int {
        max(yesCount + noCount, 1)
    }
    
    var body: some View {
        
        ZStack {
            
            if showConfetti {
                ConfettiBurstView()
                    .transition(.opacity)
            }
            
            if flipped {
                factCard
            } else {
                mythCard
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(flipped ? "Fact. \(fact)" : "Myth. \(myth)")
        .accessibilityHint("Double tap to reveal the truth")
        .accessibilityAddTraits(.isButton)
        .frame(minHeight: 240)
        .rotation3DEffect(
            .degrees(flipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.4), value: flipped)
        .onTapGesture {
            UIAccessibility.post(
                notification: .announcement,
                argument: flipped ? "Fact revealed" : "Myth revealed"
            )
            if !flipped {
                flipped = true
                triggerConfetti()
            }
        }
    }
}


private extension MythFactInteractiveCard {
    
    var mythCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header(title: "Myth", color: .orange)
            
            Text(myth)
                .font(.subheadline)
                .foregroundColor(.lumaDarkGray)
            
            Divider()
            
            pollSection(color: .orange)
            
            Text("Tap to reveal the truth ✨")
                .font(.caption)
                .foregroundColor(.orange)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                )
        }
        .padding()
        .background(Color.orange.opacity(0.15))
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}


private extension MythFactInteractiveCard {
    
    var factCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header(title: "Fact", color: .green)
            
            Text(fact)
                .font(.subheadline)
                .foregroundColor(.lumaDarkGray)
            
            Divider()
            
            pollSection(color: .green)
        }
        .padding()
        .background(Color.green.opacity(0.15))
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}


private extension MythFactInteractiveCard {
    
    func header(title: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(color)
            
            Spacer()
            
            Button {
                bookmarked.toggle()
            } label: {
                Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(color)
            }
        }
    }
}


private extension MythFactInteractiveCard {
    
    func pollSection(color: Color) -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Did you believe this?")
                .font(.caption)
                .foregroundColor(.lumaMidGray)
                .accessibilityAddTraits(.isHeader)
            
            if pollAnswer == nil {
                
                HStack(spacing: 12) {
                    pollButton("Yes", color)
                    pollButton("No", color)
                }
                
            } else {
                
                percentageBar(
                    title: "Yes",
                    value: Double(yesCount) / Double(totalVotes),
                    color: color
                )
                
                percentageBar(
                    title: "No",
                    value: Double(noCount) / Double(totalVotes),
                    color: color.opacity(0.6)
                )
            }
        }
    }
    
    func pollButton(_ answer: String,
                    _ color: Color) -> some View {
        
        Button {
            registerVote(answer)
        } label: {
            Text(answer)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.white)
                .foregroundColor(.lumaDarkGray)
                .overlay(
                    Capsule()
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
                .clipShape(Capsule())
        }
        .accessibilityLabel(answer)
        .accessibilityHint("Select your answer")
        .accessibilityAddTraits(.isButton)
    }
    
    func registerVote(_ answer: String) {
        pollAnswer = answer
        
        if answer == "Yes" {
            yesCount += Int.random(in: 40...80)
            noCount += Int.random(in: 10...40)
        } else {
            noCount += Int.random(in: 40...80)
            yesCount += Int.random(in: 10...40)
        }
        
        
        UIAccessibility.post(
            notification: .announcement,
            argument: "Vote recorded"
        )
    }
    
    func percentageBar(title: String,
                       value: Double,
                       color: Color) -> some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                Text(title)
                    .font(.caption)
                
                Spacer()
                
                Text("\(Int(value * 100))%")
                    .font(.caption)
                    .bold()
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    
                    Capsule()
                        .fill(Color.white.opacity(0.5))
                    
                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * value)
                        .animation(.easeOut(duration: 0.6), value: value)
                }
            }
            .frame(height: 8)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) \(Int(value * 100)) percent")
    }
}


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
