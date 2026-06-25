import SwiftUI

struct BreathingExerciseView: View {
  let inhaleSeconds: Int
  let holdSeconds: Int
  let exhaleSeconds: Int
  let rounds: Int
  
  var onComplete: (() -> Void)?
  
  @State private var currentRound = 1
  @State private var instruction = "Ready"
  @State private var scale: CGFloat = 0.4
  @State private var opacity: Double = 0.5
  @State private var isComplete = false
  @State private var isRunning = false
  
  var body: some View {
    VStack(spacing: 0) {
      
      // Instruction text
        Text(isComplete ? "Well done" : instruction)
          .font(.system(size: 34, weight: .light, design: .rounded))
          .foregroundColor(isRunning ? .primary : .secondary)
          .animation(.easeInOut(duration: 1.0), value: instruction)
          .padding(.bottom, 40)
        
        // Breathing Visual
        ZStack {
          // Outer glow
          Circle()
            .fill(Color.lumaPinkBubble.opacity(0.15))
            .frame(width: 320, height: 320)
            .blur(radius: 20)
            .scaleEffect(scale * 1.1)
          
          // Mid layer
          Circle()
            .fill(Color.lumaPinkBubble.opacity(0.3))
            .frame(width: 260, height: 260)
            .blur(radius: 10)
            .scaleEffect(scale * 1.05)
          
          // Core
          Circle()
            .fill(Color.lumaPinkBubble)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
            .opacity(opacity)
            .shadow(color: Color.lumaPinkBubble.opacity(0.4), radius: 20, y: 10)
        }
        .frame(height: 320)
        
        Spacer()
        
        // Progress
        if !isComplete && isRunning {
          Text("Round \(currentRound) of \(rounds)")
            .font(.subheadline.weight(.medium))
            .foregroundColor(.secondary)
            .padding(.bottom, 20)
            .transition(.opacity)
        }
        
        // Button
        Button {
          if isComplete {
            onComplete?()
          } else if !isRunning {
            startBreathing()
          } else {
            // Skip/End early
            onComplete?()
          }
        } label: {
          Text(isComplete ? "Done" : (isRunning ? "End Session" : "Start"))
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.lumaPinkBubble)
            .clipShape(Capsule())
            .shadow(color: Color.lumaPinkBubble.opacity(0.3), radius: 8, y: 4)
        }
        .padding(.horizontal, 30)
      }
    }
  
  func startBreathing() {
    isRunning = true
    runRound()
  }
  
  func runRound() {
    guard currentRound <= rounds else {
      withAnimation(.easeInOut(duration: 1.0)) {
        isComplete = true
        instruction = "Well done"
        scale = 0.5
        opacity = 0.5
      }
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
      return
    }
    
    // Inhale
    instruction = "Breathe In..."
    let generator = UIImpactFeedbackGenerator(style: .soft)
    generator.impactOccurred()
    
    withAnimation(.easeInOut(duration: Double(inhaleSeconds))) {
      scale = 1.0
      opacity = 1.0
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + Double(inhaleSeconds)) {
      if isComplete { return } // If user ended session
      
      // Hold
      instruction = "Hold..."
      
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(holdSeconds)) {
        if isComplete { return }
        
        // Exhale
        instruction = "Breathe Out..."
        let generatorOut = UIImpactFeedbackGenerator(style: .rigid)
        generatorOut.impactOccurred()
        
        withAnimation(.easeInOut(duration: Double(exhaleSeconds))) {
          scale = 0.4
          opacity = 0.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(exhaleSeconds)) {
          if isComplete { return }
          currentRound += 1
          runRound()
        }
      }
    }
  }
}

