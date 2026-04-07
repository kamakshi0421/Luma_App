import SwiftUI


struct SymptomTrackerView: View {
    
    @EnvironmentObject var store: SymptomStore
    @Environment(\.dismiss) var dismiss
    
   
    @AppStorage("selectedStage") private var savedStageRaw: String = LifeStage.reproductive.rawValue
    
    private var currentStage: LifeStage {
        LifeStage(rawValue: savedStageRaw) ?? .reproductive
    }
    
    @State private var mood: String = "🙂"
    @State private var painLevel: Double = 3
    @State private var acneLevel: Double = 0
    @State private var hotFlashLevel: Double = 0
    @State private var energyLevel: Double = 5
    
    let moods = ["😊", "🙂", "😐", "😔", "😢"]
    
    var body: some View {
        
        ZStack {
            
            
            LinearGradient(
                colors: [
                    stageAccentColor.opacity(0.15),
                    stageAccentColor.opacity(0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    stageHeader
                    moodSection
                    stageSpecificSymptoms
                    energySection
                    saveButton
                    
                }
                .padding()
            }
        }
    }
}

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
                .foregroundColor(stageAccentColor)
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(stageAccentColor.opacity(0.3))
        )
        .shadow(color: stageAccentColor.opacity(0.25), radius: 12, y: 6)
    }
}


extension SymptomTrackerView {
    
    var moodSection: some View {
        pastelCard {
            VStack(alignment: .leading, spacing: 14) {
                
                Text("Mood")
                    .font(.headline)
                
                HStack(spacing: 14) {
                    ForEach(moods, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: 28))
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(mood == emoji ?
                                           stageAccentColor.opacity(0.3) :
                                           Color.white.opacity(0.6))
                                     .shadow(color: stageAccentColor.opacity(0.25), radius: 4, y: 3)
                            )
                            .shadow(color: .pink.opacity(0.15), radius: 4, y: 3)
                            .onTapGesture {
                                mood = emoji
                            }
                    }
                }
            }
        }
    }
}


extension SymptomTrackerView {
    
    @ViewBuilder
    var stageSpecificSymptoms: some View {
        
        switch currentStage {
            
        case .prePuberty:
            pastelCard {
                sliderView(title: "General Comfort", value: $painLevel)
            }
            
        case .puberty:
            pastelCard {
                VStack(spacing: 16) {
                    sliderView(title: "Body Discomfort", value: $painLevel)
                    sliderView(title: "Skin Changes / Acne", value: $acneLevel)
                }
            }
            

        case .reproductive:
            pastelCard {
                sliderView(title: "Cycle Pain / Cramps", value: $painLevel)
            }
            
        case .perimenopause:
            pastelCard {
                VStack(spacing: 16) {
                    sliderView(title: "Hot Flash Intensity", value: $hotFlashLevel)
                    sliderView(title: "Mood Swings", value: $painLevel)
                }
            }
            
        case .menopause:
            pastelCard {
                sliderView(title: "Hot Flash Intensity", value: $hotFlashLevel)
            }
            
        case .postMenopause:
            pastelCard {
                sliderView(title: "Joint / Body Comfort", value: $painLevel)
            }
        }
    }
}


extension SymptomTrackerView {
    
    var energySection: some View {
        pastelCard {
            sliderView(title: "Energy Level", value: $energyLevel)
        }
    }
}


extension SymptomTrackerView {
    
    var saveButton: some View {
        Button {
            
            let log = SymptomLog(
                mood: mood,
                flow: nil,
                painLevel: painLevel,
                energyLevel: energyLevel,
                stress: 0,
                sleepHours: 7,
                lifeStage: currentStage
            )
            
            store.addLog(log)
            dismiss()
            
        } label: {
            Text("Save Today’s Log")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            stageAccentColor,
                            stageAccentColor.opacity(0.7)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(24)
                .shadow(color: stageAccentColor.opacity(0.35), radius: 8, y: 4)
        }
    }}

struct pastelCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white.opacity(0.85))
            )
            .shadow(color: .pink.opacity(0.12), radius: 10, y: 6)
    }
}

extension SymptomTrackerView {
    
    func sliderView(title: String, value: Binding<Double>) -> some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(painDescription(for: value.wrappedValue))
                    .font(.subheadline)
                    .foregroundColor(painColor(for: value.wrappedValue))
            }
            
            Slider(value: value, in: 0...10, step: 1)
                .tint(painColor(for: value.wrappedValue))
            
            ProgressView(value: value.wrappedValue, total: 10)
                .progressViewStyle(.linear)
                .tint(painColor(for: value.wrappedValue))
                .opacity(0.5)
        }
    }
    
    func painDescription(for level: Double) -> String {
        switch level {
        case 0...2: return "🌷 Very Mild"
        case 3...5: return "🌸 Moderate"
        case 6...8: return "🌺 Intense"
        default: return "🔥 Severe"
        }
    }
    
    func painColor(for level: Double) -> Color {
        switch level {
        case 0...2: return stageAccentColor.opacity(0.4)
        case 3...5: return stageAccentColor.opacity(0.6)
        case 6...8: return stageAccentColor.opacity(0.8)
        default: return stageAccentColor
        }
    }
}
private extension SymptomTrackerView {
    
    private var stageAccentColor: Color {
        Color(red: 0.93, green: 0.55, blue: 0.70) 
    }}
