import SwiftUI

struct ScenarioGameView: View {
    let stage: LifeStage
    @State private var scenarios: [Scenario] = []
    @State private var currentScenarioIndex = 0
    @State private var selectedChoice: ScenarioChoice? = nil
    @State private var showResult = false
    @State private var score = 0
    @State private var isComplete = false
    
    var body: some View {
        ZStack {
            LumaBackground()
            
            if isComplete {
                completionScreen
            } else if let scenario = scenarios[safe: currentScenarioIndex] {
                VStack(spacing: 20) {
                    Text("What Would You Do?")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.lumaDarkGray)
                        .padding(.top)
                    
                    Image(systemName: scenario.icon)
                        .font(.system(size: 60))
                        .foregroundColor(.lumaPinkBubble)
                        .padding()
                    
                    Text(scenario.situation)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.lumaDarkGray)
                        .padding()
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        ForEach(scenario.choices) { choice in
                            Button {
                                handleChoice(choice)
                            } label: {
                                Text(choice.text)
                                    .font(.headline)
                                    .foregroundColor(.lumaDarkGray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        selectedChoice?.id == choice.id ? choice.quality.color.opacity(0.2) : Color.white
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedChoice?.id == choice.id ? choice.quality.color : Color.clear, lineWidth: 2)
                                    )
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                                    .opacity(showResult && selectedChoice?.id != choice.id ? 0.5 : 1.0)
                            }
                            .disabled(showResult)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    if showResult, let choice = selectedChoice {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: choice.quality.icon)
                                    .foregroundColor(choice.quality.color)
                                Text(choice.quality.label)
                                    .font(.headline)
                                    .foregroundColor(choice.quality.color)
                            }
                            
                            Text(choice.explanation)
                                .font(.subheadline)
                                .foregroundColor(.lumaDarkGray)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                nextScenario()
                            } label: {
                                Text("Next")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.lumaPinkBubble)
                                    .cornerRadius(16)
                            }
                            .padding(.top)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding()
                        .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .onAppear {
            scenarios = ScenarioLibrary.scenarios(for: stage)
        }
    }
    
    var completionScreen: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Great Job!")
                .font(.title)
                .bold()
                .foregroundColor(.lumaDarkGray)
            
            Text("You navigated those situations well. You got \(score) out of \(scenarios.count) best choices!")
                .font(.body)
                .foregroundColor(.lumaMidGray)
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                resetGame()
            } label: {
                Text("Play Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.lumaPinkBubble)
                    .cornerRadius(20)
                    .padding()
            }
        }
    }
    
    func handleChoice(_ choice: ScenarioChoice) {
        selectedChoice = choice
        if choice.quality == .best {
            score += 1
        }
        withAnimation {
            showResult = true
        }
    }
    
    func nextScenario() {
        withAnimation {
            if currentScenarioIndex < scenarios.count - 1 {
                currentScenarioIndex += 1
                selectedChoice = nil
                showResult = false
            } else {
                isComplete = true
            }
        }
    }
    
    func resetGame() {
        currentScenarioIndex = 0
        selectedChoice = nil
        showResult = false
        score = 0
        isComplete = false
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
