import SwiftUI
import SwiftData

struct SymptomTrackerView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss
  
  @AppStorage("selectedStage") private var savedStageRaw: String = LifeStage.reproductive.rawValue
  @AppStorage("hideGlobalFAB") private var hideGlobalFAB: Bool = false
  
  private var currentStage: LifeStage {
    LifeStage(rawValue: savedStageRaw) ?? .reproductive
  }
  
  @State private var mood: String = ""
  @State private var flow: String = ""
  @State private var painLevel: Double = 0
  @State private var acneLevel: Double = 0
  @State private var hotFlashLevel: Double = 0
  @State private var energyLevel: Double = 5
  
  var body: some View {
    ZStack {
      LumaBackground()
      
      ScrollView(showsIndicators: false) {
        VStack(spacing: 24) {
          stageHeader
            .padding(.horizontal)
          
          VStack(spacing: 32) {
            stageSpecificSymptoms
            energySection
            moodSection
          }
          .padding(.vertical, 8)
          
          saveButton
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding(.vertical)
      }
    }
    .navigationTitle("Track Today's Health")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar(.hidden, for: .tabBar)
    .onAppear { hideGlobalFAB = true }
    .onDisappear { hideGlobalFAB = false }
  }
}

// MARK: - Components
extension SymptomTrackerView {
  var stageHeader: some View {
    VStack(spacing: 12) {
      Image(currentStage.imageName)
        .resizable()
        .scaledToFit()
        .frame(height: 120)
      
      Text(currentStage.title)
        .font(.title2.bold())
      
      Text(currentStage.description)
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .liquidGlass(cornerRadius: 24)
  }
  
  var moodSection: some View {
    trackerStringRow(
      title: "Mood",
      options: [
        ("Sad", "face.dashed"),
        ("Angry", "bolt.fill"),
        ("Happy", "sun.max.fill"),
        ("Depressed", "tornado"),
        ("Stressed", "lightbulb.fill")
      ],
      selection: $mood
    )
  }
  
  var energySection: some View {
    trackerRow(
      title: "Energy Level",
      options: [
        ("Low", "battery.25", 2),
        ("Moderate", "battery.50", 5),
        ("High", "battery.100", 8)
      ],
      selection: $energyLevel
    )
  }
  
  @ViewBuilder
  var stageSpecificSymptoms: some View {
    switch currentStage {
    case .prePuberty:
      trackerRow(title: "General Comfort", options: painOptions, selection: $painLevel)
      
    case .puberty:
      trackerRow(title: "Body Discomfort", options: painOptions, selection: $painLevel)
      trackerRow(title: "Skin Changes / Acne", options: [
        ("Clear", "face.smiling", 0),
        ("Mild", "sparkles", 3),
        ("Moderate", "circle.grid.2x2", 6),
        ("Severe", "circle.grid.3x3.fill", 9)
      ], selection: $acneLevel)
      
    case .reproductive:
      trackerStringRow(title: "Period Flow", options: [
        ("Slight", "drop"),
        ("Spotting", "sparkles"),
        ("Moderate", "drop.halffull"),
        ("Heavy", "drop.fill")
      ], selection: $flow)
      trackerRow(title: "Cramps", options: painOptions, selection: $painLevel)
      
    case .perimenopause:
      trackerRow(title: "Hot Flashes", options: [
        ("None", "thermometer.snowflake", 0),
        ("Mild", "thermometer.sun", 3),
        ("Moderate", "thermometer.sun.fill", 6),
        ("Severe", "flame.fill", 9)
      ], selection: $hotFlashLevel)
      trackerRow(title: "Joint Pain", options: painOptions, selection: $painLevel)
      
    case .menopause:
      trackerRow(title: "Hot Flashes", options: [
        ("None", "thermometer.snowflake", 0),
        ("Mild", "thermometer.sun", 3),
        ("Moderate", "thermometer.sun.fill", 6),
        ("Severe", "flame.fill", 9)
      ], selection: $hotFlashLevel)
      
    case .postMenopause:
      trackerRow(title: "Joint / Body Comfort", options: painOptions, selection: $painLevel)
    }
  }
  
  var painOptions: [(String, String, Double)] {
    [
      ("Normal", "circle.circle", 0),
      ("Mild", "circle.dashed.inset.filled", 3),
      ("Moderate", "circle.grid.cross", 6),
      ("Extreme", "circle.circle.fill", 10)
    ]
  }
  
  var saveButton: some View {
    Button {
      let log = SymptomLog(
        mood: mood,
        flow: flow.isEmpty ? nil : flow,
        painLevel: painLevel,
        energyLevel: energyLevel,
        stress: 0,
        sleepHours: 7,
        lifeStage: currentStage
      )
      modelContext.insert(log)
      dismiss()
    } label: {
      Text("Save Today’s Log")
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(stageAccentColor)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: stageAccentColor.opacity(0.25), radius: 8, y: 4)
    }
  }
}

// MARK: - Reusable Trackers
extension SymptomTrackerView {
  
  private var stageAccentColor: Color {
    Color(red: 0.93, green: 0.55, blue: 0.70)
  }
  
  func trackerRow(title: String, options: [(title: String, icon: String, value: Double)], selection: Binding<Double>) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(title)
        .font(.headline.bold())
        .padding(.horizontal, 20)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          Spacer().frame(width: 8)
          ForEach(options, id: \.title) { option in
            TrackerOptionCard(
              title: option.title,
              icon: option.icon,
              isSelected: selection.wrappedValue == option.value,
              tintColor: stageAccentColor,
              action: { selection.wrappedValue = option.value }
            )
          }
          Spacer().frame(width: 8)
        }
      }
    }
  }
  
  func trackerStringRow(title: String, options: [(title: String, icon: String)], selection: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(title)
        .font(.headline.bold())
        .padding(.horizontal, 20)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          Spacer().frame(width: 8)
          ForEach(options, id: \.title) { option in
            TrackerOptionCard(
              title: option.title,
              icon: option.icon,
              isSelected: selection.wrappedValue == option.title,
              tintColor: stageAccentColor,
              action: { selection.wrappedValue = option.title }
            )
          }
          Spacer().frame(width: 8)
        }
      }
    }
  }
}

struct TrackerOptionCard: View {
  let title: String
  let icon: String
  let isSelected: Bool
  let tintColor: Color
  let action: () -> Void
  
  var body: some View {
    Button(action: {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
        action()
      }
    }) {
      VStack(spacing: 14) {
        Image(systemName: icon)
          .font(.system(size: 32, weight: .regular))
        Text(title)
          .font(.subheadline)
      }
      .foregroundColor(tintColor)
      .frame(width: 100, height: 110)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(isSelected ? tintColor.opacity(0.15) : Color(.secondarySystemBackground))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(isSelected ? tintColor : Color.clear, lineWidth: 2)
      )
    }
    .buttonStyle(.plain)
  }
}
