

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
        NavigationStack {
            
            ZStack {
                
                LumaBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        greetingSection
                        dailyChallengeCard
                        storyCard
                        heroSection
                        journeySection
                        bodyInsightSection
                        stageRiskSection
                        quickActionSection
                        gentleTruthSection
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }

            
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
}
@available(iOS 26.0, *)
private extension MySpaceView {
    
    private var stageAccentColor: Color {
            Color(red: 0.93, green: 0.55, blue: 0.70) 
        
    }
    
    var stageGradientColors: [Color] {
        [
            stageAccentColor.opacity(0.18),
            stageAccentColor.opacity(0.08)
        ]
    }
}


@available(iOS 26.0, *)
private extension MySpaceView {
    
    private var greetingSection: some View {
        HStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Good to see you 🌙")
                    .font(.title2.bold())
                    .foregroundColor(.lumaDarkGray)
                
                Text("Here's what your body may need today.")
                    .font(.subheadline)
                    .foregroundColor(.lumaMidGray)
            }
            
            Spacer()
            
            Button {
                showProfile = true
            } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title3)
                    .foregroundColor(.lumaDarkGray)
            }
            
            GlobalInfoButton(tab: .herSpace)
        }
    }
    
    var dailyChallengeCard: some View {
        Button {
            showDailyChallenge = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today's Challenge 🏆")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Complete your daily interactive task!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(colors: [.orange, .red.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(20)
            .shadow(color: .orange.opacity(0.3), radius: 8, y: 4)
        }
    }
    
    var storyCard: some View {
        Button {
            showStoryPlayer = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Live the Story 🎭")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Experience the \(currentStage.title) journey.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(colors: [.purple, .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(20)
            .shadow(color: .purple.opacity(0.3), radius: 8, y: 4)
        }
    }
    
    var heroSection: some View {
        
        HStack(spacing: 18) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("My current phase")
                    .font(.caption)
                    .foregroundColor(stageAccentColor)
                
                Text(currentStage.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(currentStage.description)
                    .font(.subheadline)
                    .foregroundColor(.lumaMidGray)
                    .lineLimit(3)
                
                Button {
                    selectedStageForSheet = currentStage
                } label: {
                    Text("Learn for my stage")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(stageAccentColor)
                        .cornerRadius(18)
                }
            }
            
            Spacer()
            
            Image(currentStage.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 110)
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [
                    stageAccentColor.opacity(0.22),
                    stageAccentColor.opacity(0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(stageAccentColor.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .frame(maxWidth: .infinity, alignment: .leading)
        .shadow(color: stageAccentColor.opacity(0.18), radius: 8, y: 4)
    }
    
    var journeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Where I Am")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
            
            LifeStageJourneyView(currentStage: currentStage)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var bodyInsightSection: some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            Text("My Weekly Body Insight")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
            
            ZStack(alignment: .topTrailing) {
                
                
                Group {
                    
                    if insightManager.isLoading {
                        
                        HStack(spacing: 10) {
                            ProgressView()
                                .tint(.green)
                            
                            Text("Analyzing your week...")
                                .font(.caption)
                                .foregroundColor(.lumaMidGray)
                        }
                        
                    } else if insightManager.hasEnoughData {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(insightManager.message)
                                .font(.subheadline)
                                .foregroundColor(.lumaDarkGray)
                            
                            Text("AI-generated from this week's logs")
                                .font(.caption)
                                .foregroundColor(.lumaMidGray)
                        }
                        
                    } else {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("No insight yet 🌷")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.lumaDarkGray)
                            
                            Text("Track at least 3 symptoms this week to unlock personalized insights.")
                                .font(.caption)
                                .foregroundColor(.lumaMidGray)
                        }
                    }
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(red: 0.94, green: 0.92, blue: 0.98))                 )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color(red: 0.70, green: 0.62, blue: 0.85).opacity(0.35), lineWidth: 1)
                )
                .shadow(
                    color: Color(red: 0.70, green: 0.62, blue: 0.85).opacity(0.12),
                    radius: 10,
                    y: 6
                )
                
               
                if insightManager.justUnlocked {
                    InsightReadyBadge()
                        .offset(x: -12, y: -12)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    var stageRiskSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Conditions to be aware of")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
            
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
            }
        }
        .sheet(item: $selectedCondition) { condition in
            ConditionDetailSheet(condition: condition)
                .presentationDetents([
                    PresentationDetent.large
                ])
                .presentationCornerRadius(28)
        }
    }
    
    var quickActionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
            
            QuickActionCard(
                title: "Track how your body feels",
                subtitle: "Log symptoms for personalized weekly insights",
                icon: "list.bullet"
            ) {
                showTracker = true
            }
            
            QuickActionCard(
                title: "Is This Normal?",
                subtitle: "Get gentle reassurance",
                icon: "questionmark.circle.fill"
            ) {
                selectedTab = .Reveal
            }
            
            QuickActionCard(
                title: "Interactive Body Map",
                subtitle: "Explore changes in your body",
                icon: "figure.walk"
            ) {
                showBodyMap = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var gentleTruthSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("A Moment to Pause")
                .font(.headline)
                .foregroundColor(stageAccentColor)
            
            Text("Many changes you feel are common. You’re not broken — you’re evolving.")
                .font(.subheadline)
                .foregroundColor(.lumaDarkGray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(stageAccentColor.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(stageAccentColor.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: stageAccentColor.opacity(0.15), radius: 8, y: 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                .foregroundColor(.lumaDarkGray)
                .lineLimit(1)
            
           
            Text(condition.shortDescription)
                .font(.caption)
                .foregroundColor(.lumaMidGray)
                .lineLimit(2)
                .frame(height: 34, alignment: .top)
            
            Spacer(minLength: 0)
        }
        .padding()
        .frame(width: 210, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.gray.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.04),
            radius: 6,
            y: 4
        )
    }
}

struct QuickActionCard: View {
    
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                
                
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.18))
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: icon)
                        .foregroundColor(.purple)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.lumaDarkGray)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.lumaMidGray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.4))
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 90)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.purple.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.purple.opacity(0.25), lineWidth: 1)
            )
            .shadow(
                color: Color.purple.opacity(0.10),
                radius: 8,
                y: 4
            )
        }
    }
}

struct LifeStageJourneyView: View {
    
    let currentStage: LifeStage
    
    private let stages: [LifeStage] = [
        .prePuberty,
        .puberty,
        .reproductive,
        .perimenopause,
        .menopause,
        .postMenopause
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
                                    .stroke(Color.white, lineWidth: 2)
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
            return .lumaPinkBubble
        } else if stage.order < currentStage.order {
            return .green.opacity(0.8)
        } else {
            return .gray.opacity(0.35)
        }
    }
    
    private func textColor(for stage: LifeStage) -> Color {
        stage == currentStage ? .lumaPinkBubble : .lumaMidGray
    }
    
    private func lineColor(for stage: LifeStage) -> Color {
        stage.order < currentStage.order
        ? .green.opacity(0.6)
        : .gray.opacity(0.35)
    }
}
