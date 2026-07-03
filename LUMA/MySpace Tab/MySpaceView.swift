

import SwiftUI
import SwiftData
import FoundationModels

// MARK: - Pastel Color Palette
extension Color {
  // Standard system colors match the RevealView pastel look when used with .opacity(0.15)
  static let pastelRose   = Color.pink
  static let pastelLavender = Color.purple
  static let pastelPeach  = Color.orange
  static let pastelMint   = Color.green
  static let pastelBlush  = Color.red
  static let pastelSky   = Color.blue
  
  // Text colors
  static let feminineText   = Color.primary
  static let feminineSubtext  = Color.secondary
  
  // Accent
  static let feminineAccent  = Color.pink
  static let feminineLilac   = Color.purple
}

@available(iOS 26.0, *)
struct MySpaceView: View {
  
  @Query(sort: \SymptomLog.date, order: .reverse) private var logs: [SymptomLog]
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
    currentStage.themeColor
  }
  
  @AppStorage("user_name") private var userName: String = ""
  
  private var greetingText: String {
    let hour = Calendar.current.component(.hour, from: Date())
    let name = userName.isEmpty ? "Sunshine": userName
    let afternoonName = userName.isEmpty ? "Beautiful": userName
    let eveningName = userName.isEmpty ? "Love": userName
    let nightName = userName.isEmpty ? "Dear": userName
    
    switch hour {
    case 5..<12: return userName.isEmpty ? "Good morning, \(name)": "Good morning, \(name)"
    case 12..<17: return userName.isEmpty ? "Good afternoon, \(afternoonName)": "Good afternoon, \(name)"
    case 17..<21: return userName.isEmpty ? "Good evening, \(eveningName)": "Good evening, \(name)"
    default: return "Sweet dreams, \(nightName)"
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
          .padding(.bottom, 130)
    }
    .background {
      LumaBackground()
    }
    .navigationTitle("MySpace")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(destination: ProfileView()) {
            Image(systemName: UserDefaults.standard.string(forKey: "user_avatar") ?? "person.crop.circle.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 26, height: 26)
              .foregroundStyle(Color.lumaPinkBubble)
          }
        }
      }
      
      .task {
        await insightManager.generateInsight(from: logs)
      }

      
      .sheet(item: $selectedStageForSheet) { stage in
        LifeStageDetailView(stage: stage)
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
      
      .navigationDestination(isPresented: $showTracker) {
        SymptomTrackerView()
      }
      .sheet(isPresented: $showStoryPlayer) {
        StoryPlayerView(stage: currentStage)
      }
      .navigationDestination(isPresented: $showBodyMap) {
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
          .fixedSize(horizontal: false, vertical: true)
        
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
    .liquidGlass(cornerRadius: 22)
  }
  
  // MARK: Journey
  var journeySection: some View {
    VStack(alignment: .leading, spacing: 12) {
      MySpaceSectionHeader(title: "Where I Am", icon: "leaf.fill")
      
      LifeStageJourneyView(currentStage: currentStage)
        .padding(16)
        .liquidGlass(cornerRadius: 22)
    }
  }
  
  // MARK: Weekly Insight
  var bodyInsightSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      MySpaceSectionHeader(title: "Weekly Body Insight", icon: "sparkles")
      
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
              Text("No insight yet")
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
        .liquidGlass(cornerRadius: 22)
        
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
      MySpaceSectionHeader(title: "Discover", icon: "book.pages.fill")
      
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
          .liquidGlass(cornerRadius: 22)
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
          .liquidGlass(cornerRadius: 22)
        }
      }
    }
  }
  
  // MARK: Stage Risk
  var stageRiskSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      MySpaceSectionHeader(title: "Things to Watch", icon: "stethoscope")
      
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
      MySpaceSectionHeader(title: "Quick Actions", icon: "bolt.fill")
      
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
      
      Text("Many changes you feel are common. You're not broken — you're evolving. ")
        .font(.subheadline)
        .foregroundColor(.feminineText)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .liquidGlass(cornerRadius: 22)
    }
  }
}

// MARK: - Section Header
private struct MySpaceSectionHeader: View {
  let title: String
  let icon: String
  
  var body: some View {
    HStack(spacing: 6) {
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
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer(minLength: 0)
    }
    .padding(14)
    .frame(width: 200, height: 200)
    .liquidGlass(cornerRadius: 22)
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
            .fixedSize(horizontal: false, vertical: true)
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(.caption)
          .foregroundColor(.feminineSubtext.opacity(0.5))
      }
      .padding(16)
      .frame(maxWidth: .infinity)
      .liquidGlass(cornerRadius: 20)
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
    guard let index = stages.firstIndex(of: currentStage) else { return Array(stages.prefix(3)) }
    if index == 0 {
      return Array(stages.prefix(3))
    } else if index == stages.count - 1 {
      return Array(stages.suffix(3))
    } else {
      return Array(stages[(index - 1)...(index + 1)])
    }
  }
  
  var body: some View {
    VStack(spacing: 12) {
      HStack(alignment: .top, spacing: 0) {
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
                  .stroke(Color(.systemBackground), lineWidth: 2.5)
                  .frame(width: 22, height: 22)
              }
            }
            .frame(height: 22, alignment: .center)
            
            Text(stage.title)
              .font(.caption2)
              .multilineTextAlignment(.center)
              .foregroundColor(textColor(for: stage))
              .minimumScaleFactor(0.8)
              .fixedSize(horizontal: false, vertical: true)
              .frame(width: 80)
          }
          .frame(width: 80) // Fixed width so lines can stretch between them
          
          if index < visibleStages.count - 1 {
            Capsule()
              .fill(lineColor(for: stage))
              .frame(height: 3)
              .frame(maxWidth: .infinity)
              .offset(y: 9.5)
              .padding(.horizontal, -8) // slight negative padding to touch dots
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
