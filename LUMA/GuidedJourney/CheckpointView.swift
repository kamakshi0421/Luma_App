import SwiftUI

// MARK: - Checkpoint View
// Interactive knowledge checkpoint that appears between sections in guided journeys

struct CheckpointView: View {
  
  let question: String
  let answer: String
  var style: CheckpointStyle = .didYouKnow
  
  @State private var isRevealed = false
  @State private var appeared = false
  @State private var selectedMythAnswer: Bool? = nil
  
  enum CheckpointStyle {
    case didYouKnow
    case trueFalse
    case reflection
    
    var icon: String {
      switch self {
      case .didYouKnow: return "lightbulb.fill"
      case .trueFalse: return "questionmark.circle.fill"
      case .reflection: return "heart.text.square.fill"
      }
    }
    
    var gradientColors: [Color] {
      switch self {
      case .didYouKnow: return [Color.purple.opacity(0.15), Color.blue.opacity(0.1)]
      case .trueFalse: return [Color.orange.opacity(0.15), Color.yellow.opacity(0.1)]
      case .reflection: return [Color.lumaPinkLight.opacity(0.4), Color.lumaPinkBubble.opacity(0.15)]
      }
    }
    
    var borderColor: Color {
      switch self {
      case .didYouKnow: return .purple.opacity(0.3)
      case .trueFalse: return .orange.opacity(0.3)
      case .reflection: return .lumaPinkBubble.opacity(0.3)
      }
    }
    
    var iconColor: Color {
      switch self {
      case .didYouKnow: return .purple
      case .trueFalse: return .orange
      case .reflection: return .lumaPinkBubble
      }
    }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if style == .trueFalse {
        mythCard
      } else {
        standardCard
      }
    }
    .onAppear {
      withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
        appeared = true
      }
    }
  }
  
  private var mythCard: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Header
      HStack {
        Image(systemName: "sparkles")
          .font(.subheadline)
        Text("MYTH")
          .font(.subheadline.weight(.semibold))
        Spacer()
        Image(systemName: "bookmark")
          .font(.subheadline)
      }
      .foregroundColor(Color(red: 0.55, green: 0.3, blue: 0.95))
      
      // Icon and Text
      Text(question)
        .font(.subheadline)
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
      
      Divider()
        .padding(.vertical, 2)
      
      if !isRevealed {
        Button {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isRevealed = true
          }
        } label: {
          HStack(spacing: 4) {
            Text("Tap to reveal truth")
            Image(systemName: "arrow.right")
          }
          .font(.footnote.weight(.medium))
          .foregroundColor(Color(red: 0.55, green: 0.3, blue: 0.95))
        }
        .buttonStyle(.plain)
      } else {
        // Revealed answer
        VStack(alignment: .leading, spacing: 10) {
          HStack(spacing: 8) {
            Text("FACT")
              .font(.caption.bold())
              .foregroundColor(.green)
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background(Color.green.opacity(0.1))
              .clipShape(Capsule())
            
            Spacer()
          }
          
          Text(answer)
            .font(.subheadline)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .transition(.asymmetric(
          insertion: .scale(scale: 0.95).combined(with: .opacity),
          removal: .opacity
        ))
      }
    }
    .padding(20)
    .background(Color(.secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
    .scaleEffect(appeared ? 1.0 : 0.95)
    .opacity(appeared ? 1.0 : 0.0)
  }
  
  private var standardCard: some View {
    VStack(spacing: 14) {
      HStack(spacing: 10) {
        Image(systemName: style.icon)
          .font(.title3)
          .foregroundColor(style.iconColor)
        
        Text(checkpointLabel)
          .font(.caption.bold())
          .foregroundColor(style.iconColor)
          .textCase(.uppercase)
          .tracking(1)
        
        Spacer()
        
        Image(systemName: "sparkle")
          .font(.caption)
          .foregroundColor(style.iconColor.opacity(0.6))
          .scaleEffect(appeared ? 1.2 : 0.8)
          .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: appeared)
      }
      
      Text(question)
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      if !isRevealed {
        // Tap to reveal button
        Button {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isRevealed = true
          }
        } label: {
          HStack(spacing: 8) {
            Image(systemName: "hand.tap.fill")
              .font(.caption)
            Text("Tap to reveal")
              .font(.caption.bold())
          }
          .foregroundColor(style.iconColor)
          .padding(.horizontal, 18)
          .padding(.vertical, 10)
          .background(
            Capsule()
              .fill(style.iconColor.opacity(0.1))
          )
          .overlay(
            Capsule()
              .stroke(style.iconColor.opacity(0.3), lineWidth: 1)
          )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
      } else {
        // Revealed answer
        VStack(spacing: 10) {
          Rectangle()
            .fill(style.borderColor)
            .frame(height: 1)
          
          HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
              .foregroundColor(.green)
              .font(.subheadline)
              .padding(.top, 2)
            
            Text(answer)
              .font(.subheadline)
              .foregroundColor(.primary)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .transition(.asymmetric(
          insertion: .scale(scale: 0.9).combined(with: .opacity),
          removal: .opacity
        ))
      }
    }
    .padding(18)
    .background(
      Group {
        LinearGradient(
          colors: style.gradientColors,
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      }
    )
    .liquidGlass(cornerRadius: 20)
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(style.borderColor, lineWidth: 1.5)
    )
    .scaleEffect(appeared ? 1.0 : 0.95)
    .opacity(appeared ? 1.0 : 0.0)
  }
  
  private var checkpointLabel: String {
    switch style {
    case .didYouKnow: return "Did You Know?"
    case .trueFalse: return "Quick Check"
    case .reflection: return "Reflect"
    }
  }
}


// MARK: - Emoji Reaction View
// Allows users to react with emojis at checkpoints

struct EmojiReactionView: View {
  
  let prompt: String
  var onReaction: ((String) -> Void)?
  
  @State private var selectedEmoji: String? = nil
  @State private var appeared = false
  
  private let sfSymbols = ["hand.thumbsup.fill", "brain.head.profile.fill", "exclamationmark.bubble.fill", "bolt.heart.fill", "heart.fill"]
  private let symbolColors: [Color] = [.blue, .purple, .orange, .green, .pink]
  private let labels = ["Okay!", "Thinking", "Surprised", "Strong", "Love it"]
  
  var body: some View {
    VStack(spacing: 14) {
      HStack(spacing: 8) {
        Image(systemName: "heart.text.square.fill")
          .foregroundColor(.lumaPinkBubble)
        
        Text(prompt)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(.primary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      if let selected = selectedEmoji {
        // Show selected reaction
        HStack(spacing: 8) {
          if let idx = sfSymbols.firstIndex(of: selected) {
            Image(systemName: selected)
              .font(.title)
              .foregroundColor(symbolColors[idx])
          }
          Text("Thanks for sharing! ")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .transition(.scale.combined(with: .opacity))
      } else {
        // SF Symbol buttons
        HStack(spacing: 16) {
          ForEach(Array(sfSymbols.enumerated()), id: \.offset) { index, symbol in
            Button {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selectedEmoji = symbol
              }
              onReaction?(symbol)
            } label: {
              VStack(spacing: 4) {
                Image(systemName: symbol)
                  .font(.title2)
                  .foregroundColor(symbolColors[index])
                Text(labels[index])
                  .font(.system(size: 9))
                  .foregroundColor(.secondary)
              }
              .padding(8)
              .background(
                RoundedRectangle(cornerRadius: 12)
                  .fill(Color(.secondarySystemBackground))
                  .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
              )
            }
            .buttonStyle(.plain)
            .scaleEffect(appeared ? 1.0 : 0.5)
            .opacity(appeared ? 1.0 : 0.0)
            .animation(
              .spring(response: 0.4, dampingFraction: 0.6).delay(Double(index) * 0.08),
              value: appeared
            )
          }
        }
      }
    }
    .padding(16)
    .liquidGlass(cornerRadius: 20)
    .onAppear {
      appeared = true
    }
  }
}


// MARK: - Section Reveal Wrapper
// Wraps existing section content with animated reveal behavior

struct GuidedSectionReveal<Content: View>: View {
  
  let sectionIndex: Int
  @Binding var revealedUpTo: Int
  @ViewBuilder let content: () -> Content
  
  @State private var isVisible = false
  
  private var isUnlocked: Bool {
    sectionIndex <= revealedUpTo
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if isUnlocked {
        content()
          .opacity(isVisible ? 1.0 : 0.0)
          .offset(y: isVisible ? 0 : 20)
          .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
              isVisible = true
            }
          }
      } else {
        // Locked section indicator
        Button {
          // No action — sections unlock sequentially
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "lock.fill")
              .font(.caption)
              .foregroundColor(.secondary.opacity(0.5))
            
            Text("Continue exploring to unlock")
              .font(.caption)
              .foregroundColor(.secondary.opacity(0.5))
          }
          .padding()
          .frame(maxWidth: .infinity)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color.primary.opacity(0.04))
              .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                  .foregroundColor(.primary.opacity(0.1))
              )
          )
        }
        .disabled(true)
      }
    }
  }
}


// MARK: - Journey Summary Card
// Shown at the end of a guided journey

struct JourneySummaryCard: View {
  
  let stageName: String
  let keyTakeaways: [String]
  @State private var appeared = false
  
  var body: some View {
    VStack(spacing: 18) {
      // Header
      HStack(spacing: 10) {
        Image(systemName: "star.fill")
          .foregroundColor(.yellow)
          .font(.title3)
        
        Text("Journey Complete!")
          .font(.headline)
          .foregroundColor(.primary)
        
        Image(systemName: "star.fill")
          .foregroundColor(.yellow)
          .font(.title3)
      }
      .scaleEffect(appeared ? 1.0 : 0.8)
      
      Text("You've explored the \(stageName) stage")
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      // Key takeaways
      VStack(alignment: .leading, spacing: 10) {
        Text("Key Takeaways")
          .font(.caption.bold())
          .foregroundColor(.lumaPinkBubble)
          .textCase(.uppercase)
          .tracking(1)
        
        ForEach(Array(keyTakeaways.enumerated()), id: \.offset) { index, takeaway in
          HStack(alignment: .top, spacing: 10) {
            Text("")
              .font(.caption)
            
            Text(takeaway)
              .font(.caption)
              .foregroundColor(.primary)
          }
          .opacity(appeared ? 1.0 : 0.0)
          .offset(x: appeared ? 0 : -20)
          .animation(
            .easeOut(duration: 0.4).delay(0.3 + Double(index) * 0.15),
            value: appeared
          )
        }
      }
      .padding(14)
      .background(
        RoundedRectangle(cornerRadius: 14)
          .fill(Color.lumaPinkLight.opacity(0.2))
      )
    }
    .padding(20)
    .liquidGlass(cornerRadius: 22)
    .onAppear {
      withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
        appeared = true
      }
    }
  }
}


// MARK: - Stage Journey Takeaways Data

struct JourneyTakeaways {
  
  static func takeaways(for stage: LifeStage) -> [String] {
    switch stage {
    case .prePuberty:
      return [
       "Hormonal changes begin before any visible signs appear",
       "Breast buds and vaginal discharge are normal early signs",
       "Emotional sensitivity is part of brain development",
       "Open conversations reduce anxiety about body changes"
      ]
    case .puberty:
      return [
       "First periods are often irregular — this is completely normal",
       "The HPO axis (brain-ovary connection) takes 2-3 years to mature",
       "Iron-rich foods help combat period-related fatigue",
       "Every body develops at its own pace and timeline"
      ]
    case .reproductive:
      return [
       "Normal cycles range from 21-35 days, not just 28",
       "Stress directly impacts hormone balance and cycle timing",
       "Ovulation, not just periods, is a key health indicator",
       "Tracking patterns builds powerful body awareness"
      ]
    case .perimenopause:
      return [
       "This transition can last 4-10 years before menopause",
       "Hot flashes are caused by fluctuating estrogen, not illness",
       "Brain fog is real and hormone-related — you're not losing your mind",
       "Pregnancy is still possible during perimenopause"
      ]
    case .menopause:
      return [
       "Menopause is confirmed after 12 consecutive months without a period",
       "Hormone therapy options exist and should be discussed with a doctor",
       "Heart health becomes especially important after menopause",
       "This is a new chapter, not an ending"
      ]
    case .postMenopause:
      return [
       "Bone density monitoring becomes essential",
       "Any vaginal bleeding must be evaluated by a doctor",
       "Regular exercise maintains joint flexibility and heart health",
       "Omega-3 fatty acids support tissue moisture and brain health"
      ]
    }
  }
}
