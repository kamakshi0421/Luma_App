

import SwiftUI
import FoundationModels
import FirebaseAuth

// MARK: - Pastel Color Palette
private extension Color {
    // Standard system colors match the RevealView pastel look when used with .opacity(0.15)
    static let pastelRose     = Color.pink
    static let pastelLavender = Color.purple
    static let pastelPeach    = Color.orange
    static let pastelMint     = Color.green
    static let pastelBlush    = Color.red
    static let pastelSky      = Color.blue
    
    // Text colors
    static let feminineText      = Color.primary
    static let feminineSubtext   = Color.secondary
    
    // Accent
    static let feminineAccent    = Color.pink
    static let feminineLilac     = Color.purple
}

@available(iOS 26.0, *)
struct MySpaceView: View {
    
    @EnvironmentObject var store: SymptomStore
    @Binding var selectedTab: MainTabView.Tab
    
    @State private var selectedCondition: StageCondition? = nil
    @StateObject private var insightManager = WeeklyInsightManager()
    
    @State private var selectedStageForSheet: LifeStage?
    @State private var showTracker = false
    @State private var showProfile = false
    @State private var showStoryPlayer = false
    @State private var showBodyMap = false
    @State private var showDailyChallenge = false
    
    @AppStorage("selectedStage")
    private var savedStageRaw: String = LifeStage.reproductive.rawValue
    
    private var currentStage: LifeStage {
        LifeStage(rawValue: savedStageRaw) ?? .reproductive
    }
    
    private var stageAccentColor: Color {
        Color.pink
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning, sunshine ☀️"
        case 12..<17: return "Good afternoon, beautiful 🌸"
        case 17..<21: return "Good evening, love 🌙"
        default: return "Sweet dreams, dear 💫"
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 26) {
                        
                        greetingSection
                        heroSection
                        journeySection
                        bodyInsightSection
                        discoverSection
                        stageRiskSection
                        quickActionSection
                        gentleTruthSection
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 50)
        }
        .background {
            LumaBackground()
        }
        .navigationTitle("MySpace")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(colors: [.feminineAccent, .feminineLilac], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    }
                }
            }
            
            .task {
                await insightManager.generateInsight(from: store.logs)
            }
            
            .sheet(isPresented: $showProfile) {
                ProfileView()
                    .environmentObject(store)
            }
            
            .sheet(item: $selectedStageForSheet) { stage in
                LifeStageDetailView(stage: stage)
                    .presentationDetents([.large])
            }
            
            .navigationDestination(isPresented: $showTracker) {
                SymptomTrackerView()
            }
            .sheet(isPresented: $showStoryPlayer) {
                StoryPlayerView(stage: currentStage)
            }
            .sheet(isPresented: $showBodyMap) {
                BodyMapView()
            }
            .sheet(isPresented: $showDailyChallenge) {
                DailyChallengeView(stage: currentStage)
            }
    }
}

// MARK: - Sections
@available(iOS 26.0, *)
private extension MySpaceView {
    
    // MARK: Greeting
    var greetingSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(greetingText)
                .font(.title2.weight(.semibold))
                .foregroundColor(.feminineText)
            
            Text("Here's what your body may need today.")
                .font(.subheadline)
                .foregroundColor(.feminineSubtext)
        }
    }
    
    // MARK: Hero Card
    var heroSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text("My current phase")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(stageAccentColor)
                    .textCase(.uppercase)
                    .tracking(0.8)
                
                Text(currentStage.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.feminineText)
                
                Text(currentStage.description)
                    .font(.subheadline)
                    .foregroundColor(.feminineSubtext)
                    .lineLimit(3)
                
                Button {
                    selectedStageForSheet = currentStage
                } label: {
                    Text("Learn more →")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 9)
                        .background(stageAccentColor)
                        .clipShape(Capsule())
                }
                .padding(.top, 2)
            }
            
            Spacer()
            
            Image(currentStage.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(stageAccentColor.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(stageAccentColor.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: stageAccentColor.opacity(0.1), radius: 12, y: 6)
    }
    
    // MARK: Journey
    var journeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MySpaceSectionHeader(title: "Where I Am", emoji: "🌿")
            
            LifeStageJourneyView(currentStage: currentStage)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.pastelLavender.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.pastelLavender.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: Color.feminineLilac.opacity(0.06), radius: 8, y: 4)
        }
    }
    
    // MARK: Weekly Insight
    var bodyInsightSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MySpaceSectionHeader(title: "Weekly Body Insight", emoji: "✨")
            
            ZStack(alignment: .topTrailing) {
                Group {
                    if insightManager.isLoading {
                        HStack(spacing: 10) {
                            ProgressView()
                                .tint(.feminineAccent)
                            Text("Analysing your week...")
                                .font(.caption)
                                .foregroundColor(.feminineSubtext)
                        }
                    } else if insightManager.hasEnoughData {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(insightManager.message)
                                .font(.subheadline)
                                .foregroundColor(.feminineText)
                            Text("AI-generated from this week's logs")
                                .font(.caption)
                                .foregroundColor(.feminineSubtext)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("No insight yet 🌷")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.feminineText)
                            Text("Track at least 3 symptoms this week to unlock personalised insights.")
                                .font(.caption)
                                .foregroundColor(.feminineSubtext)
                        }
                    }
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.pastelSky.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.pastelSky.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: Color.pastelSky.opacity(0.08), radius: 10, y: 5)
                
                if insightManager.justUnlocked {
                    InsightReadyBadge()
                        .offset(x: -12, y: -12)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    // MARK: Discover (Story + Challenge)
    var discoverSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MySpaceSectionHeader(title: "Discover", emoji: "🦋")
            
            HStack(spacing: 14) {
                // Interactive Story
                Button { showStoryPlayer = true } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "book.fill")
                            .font(.title2)
                            .foregroundColor(.feminineLilac)
                        
                        Spacer()
                        
                        Text("Story")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.feminineText)
                        
                        Text(currentStage.title)
                            .font(.caption2)
                            .foregroundColor(.feminineSubtext)
                            .lineLimit(1)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.pastelLavender.opacity(0.15))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.pastelLavender.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color.pastelLavender.opacity(0.08), radius: 8, y: 4)
                }
                
                // Daily Challenge
                Button { showDailyChallenge = true } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.title2)
                            .foregroundColor(.feminineAccent)
                        
                        Spacer()
                        
                        Text("Challenge")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.feminineText)
                        
                        Text("Today's task")
                            .font(.caption2)
                            .foregroundColor(.feminineSubtext)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.pastelPeach.opacity(0.15))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.pastelPeach.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color.pastelPeach.opacity(0.08), radius: 8, y: 4)
                }
            }
        }
    }
    
    // MARK: Stage Risk
    var stageRiskSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MySpaceSectionHeader(title: "Things to Watch", emoji: "🩺")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(currentStage.content.conditions) { condition in
                        Button {
                            selectedCondition = condition
                        } label: {
                            StageRiskCard(condition: condition)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 2)
            }
        }
        .sheet(item: $selectedCondition) { condition in
            ConditionDetailSheet(condition: condition)
                .presentationDetents([.large])
                .presentationCornerRadius(28)
        }
    }
    
    // MARK: Quick Actions
    var quickActionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            MySpaceSectionHeader(title: "Quick Actions", emoji: "💜")
            
            PastelActionCard(
                title: "Track how your body feels",
                subtitle: "Log symptoms for weekly insights",
                icon: "heart.text.clipboard",
                tint: .pastelRose,
                iconColor: .feminineAccent
            ) { showTracker = true }
            
            PastelActionCard(
                title: "Body Map",
                subtitle: "Explore symptoms by body area",
                icon: "figure.mind.and.body",
                tint: .pastelMint,
                iconColor: Color(red: 0.40, green: 0.72, blue: 0.60)
            ) { showBodyMap = true }
            
            PastelActionCard(
                title: "Is This Normal?",
                subtitle: "Get gentle reassurance",
                icon: "questionmark.bubble",
                tint: .pastelSky,
                iconColor: Color(red: 0.45, green: 0.60, blue: 0.82)
            ) { selectedTab = .Reveal }
        }
    }
    
    // MARK: Gentle Truth
    var gentleTruthSection: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.feminineAccent.opacity(0.7))
                Text("A Moment to Pause")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.feminineAccent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
            
            Text("Many changes you feel are common. You're not broken — you're evolving. 🌱")
                .font(.subheadline)
                .foregroundColor(.feminineText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.pastelMint.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.pastelMint.opacity(0.35), lineWidth: 1)
                )
        }
    }
}

// MARK: - Section Header
private struct MySpaceSectionHeader: View {
    let title: String
    let emoji: String
    
    var body: some View {
        HStack(spacing: 6) {
            Text(emoji)
                .font(.subheadline)
            Text(title)
                .font(.headline)
                .foregroundColor(.feminineText)
        }
    }
}

// MARK: - Pastel Feminine Background
struct PastelFeminineBackground: View {
    var body: some View {
        ZStack {
            // Base soft white
            Color(red: 0.99, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            // Soft rose radial at top
            RadialGradient(
                colors: [
                    Color.pastelRose.opacity(0.1),
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            // Subtle lavender glow at bottom-right
            RadialGradient(
                colors: [
                    Color.pastelLavender.opacity(0.1),
                    Color.clear
                ],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 350
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Stage Risk Card (Redesigned)
struct StageRiskCard: View {
    let condition: StageCondition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(condition.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 90)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            Text(condition.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.feminineText)
                .lineLimit(1)
            
            Text(condition.shortDescription)
                .font(.caption)
                .foregroundColor(.feminineSubtext)
                .lineLimit(2)
                .frame(height: 34, alignment: .top)
            
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(width: 200, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.pastelRose.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.pastelRose.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: Color.pastelRose.opacity(0.06), radius: 8, y: 4)
    }
}

// MARK: - Pastel Action Card
struct PastelActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let tint: Color
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.5))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.feminineText)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.feminineSubtext)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.feminineSubtext.opacity(0.5))
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(tint.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(tint.opacity(0.35), lineWidth: 1)
            )
            .shadow(color: tint.opacity(0.05), radius: 6, y: 3)
        }
    }
}

// MARK: - Life Stage Journey
struct LifeStageJourneyView: View {
    let currentStage: LifeStage
    
    private let stages: [LifeStage] = [
        .prePuberty, .puberty, .reproductive, .perimenopause, .menopause, .postMenopause
    ]
    
    var visibleStages: [LifeStage] {
        guard let index = stages.firstIndex(of: currentStage) else { return stages }
        let lower = max(index - 1, 0)
        let upper = min(index + 1, stages.count - 1)
        return Array(stages[lower...upper])
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                ForEach(visibleStages.indices, id: \.self) { index in
                    let stage = visibleStages[index]
                    
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(circleColor(for: stage))
                                .frame(
                                    width: stage == currentStage ? 22 : 16,
                                    height: stage == currentStage ? 22 : 16
                                )
                                .shadow(
                                    color: stage == currentStage
                                    ? Color.feminineAccent.opacity(0.3)
                                    : .clear,
                                    radius: 6,
                                    y: 3
                                )
                            
                            if stage == currentStage {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2.5)
                                    .frame(width: 22, height: 22)
                            }
                        }
                        
                        Text(stage.title)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(textColor(for: stage))
                            .frame(width: 80)
                    }
                    .frame(maxWidth: .infinity)
                    
                    if index < visibleStages.count - 1 {
                        Capsule()
                            .fill(lineColor(for: stage))
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                            .offset(y: -14)
                    }
                }
            }
        }
    }
    
    private func circleColor(for stage: LifeStage) -> Color {
        if stage == currentStage {
            return .feminineAccent
        } else if stage.order < currentStage.order {
            return Color.pastelMint.opacity(0.9)
        } else {
            return Color.pastelLavender.opacity(0.5)
        }
    }
    
    private func textColor(for stage: LifeStage) -> Color {
        stage == currentStage ? .feminineAccent : .feminineSubtext
    }
    
    private func lineColor(for stage: LifeStage) -> Color {
        stage.order < currentStage.order
        ? Color.pastelMint.opacity(0.7)
        : Color.pastelLavender.opacity(0.4)
    }
}
