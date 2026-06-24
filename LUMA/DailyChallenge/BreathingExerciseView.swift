import SwiftUI

struct BreathingExerciseView: View {
  let inhaleSeconds: Int
  let holdSeconds: Int
  let exhaleSeconds: Int
  let rounds: Int
  
  var onComplete: (() -> Void)?
  
  @State private var currentRound = 1
  @State private var instruction = "Ready"
  @State private var scale: CGFloat = 0.5
  @State private var isComplete = false
  
  var body: some View {
    VStack(spacing: 30) {
      Text(isComplete ? "Well done ": instruction)
        .font(.title)
        .foregroundColor(.lumaDarkGray)
        .animation(.easeInOut, value: instruction)
      
      ZStack {
        Circle()
          .fill(Color.lumaPinkLight.opacity(0.3))
          .frame(width: 300, height: 300)
        
        Circle()
          .fill(LinearGradient(colors: [Color.lumaPinkLight, Color.lumaPinkBubble], startPoint: .topLeading, endPoint: .bottomTrailing))
          .frame(width: 250 * scale, height: 250 * scale)
          .shadow(radius: 10)
      }
      .frame(height: 300)
      
      if !isComplete {
        Text("Round \(currentRound) of \(rounds)")
          .font(.headline)
          .foregroundColor(.lumaMidGray)
      }
      
      Button {
        if isComplete {
          onComplete?()
        } else {
          startBreathing()
        }
      } label: {
        Text(isComplete ? "Done" : (instruction == "Ready" ? "Start" : "Skip"))
          .font(.headline)
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.lumaPinkBubble)
          .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
      }
      .padding(.horizontal)
    }
  }
  
  func startBreathing() {
    guard currentRound <= rounds else {
      isComplete = true
      return
    }
    
    // Inhale
    instruction = "Breathe In..."
    withAnimation(.easeInOut(duration: Double(inhaleSeconds))) {
      scale = 1.0
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + Double(inhaleSeconds)) {
      // Hold
      instruction = "Hold..."
      
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(holdSeconds)) {
        // Exhale
        instruction = "Breathe Out..."
        withAnimation(.easeInOut(duration: Double(exhaleSeconds))) {
          scale = 0.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(exhaleSeconds)) {
          currentRound += 1
          startBreathing()
        }
      }
    }
  }
}
