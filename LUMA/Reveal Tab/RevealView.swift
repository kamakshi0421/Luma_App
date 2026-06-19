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
    @State private var searchText = ""
    @State private var dailyMyth: DecodedMyth?
    
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
                    
                    heroSection
                    
                    if searchText.isEmpty {
                        filterSection
                    }
                    
                    mythFactSection
                    
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
                .padding(.bottom, 40)
            }
        .background {
            LumaBackground()
        }
        .searchable(text: $searchText, prompt: "Search myths, facts, or concerns...")
        .navigationTitle("Reveal")
        .onAppear {
            if dailyMyth == nil {
                dailyMyth = content.myths.randomElement()
            }
        }
        .onChange(of: currentStage) { _, newStage in
            content = DecodedContentLoader.load()
            dailyMyth = content.myths.randomElement()
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
    
    var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            RevealSectionHeader(title: "Myth of the Day", emoji: "🌟")
            
            if let myth = dailyMyth {
                MythFactInteractiveCard(
                    myth: myth.myth,
                    fact: myth.fact
                )
            }
        }
    }
}

// MARK: - Section Header
private struct RevealSectionHeader: View {
    let title: String
    let emoji: String
    
    var body: some View {
        HStack(spacing: 6) {
            Text(emoji)
                .font(.subheadline)
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
                            : .primary
                        )
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(
                                    selectedCategory == category
                                    ? Color.lumaPinkBubble
                                    : Color.gray.opacity(0.15)
                                )
                        )
                        .background(.thinMaterial, in: Circle())
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
        VStack(alignment: .leading, spacing: 12) {
            RevealSectionHeader(title: "Truth Behind Myths", emoji: "🎭")
            

            if filteredMyths.isEmpty {
                Text(searchText.isEmpty ? "No myths available for this category." : "No matching myths found.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 16) {
                    ForEach(filteredMyths) { myth in
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
        VStack(alignment: .leading, spacing: 12) {
            RevealSectionHeader(title: "Real Life Scenarios", emoji: "🎬")
            
            PastelActionCard(
                title: "What Would You Do?",
                subtitle: "Practice making choices in real-life situations.",
                icon: "play.circle.fill",
                tint: .blue,
                iconColor: .blue
            ) { showScenarios = true }
        }
    }
}

@available(iOS 26.0, *)
private extension RevealView {
    
    var concernsSection: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            RevealSectionHeader(title: "Is It Normal?", emoji: "💭")
            
            ForEach(Array(filteredConcerns.enumerated()), id: \.element.id) { index, concern in
                
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
                                .foregroundColor(.primary)
                            
                            Text(concern.explanation)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .liquidGlass(cornerRadius: 20)
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
        
        VStack(alignment: .leading, spacing: 12) {
            
            RevealSectionHeader(title: "When to See a Doctor", emoji: "🩺")
            
            if let redFlag = stageRedFlag {
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(redFlag.points, id: \.self) { point in
                        Text("• \(point)")
                            .foregroundColor(.primary)
                    }
                }
                .font(.caption)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .liquidGlass(cornerRadius: 22)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.red.opacity(0.35), lineWidth: 1)
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
    @State private var dragPoints: [CGPoint] = []
    
    @State private var pollAnswer: String? = nil
    @State private var yesCount: Int = 0
    @State private var noCount: Int = 0
    
    @State private var removeListener: (() -> Void)? = nil
    
    private var totalVotes: Int {
        max(yesCount + noCount, 1)
    }
    
    var body: some View {
        
        ZStack {
            
            if showConfetti {
                ConfettiBurstView()
                    .transition(.opacity)
            }
            
            factCard // Always underneath
            
            if !flipped {
                mythCard
                    .mask(
                        Canvas { context, size in
                            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.white))
                            
                            var path = Path()
                            if let first = dragPoints.first {
                                path.move(to: first)
                                for point in dragPoints.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                            
                            context.blendMode = .destinationOut
                            context.stroke(path, with: .color(.clear), style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .round))
                        }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                dragPoints.append(value.location)
                                if dragPoints.count > 70 && !flipped {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        flipped = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        triggerConfetti()
                                    }
                                }
                            }
                    )
                    .transition(.opacity)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(flipped ? "Fact. \(fact)" : "Myth. \(myth)")
        .accessibilityHint(flipped ? "Truth revealed" : "Scratch card to reveal the truth")
        .accessibilityAddTraits(.isButton)
        .frame(minHeight: 240)
        .animation(.easeOut(duration: 0.5), value: flipped)
        .onAppear {
            removeListener = MythPollManager.shared.attachPollListener(for: myth) { yes, no in
                self.yesCount = yes
                self.noCount = no
            }
        }
        .onDisappear {
            removeListener?()
        }
    }
}


private extension MythFactInteractiveCard {
    
    var mythCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header(title: "Myth", color: .orange)
            
            Text(myth)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Divider()
            
            pollSection(color: .orange)
            
            Text("Scratch to reveal the truth ✨")
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
        .liquidGlass(cornerRadius: 22)
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
                .foregroundColor(.primary)
            
            Divider()
            
            pollSection(color: .green)
        }
        .padding()
        .liquidGlass(cornerRadius: 22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
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
                .foregroundColor(.secondary)
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
                .background(.thinMaterial, in: Capsule())
                .foregroundColor(.primary)
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
        
        // Optimistic UI update
        if answer == "Yes" {
            yesCount += 1
        } else {
            noCount += 1
        }
        
        // Push to Firebase
        MythPollManager.shared.registerVote(for: myth, answer: answer)
        
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
