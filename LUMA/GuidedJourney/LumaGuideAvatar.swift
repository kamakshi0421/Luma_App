import SwiftUI

// MARK: - Luma Guide Avatar
// An animated circular avatar representing Luma as a guide through educational content

struct LumaGuideAvatar: View {
    
    var size: CGFloat = 56
    var showSpeechIndicator: Bool = false
    @State private var glowPulse = false
    @State private var wavePhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.lumaPinkBubble.opacity(0.3),
                            Color.lumaPinkBubble.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: size * 0.4,
                        endRadius: size * 0.7
                    )
                )
                .frame(width: size * 1.4, height: size * 1.4)
                .scaleEffect(glowPulse ? 1.15 : 1.0)
                .opacity(glowPulse ? 0.8 : 0.5)
            
            // Main circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.lumaPinkLight, Color.lumaPinkBubble],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color.lumaPinkBubble.opacity(0.3), radius: 8, y: 4)
            
            // Luma face
            VStack(spacing: 2) {
                // Eyes
                HStack(spacing: size * 0.15) {
                    Circle()
                        .fill(Color.lumaDarkGray)
                        .frame(width: size * 0.1, height: size * 0.1)
                    Circle()
                        .fill(Color.lumaDarkGray)
                        .frame(width: size * 0.1, height: size * 0.1)
                }
                
                // Smile
                if showSpeechIndicator {
                    // Animated speaking mouth
                    Capsule()
                        .fill(Color.lumaDarkGray.opacity(0.7))
                        .frame(width: size * 0.2, height: size * 0.08)
                        .scaleEffect(y: glowPulse ? 1.4 : 0.6)
                } else {
                    // Static smile
                    ArcShape()
                        .stroke(Color.lumaDarkGray, lineWidth: 2)
                        .frame(width: size * 0.22, height: size * 0.1)
                }
            }
            .offset(y: size * 0.02)
            
            // Sparkle decorations
            Image(systemName: "sparkle")
                .font(.system(size: size * 0.18))
                .foregroundColor(.white.opacity(0.8))
                .offset(x: size * 0.35, y: -size * 0.3)
                .scaleEffect(glowPulse ? 1.2 : 0.8)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
        }
    }
}

// Simple arc shape for the smile
struct ArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.minY),
            radius: rect.width / 2,
            startAngle: .degrees(0),
            endAngle: .degrees(180),
            clockwise: false
        )
        return path
    }
}

// MARK: - Luma Speech Bubble
// A speech bubble that appears next to the guide avatar with animated text

struct LumaSpeechBubble: View {
    
    let text: String
    var accentColor: Color = .lumaPinkBubble
    @State private var displayedText: String = ""
    @State private var isAnimating = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            LumaGuideAvatar(size: 40, showSpeechIndicator: isAnimating)
            
            VStack(alignment: .leading, spacing: 0) {
                // Triangle pointer
                Triangle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 12, height: 8)
                    .rotationEffect(.degrees(-90))
                    .offset(x: -6, y: 12)
                
                Text(displayedText)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.06), radius: 6, y: 3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(accentColor.opacity(0.15), lineWidth: 1)
                    )
            }
        }
        .onAppear {
            animateText()
        }
        .onChange(of: text) { _, _ in
            displayedText = ""
            animateText()
        }
    }
    
    private func animateText() {
        isAnimating = true
        displayedText = ""
        
        for (index, character) in text.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.025) {
                displayedText += String(character)
                
                if index == text.count - 1 {
                    isAnimating = false
                }
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Guide Greeting
// A large greeting view used at the start of guided journeys

struct LumaGuideGreeting: View {
    
    let stageName: String
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 16) {
            LumaGuideAvatar(size: 72)
                .scaleEffect(appeared ? 1.0 : 0.5)
                .opacity(appeared ? 1.0 : 0.0)
            
            Text("Hi, I'm Aarohi! 💗")
                .font(.title3.bold())
                .foregroundColor(.primary)
                .opacity(appeared ? 1.0 : 0.0)
            
            Text("Let me walk you through the \(stageName) stage.\nTap to explore each section!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(appeared ? 1.0 : 0.0)
        }
        .padding(.vertical, 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                appeared = true
            }
        }
    }
}
