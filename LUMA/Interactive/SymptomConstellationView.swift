import SwiftUI

struct ConstellationNode: Identifiable {
  let id: String
  let name: String
  let relativePosition: CGPoint
}

struct ConstellationPattern {
  let title: String
  let description: String
  let requiredNodes: Set<String>
}

struct SymptomConstellationView: View {
  @Environment(\.dismiss) private var dismiss
  
  // Config
  let nodes: [ConstellationNode] = [
    ConstellationNode(id: "cramps", name: "Cramps", relativePosition: CGPoint(x: 0.25, y: 0.3)),
    ConstellationNode(id: "bloating", name: "Bloating", relativePosition: CGPoint(x: 0.7, y: 0.35)),
    ConstellationNode(id: "fatigue", name: "Fatigue", relativePosition: CGPoint(x: 0.4, y: 0.5)),
    ConstellationNode(id: "headache", name: "Headache", relativePosition: CGPoint(x: 0.65, y: 0.2)),
    ConstellationNode(id: "mood", name: "Mood Swings", relativePosition: CGPoint(x: 0.2, y: 0.65)),
    ConstellationNode(id: "acne", name: "Acne", relativePosition: CGPoint(x: 0.75, y: 0.6)),
    ConstellationNode(id: "tenderness", name: "Breast Tenderness", relativePosition: CGPoint(x: 0.5, y: 0.25)),
    ConstellationNode(id: "backache", name: "Backache", relativePosition: CGPoint(x: 0.3, y: 0.45)),
    ConstellationNode(id: "brainfog", name: "Brain Fog", relativePosition: CGPoint(x: 0.6, y: 0.7)),
    ConstellationNode(id: "hotflashes", name: "Hot Flashes", relativePosition: CGPoint(x: 0.35, y: 0.8)),
    ConstellationNode(id: "nightsweats", name: "Night Sweats", relativePosition: CGPoint(x: 0.65, y: 0.85)),
    ConstellationNode(id: "insomnia", name: "Insomnia", relativePosition: CGPoint(x: 0.85, y: 0.75)),
    ConstellationNode(id: "foodcravings", name: "Food Cravings", relativePosition: CGPoint(x: 0.45, y: 0.6)),
    ConstellationNode(id: "spotting", name: "Spotting", relativePosition: CGPoint(x: 0.4, y: 0.15))
  ]
  
  let patterns: [ConstellationPattern] = [
    ConstellationPattern(
      title: "The Prostaglandin Spike",
      description: "Cramps and bloating are tightly linked to peak prostaglandin production right before your period.",
      requiredNodes: ["cramps", "bloating", "fatigue"]
    ),
    ConstellationPattern(
      title: "The Estrogen Drop",
      description: "A sudden drop in estrogen can trigger headaches and mood swings right before your cycle begins.",
      requiredNodes: ["headache", "mood", "fatigue"]
    ),
    ConstellationPattern(
      title: "The Luteal Phase Craze",
      description: "High progesterone levels can slow digestion and increase appetite, leading to these distinct symptoms.",
      requiredNodes: ["foodcravings", "bloating", "mood"]
    ),
    ConstellationPattern(
      title: "The Perimenopause Shift",
      description: "Fluctuating hormones disrupt your body's temperature regulation and sleep cycles.",
      requiredNodes: ["hotflashes", "nightsweats", "insomnia"]
    ),
    ConstellationPattern(
      title: "The Structural Ache",
      description: "Uterine contractions can radiate to your lower back, while hormone shifts affect joint lubrication.",
      requiredNodes: ["backache", "cramps", "fatigue"]
    ),
    ConstellationPattern(
      title: "The Ovulation Signal",
      description: "A quick surge and drop in estrogen during ovulation can trigger a brief bleed and breast tenderness.",
      requiredNodes: ["spotting", "tenderness", "acne"]
    )
  ]
  
  @State private var pathNodeIDs: [String] = []
  @State private var selectedNodeIDs: Set<String> = []
  @State private var currentDragPoint: CGPoint? = nil
  
  private func absPos(for node: ConstellationNode, in size: CGSize) -> CGPoint {
    CGPoint(x: node.relativePosition.x * size.width, y: node.relativePosition.y * size.height)
  }
  
  @State private var matchedPattern: ConstellationPattern? = nil
  @State private var showMatchAnimation = false
  
  var body: some View {
    ZStack {
      LumaBackground()
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        // Header Area
        VStack(spacing: 8) {
          HStack {
            Button(action: { dismiss() }) {
              Image(systemName: "chevron.left.circle.fill")
                .font(.title)
                .foregroundColor(.primary.opacity(0.8))
            }
            Spacer()
            Button(action: {
              withAnimation {
                matchedPattern = nil
                currentDragPoint = nil
                pathNodeIDs.removeAll()
                selectedNodeIDs.removeAll()
              }
            }) {
              Image(systemName: "arrow.counterclockwise.circle.fill")
                .font(.title)
                .foregroundColor(.primary.opacity(0.8))
            }
          }
          .padding(.horizontal)
          .padding(.top)
          
          Text("Symptom Decoder")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.primary)
          
          Text("Connect 3 related symptoms to reveal their hormonal link")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding(.bottom, 16)
        
        // Stars & Connections layer
        GeometryReader { geo in
          ZStack {
            // Lines
            Canvas { context, size in
              var path = Path()
              if let firstID = pathNodeIDs.first, let firstNode = nodes.first(where: { $0.id == firstID }) {
                path.move(to: absPos(for: firstNode, in: size))
                for id in pathNodeIDs.dropFirst() {
                  if let node = nodes.first(where: { $0.id == id }) {
                    path.addLine(to: absPos(for: node, in: size))
                  }
                }
                if let current = currentDragPoint {
                  path.addLine(to: current)
                }
              }
              
              context.stroke(
                path,
                with: .color(.primary.opacity(0.8)),
                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
              )
            }
            .shadow(color: .primary.opacity(0.3), radius: 8)
            
            // Nodes
            ForEach(nodes) { node in
              VStack(spacing: 8) {
                Circle()
                  .fill(selectedNodeIDs.contains(node.id) ? Color.purple : Color.primary.opacity(0.2))
                  .frame(width: 16, height: 16)
                  .shadow(color: selectedNodeIDs.contains(node.id) ? .purple.opacity(0.5) : .clear, radius: 10)
                  .scaleEffect(selectedNodeIDs.contains(node.id) ? 1.5 : 1.0)
                  .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedNodeIDs.contains(node.id))
                
                Text(node.name)
                  .font(.caption)
                  .fontWeight(.medium)
                  .foregroundColor(selectedNodeIDs.contains(node.id) ? .primary : .secondary)
              }
              .position(absPos(for: node, in: geo.size))
            }
          }
          .contentShape(Rectangle())
          .gesture(
            DragGesture(minimumDistance: 0)
              .onChanged { value in
                if matchedPattern != nil { return } // Stop dragging if matched
                
                currentDragPoint = value.location
                
                // Check collision with nodes (radius ~ 30)
                if let hitNode = nodes.first(where: { distance(from: absPos(for: $0, in: geo.size), to: value.location) < 40 }) {
                  if !selectedNodeIDs.contains(hitNode.id) {
                    selectedNodeIDs.insert(hitNode.id)
                    pathNodeIDs.append(hitNode.id)
                    UIAccessibility.post(notification: .announcement, argument: "Connected \(hitNode.name)")
                    
                    // Provide haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    checkPatterns()
                  }
                }
              }
              .onEnded { _ in
                if matchedPattern == nil {
                  // Reset if no match
                  withAnimation(.easeOut(duration: 0.3)) {
                    currentDragPoint = nil
                    pathNodeIDs.removeAll()
                    selectedNodeIDs.removeAll()
                  }
                } else {
                  currentDragPoint = nil
                }
              }
          )
        }
      }
      
      // Match Reveal Card Overlay
      VStack {
        Spacer()
        if let match = matchedPattern {
          VStack(spacing: 16) {
            Text("Constellation Found! ")
              .font(.headline)
              .foregroundColor(.yellow)
            
            Text(match.title)
              .font(.title2)
              .fontWeight(.bold)
              .foregroundColor(.primary)
            
            Text(match.description)
              .font(.body)
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding(24)
          .frame(maxWidth: .infinity)
          .liquidGlass(cornerRadius: 24)
          .padding()
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .onAppear {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
          }
        }
      }
      
      if showMatchAnimation {
        ConfettiBurstView()
          .transition(.opacity)
      }
    }
  }
  
  private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
    return hypot(p1.x - p2.x, p1.y - p2.y)
  }
  
  private func checkPatterns() {
    for pattern in patterns {
      if pattern.requiredNodes.isSubset(of: selectedNodeIDs) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
          matchedPattern = pattern
        }
        withAnimation {
          showMatchAnimation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation {
            showMatchAnimation = false
          }
        }
        break
      }
    }
    }
  }


// MARK: - Confetti
struct ConfettiBurstView: View {
  
  @State private var animate = false
  
  var body: some View {
    GeometryReader { geo in
      ForEach(0..<25, id: \.self) { _ in
        Circle()
          .fill([
            Color.orange.opacity(0.7),
            Color.green.opacity(0.7),
            Color.lumaPinkBubble.opacity(0.7),
            Color.blue.opacity(0.7)
          ].randomElement()!)
          .frame(width: 8, height: 8)
          .position(
            x: CGFloat.random(in: 0...geo.size.width),
            y: animate ? geo.size.height + 40 : -20
          )
          .animation(
            .linear(duration: Double.random(in: 0.8...1.4)),
            value: animate
          )
      }
      .onAppear { animate = true }
    }
    .ignoresSafeArea()
    .accessibilityHidden(true)
  }
}
