import SwiftUI
import FoundationModels
import FirebaseAuth

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
    
    var body: some View {
        ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        quickActionGrid
                        
                        bodyInsightSection
                        
                        heroSection
                        
                        editorialCardsSection
                        
                        journeySection
                        
                        stageRiskSection
                        
                        gentleTruthSection
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 100) 
                }
            }
            .navigationTitle("Aangan")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .foregroundColor(.lumaDarkGray)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    GlobalInfoButton(tab: .herSpace)
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

@available(iOS 26.0, *)
private extension MySpaceView {
    
    var quickActionGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                NativeGridCard(
                    title: "Log Symptoms",
                    icon: "plus.circle.fill",
                    color: .lumaPinkBubble
                ) { showTracker = true }
                
                NativeGridCard(
                    title: "Body Map",
                    icon: "figure.walk",
                    color: .purple
                ) { showBodyMap = true }
                
                NativeGridCard(
                    title: "Is This Normal?",
                    icon: "questionmark.circle.fill",
                    color: .blue
                ) { selectedTab = .Reveal }
                
                NativeGridCard(
                    title: "My Profile",
                    icon: "person.crop.circle.fill",
                    color: .orange
                ) { showProfile = true }
            }
        }
    }
    
    var editorialCardsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Discover")
                .font(.headline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                
            VStack(spacing: 16) {
                Button { showDailyChallenge = true } label: {
                    EditorialCard(
                        tagline: "DAILY CHALLENGE",
                        title: "Complete your interactive task today",
                        gradient: [Color.orange, Color.red]
                    )
                }
                
                Button { showStoryPlayer = true } label: {
                    EditorialCard(
                        tagline: "INTERACTIVE STORY",
                        title: "Experience the \(currentStage.title) journey",
                        gradient: [Color.purple, Color.blue]
                    )
                }
            }
        }
    }
    
    var heroSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("My Stage")
                .font(.headline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                
            HStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(currentStage.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(currentStage.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    
                    Button {
                        selectedStageForSheet = currentStage
                    } label: {
                        Text("Learn More")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.lumaPinkBubble)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 4)
                }
                
                Spacer()
                
                Image(currentStage.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
            }
            .padding(20)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
        }
    }
    
    var journeySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("My Journey")
                .font(.headline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            LifeStageJourneyView(currentStage: currentStage)
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
        }
    }
    
    var bodyInsightSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly AI Insight")
                .font(.headline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            ZStack(alignment: .topTrailing) {
                Group {
                    if insightManager.isLoading {
                        HStack(spacing: 10) {
                            ProgressView()
                            Text("Analyzing your week...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } else if insightManager.hasEnoughData {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(insightManager.message)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Text("Based on your recent logs")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("No insight yet 🌷")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.primary)
                            Text("Track at least 3 symptoms this week to unlock insights.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                
                if insightManager.justUnlocked {
                    InsightReadyBadge()
                        .offset(x: -12, y: -12)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    var stageRiskSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Things to watch out for")
                .font(.headline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
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
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
        }
        .sheet(item: $selectedCondition) { condition in
            ConditionDetailSheet(condition: condition)
                .presentationDetents([.large])
                .presentationCornerRadius(28)
        }
    }
    
    var gentleTruthSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("A Moment to Pause")
                .font(.headline)
                .foregroundColor(.lumaPinkBubble)
            
            Text("Many changes you feel are common. You’re not broken — you’re evolving.")
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.lumaPinkBubble.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}

struct NativeGridCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 100)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
        }
    }
}

struct EditorialCard: View {
    let tagline: String
    let title: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tagline)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.85))
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 130)
        .background(
            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: gradient.last!.opacity(0.3), radius: 10, y: 5)
    }
}

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
                .cornerRadius(14)
            
            Text(condition.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(condition.shortDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(height: 34, alignment: .top)
            
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(width: 180, height: 190)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
}

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
                                    ? .lumaPinkBubble.opacity(0.35)
                                    : .clear,
                                    radius: 6,
                                    y: 3
                                )
                            
                            if stage == currentStage {
                                Circle()
                                    .stroke(Color(uiColor: .secondarySystemGroupedBackground), lineWidth: 2)
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
        if stage == currentStage { return .lumaPinkBubble }
        else if stage.order < currentStage.order { return .green.opacity(0.8) }
        else { return .gray.opacity(0.35) }
    }
    
    private func textColor(for stage: LifeStage) -> Color {
        stage == currentStage ? .lumaPinkBubble : .secondary
    }
    
    private func lineColor(for stage: LifeStage) -> Color {
        stage.order < currentStage.order ? .green.opacity(0.6) : .gray.opacity(0.2)
    }
}
