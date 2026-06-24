import SwiftUI

struct StoryCharacterView: View {
  let character: StoryCharacter
  @State private var pulsing = false
  
  var body: some View {
    VStack(spacing: 8) {
      ZStack {
        Circle()
          .fill(character.accentColor.opacity(0.3))
          .frame(width: 100, height: 100)
          .scaleEffect(pulsing ? 1.1 : 1.0)
          .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsing)
        
        Circle()
          .fill(character.accentColor.opacity(0.6))
          .frame(width: 80, height: 80)
        
        Image(systemName: character.avatarIcon)
          .font(.system(size: 50))
      }
      
      Text(character.name)
        .font(.headline)
        .foregroundColor(.lumaDarkGray)
    }
    .onAppear {
      pulsing = true
    }
  }
}

struct StoryDialogueBubble: View {
  let text: String
  let color: Color
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text(text)
        .font(.body)
        .foregroundColor(.lumaDarkGray)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: color.opacity(0.3), radius: 5, y: 3)
      
      // Triangle pointer
      Path { path in
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 15))
        path.addLine(to: CGPoint(x: 30, y: 0))
      }
      .fill(Color(.systemBackground))
      .frame(width: 40, height: 15)
      .shadow(color: color.opacity(0.1), radius: 2, y: 2)
    }
  }
}
