import SwiftUI

struct InteractivePlaygroundView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedStage") private var savedStageRaw: String = LifeStage.reproductive.rawValue
    
    private var currentStage: LifeStage {
        LifeStage(rawValue: savedStageRaw) ?? .reproductive
    }
    
    @AppStorage("hideGlobalFAB") private var hideGlobalFAB: Bool = false
    
    var body: some View {
        ZStack {
            LumaBackground()
            
            VStack(spacing: 0) {
                // Native navigation handles header
                
                HormoneSimulatorView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Cycle Insights")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            hideGlobalFAB = true
        }
        .onDisappear {
            hideGlobalFAB = false
        }
    }
}

// MARK: - OPTION 1: HORMONE SIMULATOR VIEW
struct HormoneSimulatorView: View {
    @State private var day: Double = 14.0
    
    // Derived values for animations
    private var phase: CyclePhase {
        switch day {
        case 1...5: return .menstrual
        case 5.001...13.5: return .follicular
        case 13.501...15.5: return .ovulatory
        default: return .luteal
        }
    }
    
    enum CyclePhase {
        case menstrual, follicular, ovulatory, luteal
        
        var title: String {
            switch self {
            case .menstrual: return "Menstrual Phase"
            case .follicular: return "Follicular Phase"
            case .ovulatory: return "Ovulatory Phase"
            case .luteal: return "Luteal Phase"
            }
        }
        
        var description: String {
            switch self {
            case .menstrual: return "Day 1-5: Estrogen & Progesterone are low. The uterine lining sheds."
            case .follicular: return "Day 6-13: Estrogen rises, stimulating follicle growth and thickening uterine lining."
            case .ovulatory: return "Day 14: LH surges to trigger egg release. Highest fertility window."
            case .luteal: return "Day 15-28: Progesterone dominates to support potential pregnancy, leading to PMS if egg isn't fertilized."
            }
        }
        
        var color: Color {
            switch self {
            case .menstrual: return .red.opacity(0.7)
            case .follicular: return .blue.opacity(0.7)
            case .ovulatory: return .purple.opacity(0.7)
            case .luteal: return .orange.opacity(0.7)
            }
        }
    }
    
    // Hormones curve coordinates formula
    private func hormoneLevel(name: String, currentDay: Double) -> Double {
        switch name {
        case "Estrogen":
            // Estrogen peaks right before ovulation (Day 13-14), drops slightly, then has a secondary peak during luteal phase (Day 21).
            if currentDay <= 14 {
                return 10.0 + pow(currentDay / 14.0, 3) * 80.0
            } else {
                let lutealFactor = sin((currentDay - 14.0) * Double.pi / 14.0)
                return 20.0 + lutealFactor * 45.0
            }
        case "Progesterone":
            // Progesterone stays low, then rises significantly after ovulation, peaking at day 21.
            if currentDay <= 14 {
                return 5.0 + (currentDay / 14.0) * 5.0
            } else {
                let lutealFactor = sin((currentDay - 14.0) * Double.pi / 14.0)
                return 10.0 + lutealFactor * 75.0
            }
        case "LH":
            // Sharp surge at day 13-14, low otherwise
            if currentDay >= 12 && currentDay <= 15 {
                let diff = abs(currentDay - 13.8)
                return max(10, 95 - diff * 45)
            } else {
                return 10 + sin(currentDay * Double.pi / 14) * 5
            }
        case "FSH":
            // Small surge during ovulation
            if currentDay >= 12 && currentDay <= 15 {
                let diff = abs(currentDay - 13.8)
                return max(15, 60 - diff * 25)
            } else {
                return 15 + sin(currentDay * Double.pi / 14) * 8
            }
        default:
            return 0.0
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Interactive Phase Indicator
                VStack(spacing: 8) {
                    Text(phase.title)
                        .font(.title3.bold())
                        .foregroundColor(phase.color)
                        .scaleEffect(1.05)
                        .animation(.spring(), value: phase)
                    
                    Text(phase.description)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .liquidGlass(cornerRadius: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(phase.color.opacity(0.4), lineWidth: 1.5)
                )
                .padding(.horizontal, 20)
                
                // Chart Box
                VStack(alignment: .leading, spacing: 12) {
                    Text("Day \(Int(day)) of 28-Day Cycle")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Wave Visualizer
                    ZStack(alignment: .leading) {
                        // Background Grid
                        GeometryReader { geo in
                            Path { path in
                                for i in 1...3 {
                                    let y = geo.size.height * CGFloat(i) / 4.0
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                                }
                            }
                            .stroke(Color.secondary.opacity(0.2), style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [4, 4]))
                            
                            // Estrogen line
                            Path { path in
                                for d in 1...28 {
                                    let x = geo.size.width * CGFloat(d - 1) / 27.0
                                    let y = geo.size.height * (1.0 - CGFloat(hormoneLevel(name: "Estrogen", currentDay: Double(d)) / 100.0))
                                    if d == 1 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .stroke(Color.pink, lineWidth: 3)
                            
                            // Progesterone line
                            Path { path in
                                for d in 1...28 {
                                    let x = geo.size.width * CGFloat(d - 1) / 27.0
                                    let y = geo.size.height * (1.0 - CGFloat(hormoneLevel(name: "Progesterone", currentDay: Double(d)) / 100.0))
                                    if d == 1 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .stroke(Color.orange, lineWidth: 3)
                            
                            // LH line (surge)
                            Path { path in
                                for d in 1...28 {
                                    let x = geo.size.width * CGFloat(d - 1) / 27.0
                                    let y = geo.size.height * (1.0 - CGFloat(hormoneLevel(name: "LH", currentDay: Double(d)) / 100.0))
                                    if d == 1 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .stroke(Color.purple, lineWidth: 2)
                            
                            // Vertical Day Line Indicator
                            let xPos = geo.size.width * CGFloat(day - 1) / 27.0
                            Rectangle()
                                .fill(phase.color)
                                .frame(width: 2)
                                .position(x: xPos, y: geo.size.height / 2)
                                .shadow(radius: 2)
                            
                            Circle()
                                .fill(phase.color)
                                .frame(width: 10, height: 10)
                                .position(x: xPos, y: geo.size.height * (1.0 - CGFloat(hormoneLevel(name: "Estrogen", currentDay: day) / 100.0)))
                            
                            Circle()
                                .fill(phase.color)
                                .frame(width: 10, height: 10)
                                .position(x: xPos, y: geo.size.height * (1.0 - CGFloat(hormoneLevel(name: "Progesterone", currentDay: day) / 100.0)))
                        }
                    }
                    .frame(height: 180)
                    .padding()
                    .liquidGlass(cornerRadius: 18)
                    
                    // Legend
                    HStack(spacing: 16) {
                        LegendItem(color: .pink, title: "Estrogen")
                        LegendItem(color: .orange, title: "Progesterone")
                        LegendItem(color: .purple, title: "LH (Luteinizing)")
                    }
                    .padding(.horizontal, 4)
                }
                .padding(.horizontal, 20)
                
                // Slider Section
                VStack(spacing: 8) {
                    Slider(value: $day, in: 1...28, step: 0.5)
                        .accentColor(phase.color)
                        .padding(.horizontal)
                }
                .padding()
                .liquidGlass(cornerRadius: 18)
                .padding(.horizontal, 20)
                
                // Meters & Body stats simulator
                VStack(alignment: .leading, spacing: 14) {
                    Text("Physical & Emotional Indicators")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 12) {
                        IndicatorProgressView(title: "Energy Level", value: getEnergyValue(for: day), color: .orange, icon: "bolt.fill")
                        IndicatorProgressView(title: "Mood Stability", value: getMoodValue(for: day), color: .pink, icon: "heart.text.square.fill")
                        IndicatorProgressView(title: "Skin Clarity", value: getSkinValue(for: day), color: .teal, icon: "sparkles")
                        IndicatorProgressView(title: "Basal Temperature", value: getTempValue(for: day), color: .red, icon: "thermometer.medium", suffix: "°C")
                    }
                }
                .padding(20)
                .liquidGlass(cornerRadius: 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }
    
    // Indicators calculation based on day
    private func getEnergyValue(for day: Double) -> Double {
        if day <= 5 { return 0.35 }
        if day <= 14 { return 0.5 + (day - 5.0) / 9.0 * 0.45 }
        if day <= 21 { return 0.85 - (day - 14.0) / 7.0 * 0.2 }
        return 0.65 - (day - 21.0) / 7.0 * 0.35
    }
    
    private func getMoodValue(for day: Double) -> Double {
        if day <= 5 { return 0.5 }
        if day <= 14 { return 0.6 + (day - 5.0) / 9.0 * 0.3 }
        if day <= 21 { return 0.8 }
        return 0.8 - (day - 21.0) / 7.0 * 0.45 // PMS drop
    }
    
    private func getSkinValue(for day: Double) -> Double {
        // High estrogen increases skin quality, luteal phase hormones might trigger oiliness
        if day <= 14 { return 0.7 + (day / 14.0) * 0.2 }
        if day <= 23 { return 0.85 - (day - 14.0) / 9.0 * 0.25 }
        return 0.6 - (day - 23.0) / 5.0 * 0.2
    }
    
    private func getTempValue(for day: Double) -> Double {
        // Rises slightly (~0.5°C) post-ovulation
        if day <= 14 {
            return 36.2 + (day / 14.0) * 0.2
        } else {
            return 36.7 - ((day - 14.0) / 14.0) * 0.3
        }
    }
}

struct LegendItem: View {
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct IndicatorProgressView: View {
    let title: String
    let value: Double
    let color: Color
    let icon: String
    var suffix: String = "%"
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if suffix == "%" {
                    Text("\(Int(value * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                } else {
                    Text(String(format: "%.1f%@", value, suffix))
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                }
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.2))
                    
                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * CGFloat(suffix == "%" ? value : (value - 35.0) / 3.0))
                }
            }
            .frame(height: 8)
        }
    }
}


// MARK: - OPTION 2: TRUTH SWIPE GAME
struct TruthSwipeGameView: View {
    let stage: LifeStage
    
    @State private var deck: [GameMythCard] = []
    @State private var currentIndex: Int = 0
    @State private var score: Int = 0
    @State private var gameFinished = false
    @State private var showConfetti = false
    @State private var swipedDirection: SwipeDirection? = nil
    
    enum SwipeDirection {
        case left, right
    }
    
    struct GameMythCard: Identifiable {
        let id = UUID()
        let myth: String
        let fact: String
        let answer: Bool // true for Fact, false for Myth
        var isAnswered: Bool = false
    }
    
    // Custom set of myths to test facts
    private static func loadDeck(for stage: LifeStage) -> [GameMythCard] {
        switch stage {
        case .prePuberty:
            return [
                GameMythCard(myth: "Hormones change only after your first period starts.", fact: "False! Hormonal changes begin active development inside your body years before the first period.", answer: false),
                GameMythCard(myth: "Your first period will arrive exactly on its expected date.", fact: "False! Early cycles are irregular and normal during growth.", answer: false),
                GameMythCard(myth: "Growing pains or emotional sensitivity are completely normal during pre-puberty.", fact: "True! Hormonal prep steps affect growing bones and emotional sensitivities.", answer: true)
            ]
        case .puberty:
            return [
                GameMythCard(myth: "You can fully lose a tampon inside your body.", fact: "False! The cervix is too small to let a tampon pass into the womb.", answer: false),
                GameMythCard(myth: "Exercise during your period helps reduce cramps.", fact: "True! Light movement releases endorphins, acting as natural painkillers.", answer: true),
                GameMythCard(myth: "Having irregular periods in the first 2 years is healthy & normal.", fact: "True! Your hypothalamic-pituitary axis takes time to mature.", answer: true)
            ]
        case .reproductive:
            return [
                GameMythCard(myth: "A normal menstrual cycle must be exactly 28 days.", fact: "False! A normal cycle can range between 21 to 35 days.", answer: false),
                GameMythCard(myth: "High stress can delay or alter your cycle timing.", fact: "True! Stress triggers cortisol, which inhibits reproductive hormones.", answer: true),
                GameMythCard(myth: "It is impossible to get pregnant during your period.", fact: "False! Sperm can live inside for up to 5 days, making overlap possible.", answer: false)
            ]
        case .perimenopause:
            return [
                GameMythCard(myth: "Hot flashes only happen after periods completely stop.", fact: "False! They frequently begin during perimenopause due to changing estrogen.", answer: false),
                GameMythCard(myth: "You can still get pregnant during perimenopause.", fact: "True! You still ovulate occasionally until menopause is fully confirmed.", answer: true),
                GameMythCard(myth: "Irregular cycles are a hallmark indicator of perimenopause.", fact: "True! Gaps between cycles fluctuate greatly during this phase.", answer: true)
            ]
        case .menopause:
            return [
                GameMythCard(myth: "Menopause is officially reached after 12 months without a period.", fact: "True! This milestone marks the formal completion of the menopause shift.", answer: true),
                GameMythCard(myth: "All menopausal symptoms instantly vanish after periods stop.", fact: "False! Hormones continue to adjust, and symptoms can persist.", answer: false)
            ]
        case .postMenopause:
            return [
                GameMythCard(myth: "Any bleeding after menopause is healthy & normal.", fact: "False! Postmenopausal bleeding must always be clinically checked.", answer: false),
                GameMythCard(myth: "Protecting bone health is vital after menopause due to lower estrogen.", fact: "True! Lower estrogen speeds up bone density loss.", answer: true)
            ]
        }
    }
    
    var body: some View {
        ZStack {
            if gameFinished {
                // Game Finished View
                VStack(spacing: 24) {
                    Image(systemName: "sparkles.badge.ellipsis")
                        .font(.system(size: 60))
                        .foregroundColor(.lumaPinkBubble)
                    
                    Text("Game Completed!")
                        .font(.title2.bold())
                        .foregroundColor(.lumaDarkGray)
                    
                    Text("You got \(score) out of \(deck.count) statements correct!")
                        .font(.subheadline)
                        .foregroundColor(.lumaMidGray)
                    
                    Button {
                        restartGame()
                    } label: {
                        Text("Play Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.lumaPinkBubble)
                            .clipShape(Capsule())
                    }
                }
                .padding()
            } else if !deck.isEmpty {
                VStack(spacing: 20) {
                    // Score
                    HStack {
                        Text("Card \(currentIndex + 1) of \(deck.count)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.lumaMidGray)
                        Spacer()
                        Text("Score: \(score)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.lumaPinkBubble)
                    }
                    .padding(.horizontal, 30)
                    
                    // Card Stack
                    ZStack {
                        ForEach(deck.indices, id: \.self) { idx in
                            if idx >= currentIndex {
                                let card = deck[idx]
                                SwipeCardView(card: card) { chosenAnswer in
                                    handleAnswer(chosenAnswer, index: idx)
                                }
                                .zIndex(Double(deck.count - idx))
                                .offset(y: idx == currentIndex ? 0 : 8)
                                .scaleEffect(idx == currentIndex ? 1.0 : 0.96)
                                .opacity(idx == currentIndex ? 1.0 : 0.8)
                                .disabled(idx != currentIndex)
                            }
                        }
                    }
                    .frame(height: 320)
                    .padding(.horizontal, 30)
                    
                    // Controls
                    HStack(spacing: 40) {
                        Button {
                            withAnimation { handleAnswer(false, index: currentIndex) }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.orange)
                                Text("MYTH")
                                    .font(.caption2.bold())
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        Button {
                            withAnimation { handleAnswer(true, index: currentIndex) }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                                Text("FACT")
                                    .font(.caption2.bold())
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            
            if showConfetti {
                ConfettiBurstView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            restartGame()
        }
    }
    
    private func handleAnswer(_ isFact: Bool, index: Int) {
        guard index == currentIndex else { return }
        
        let correct = deck[index].answer == isFact
        if correct {
            score += 1
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showConfetti = false
            }
        }
        
        withAnimation {
            currentIndex += 1
            if currentIndex >= deck.count {
                gameFinished = true
            }
        }
    }
    
    private func restartGame() {
        deck = Self.loadDeck(for: stage)
        currentIndex = 0
        score = 0
        gameFinished = false
        showConfetti = false
    }
}

struct SwipeCardView: View {
    let card: TruthSwipeGameView.GameMythCard
    let action: (Bool) -> Void
    
    @State private var offset = CGSize.zero
    @State private var flipped = false
    
    var body: some View {
        ZStack {
            if !flipped {
                // Front: The Statement
                VStack(spacing: 20) {
                    Text("Fact or Myth?")
                        .font(.caption.bold())
                        .foregroundColor(.lumaPinkBubble)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.lumaPinkLight.opacity(0.3))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Text(card.myth)
                        .font(.body)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.lumaDarkGray)
                        .padding()
                    
                    Spacer()
                    
                    Text("Swipe Left for Myth 👈  |  👉 Right for Fact")
                        .font(.caption2)
                        .foregroundColor(.lumaMidGray)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.lumaPinkLight.opacity(0.5), lineWidth: 2)
                )
            }
        }
        .offset(offset)
        .rotationEffect(.degrees(Double(offset.width / 15)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    let width = gesture.translation.width
                    if width > 100 {
                        // Swiped Right (FACT)
                        withAnimation(.spring()) {
                            offset = CGSize(width: 500, height: 0)
                        }
                        action(true)
                    } else if width < -100 {
                        // Swiped Left (MYTH)
                        withAnimation(.spring()) {
                            offset = CGSize(width: -500, height: 0)
                        }
                        action(false)
                    } else {
                        // Return to center
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                }
        )
    }
}


// MARK: - OPTION 3: CARE MATCHER GAME
struct CareMatcherGameView: View {
    let stage: LifeStage
    
    struct MatchItem: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let details: String
    }
    
    @State private var symptoms: [MatchItem] = []
    @State private var remedies: [MatchItem] = []
    
    @State private var selectedSymptom: MatchItem?
    @State private var selectedRemedy: MatchItem?
    
    @State private var matches: [UUID: UUID] = [:] // Map symptom.id -> remedy.id
    @State private var feedbackText: String = "Match each symptom with its corresponding best care habit!"
    @State private var gameCompleted = false
    @State private var showConfetti = false
    
    private static func loadPairings(for stage: LifeStage) -> [(symptom: String, remedy: String, details: String)] {
        switch stage {
        case .prePuberty:
            return [
                ("Breast tenderness", "Warm Compress", "Applying gentle heat relieves growing tissue discomfort."),
                ("Body Odor changes", "Daily Hygiene", "Washing daily helps maintain freshness during hormone changes."),
                ("Acne flare-ups", "Gentle Cleanser", "Washing with mild cleansers keeps pores clear without drying out skin.")
            ]
        case .puberty:
            return [
                ("Menstrual Cramps", "Heating Pad", "Heat relaxes uterine contractions, significantly easing pain."),
                ("Fatigue / Tiredness", "Iron-rich Foods", "Replenishes natural iron lost during period flow."),
                ("Acne / Breakouts", "Gentle Hydration", "Drinking plenty of water and applying light moisturizer regulates sebum.")
            ]
        case .reproductive:
            return [
                ("Heavy Cramping", "Warm Ginger Tea", "Ginger reduces prostaglandins that induce cycle cramps."),
                ("Cycle Delays (Stress)", "Yoga / Meditation", "Lowers cortisol, helping cycles regulate naturally."),
                ("Bloating / Water Retention", "Reduce Sodium", "Lowering salt intake eases periodic bloating.")
            ]
        case .perimenopause:
            return [
                ("Hot Flashes", "Layered Clothing", "Helps cool down rapidly during temperature spikes."),
                ("Insomnia / Sleep Issues", "Cool Bedroom Temp", "Cool environment counters nocturnal hot flashes."),
                ("Irregular Cycles", "Cycle Tracking", "Helps forecast erratic cycles and build confidence.")
            ]
        case .menopause:
            return [
                ("Night Sweats", "Bamboo Sheets", "Bamboo fiber wicks moisture, keeping skin dry."),
                ("Joint Stiffness", "Low-impact Exercise", "Gentle movement lubricates joints and maintains muscle."),
                ("Dry Skin", "Hyaluronic Acid", "Counters lower estrogen collagen loss by boosting surface hydration.")
            ]
        case .postMenopause:
            return [
                ("Bone Density Drop", "Calcium & Vit D", "Essential combinations to support post-menopausal bones."),
                ("Cardiovascular health", "Aerobic Movement", "Maintains healthy blood vessels and heart strength."),
                ("Dry Eyes / Tissues", "Omega-3 Oils", "Healthy fats assist natural surface moisture levels.")
            ]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(feedbackText)
                    .font(.subheadline)
                    .foregroundColor(.lumaDarkGray)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.lumaPinkLight.opacity(0.2))
                    .cornerRadius(14)
                    .padding(.horizontal)
                
                if gameCompleted {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        
                        Text("Excellent Matching!")
                            .font(.headline)
                            .foregroundColor(.lumaDarkGray)
                        
                        Button {
                            setupGame()
                        } label: {
                            Text("Play Again")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.lumaPinkBubble)
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                } else {
                    HStack(alignment: .top, spacing: 20) {
                        // Symptoms Column
                        VStack(spacing: 12) {
                            Text("Symptom")
                                .font(.caption.bold())
                                .foregroundColor(.lumaMidGray)
                            
                            ForEach(symptoms) { item in
                                let isMatched = matches.keys.contains(item.id)
                                let isSelected = selectedSymptom == item
                                
                                Button {
                                    if !isMatched {
                                        selectedSymptom = item
                                        checkMatch()
                                    }
                                } label: {
                                    Text(item.name)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(isMatched ? Color.green.opacity(0.1) : (isSelected ? Color.lumaPinkLight : Color.white))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isMatched ? Color.green : (isSelected ? Color.lumaPinkBubble : Color.lumaPinkLight.opacity(0.4)), lineWidth: 2)
                                        )
                                }
                                .foregroundColor(.lumaDarkGray)
                                .disabled(isMatched)
                            }
                        }
                        
                        // Remedies Column
                        VStack(spacing: 12) {
                            Text("Best Care Action")
                                .font(.caption.bold())
                                .foregroundColor(.lumaMidGray)
                            
                            ForEach(remedies) { item in
                                let isMatched = matches.values.contains(item.id)
                                let isSelected = selectedRemedy == item
                                
                                Button {
                                    if !isMatched {
                                        selectedRemedy = item
                                        checkMatch()
                                    }
                                } label: {
                                    Text(item.name)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(isMatched ? Color.green.opacity(0.1) : (isSelected ? Color.lumaPinkLight : Color.white))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isMatched ? Color.green : (isSelected ? Color.lumaPinkBubble : Color.lumaPinkLight.opacity(0.4)), lineWidth: 2)
                                        )
                                }
                                .foregroundColor(.lumaDarkGray)
                                .disabled(isMatched)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            setupGame()
        }
    }
    
    private func setupGame() {
        let pairings = Self.loadPairings(for: stage)
        
        let items = pairings.map { MatchItem(name: $0.symptom, details: $0.details) }
        let remedyItems = pairings.map { MatchItem(name: $0.remedy, details: $0.details) }
        
        symptoms = items.shuffled()
        remedies = remedyItems.shuffled()
        matches.removeAll()
        selectedSymptom = nil
        selectedRemedy = nil
        gameCompleted = false
        feedbackText = "Match each symptom with its corresponding best care habit!"
    }
    
    private func checkMatch() {
        guard let sym = selectedSymptom, let rem = selectedRemedy else { return }
        
        if sym.details == rem.details {
            // Correct match
            matches[sym.id] = rem.id
            feedbackText = "Correct! \(sym.name) + \(rem.name): \(sym.details)"
            selectedSymptom = nil
            selectedRemedy = nil
            
            if matches.count == symptoms.count {
                gameCompleted = true
            }
        } else {
            // Incorrect match
            feedbackText = "Not quite! Try another remedy for \(sym.name)."
            selectedRemedy = nil
        }
    }
}
