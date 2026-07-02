import SwiftUI

struct StoryPlayerView: View {
  let stage: LifeStage
  @Environment(\.dismiss) var dismiss
  
  @State private var chapters: [StoryChapter] = []
  @State private var selectedChapterIndex: Int? = nil
  
  @State private var currentSceneIndex: Int = 0
  @State private var displayedNarration: String = ""
  @State private var showFeedback: Bool = false
  @State private var currentFeedback: String = ""
  @State private var isStoryComplete: Bool = false
  
  var currentChapter: StoryChapter? {
    guard let index = selectedChapterIndex, index < chapters.count else { return nil }
    return chapters[index]
  }
  
  var currentScene: StoryScene? {
    guard let chapter = currentChapter, currentSceneIndex < chapter.scenes.count else { return nil }
    return chapter.scenes[currentSceneIndex]
  }
  
  var character: StoryCharacter? {
    return StoryLibrary.characters[stage]
  }
  
  var body: some View {
    ZStack {
      LumaBackground()
      
      if selectedChapterIndex == nil {
        chapterSelectionScreen
      } else if isStoryComplete {
        completionScreen
      } else if let scene = currentScene, let char = character {
        ZStack(alignment: .top) {
          // Background Illustration
          if let imageName = currentChapter?.imageName {
            GeometryReader { geo in
              Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height * 0.65)
                .clipped()
                .ignoresSafeArea(edges: .top)
                // Adding a subtle gradient at bottom of image to blend with content
                .overlay(
                  LinearGradient(
                    colors: [.clear, .clear, Color(UIColor.systemBackground).opacity(0.8), Color(UIColor.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                  )
                )
            }
          }
          
          VStack {
            // Header with progress and close
            HStack {
              ProgressView(value: Double(currentSceneIndex + 1), total: Double(currentChapter?.scenes.count ?? 1))
                .tint(char.accentColor)
                .background(Color(.systemBackground).opacity(0.8).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
              
              Spacer()
              
              Button {
                // Back to chapter selection
                selectedChapterIndex = nil
              } label: {
                Image(systemName: "xmark.circle.fill")
                  .font(.title2)
                  .foregroundColor(.white)
                  .background(Circle().fill(Color.black.opacity(0.3)))
              }
            }
            .padding()
            
            Spacer()
            
            // Scene Content (Dialogue, Narration, Choices)
            VStack(spacing: 16) {
              if let animType = scene.animationType {
                animationOverlay(for: animType)
                  .frame(height: 60)
              }
              
              // Narration Box
              if !displayedNarration.isEmpty {
                Text(displayedNarration)
                  .font(.title3)
                  .foregroundColor(.white)
                  .multilineTextAlignment(.leading)
                  .padding()
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(char.accentColor.opacity(0.9))
                  .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                  .padding(.horizontal)
                  .transition(.opacity)
                  .id("narration_\(currentSceneIndex)")
              }
              
              // Character Dialogue (if any)
              if let dialogue = scene.characterDialogue {
                StoryDialogueBubble(text: dialogue, color: char.accentColor)
                  .padding(.horizontal)
                  .transition(.move(edge: .bottom).combined(with: .opacity))
              }
              
              // Show avatar only if no image exists
              if currentChapter?.imageName == nil {
                StoryCharacterView(character: char)
                  .padding(.top)
              }
              
              // Choices or Educational Reveal or Tap to continue
              if showFeedback {
                Text(currentFeedback)
                  .font(.headline)
                  .foregroundColor(char.accentColor)
                  .padding()
                  .liquidGlass(cornerRadius: 16)
                  .padding(.horizontal)
                  .transition(.opacity)
              } else if let reveal = scene.educationalReveal {
                VStack(spacing: 10) {
                  HStack {
                    Image(systemName: "sparkles")
                      .foregroundColor(.purple)
                    Text("Did You Know?")
                      .font(.headline)
                      .foregroundColor(.purple)
                  }
                  Text(reveal)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                  
                  Button {
                    advanceScene()
                  } label: {
                    Text("Continue")
                      .font(.headline)
                      .foregroundColor(.white)
                      .padding(.vertical, 12)
                      .frame(maxWidth: .infinity)
                      .background(Color.purple)
                      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                  }
                  .padding(.top)
                }
                .padding()
                .liquidGlass(cornerRadius: 20)
                .padding()
              } else if let choices = scene.choices, !choices.isEmpty {
                VStack(spacing: 12) {
                  ForEach(choices) { choice in
                    Button {
                      handleChoice(choice)
                    } label: {
                      Text(choice.text)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(char.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: char.accentColor.opacity(0.3), radius: 5, y: 2)
                    }
                  }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .transition(.move(edge: .bottom))
              } else {
                Button {
                  advanceScene()
                } label: {
                  Text("Tap to continue")
                    .font(.headline)
                    .foregroundColor(char.accentColor)
                }
                .padding()
                .liquidGlass(cornerRadius: 16)
                .padding(.horizontal)
                .padding(.bottom)
              }
            }
            .padding(.bottom, 20) // Add some padding for the bottom safe area
          }
        }
      }
    }
    .onAppear {
      chapters = StoryLibrary.chapters(for: stage)
    }
  }
  
  var chapterSelectionScreen: some View {
    VStack(spacing: 20) {
      HStack {
        Spacer()
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark.circle.fill")
            .font(.title)
            .foregroundColor(.secondary)
        }
      }
      .padding()
      
      if let char = character {
        Text("Stories with \(char.name)")
          .font(.largeTitle.bold())
          .foregroundColor(.primary)
        
        Text("Select a chapter to experience her journey through \(stage.title).")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
        
        ScrollView {
          VStack(spacing: 16) {
            ForEach(chapters.indices, id: \.self) { index in
              Button {
                selectedChapterIndex = index
                isStoryComplete = false
                currentSceneIndex = 0
                startScene()
              } label: {
                HStack(spacing: 16) {
                  ZStack {
                    Circle()
                      .fill(char.accentColor.opacity(0.2))
                      .frame(width: 50, height: 50)
                    Text("\(index + 1)")
                      .font(.title2.bold())
                      .foregroundColor(char.accentColor)
                  }
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text(chapters[index].title)
                      .font(.headline)
                      .foregroundColor(.primary)
                    Text("\(chapters[index].scenes.count) scenes")
                      .font(.caption)
                      .foregroundColor(.secondary)
                  }
                  
                  Spacer()
                  
                  Image(systemName: "play.circle.fill")
                    .font(.title)
                    .foregroundColor(char.accentColor)
                }
                .padding()
                .liquidGlass(cornerRadius: 20)
              }
              .buttonStyle(.plain)
            }
          }
          .padding()
        }
      }
    }
  }
  
  var completionScreen: some View {
    VStack(spacing: 24) {
      Image(systemName: "star.fill")
        .font(.system(size: 60))
        .foregroundColor(.yellow)
      
      Text("Chapter Complete!")
        .font(.title)
        .bold()
        .foregroundColor(.primary)
      
      Text("You successfully helped \(character?.name ?? "your character") navigate this chapter. Keep learning and listening to your body!")
        .font(.body)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding()
      
      Button {
        // Back to chapter selection
        isStoryComplete = false
        selectedChapterIndex = nil
      } label: {
        Text("More Stories")
          .font(.headline)
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.lumaPinkBubble)
          .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
          .padding(.horizontal)
      }
      
      Button {
        dismiss()
      } label: {
        Text("Back to Phases")
          .font(.headline)
          .foregroundColor(Color.lumaPinkBubble)
          .padding()
      }
    }
  }
  
  func startScene() {
    guard let scene = currentScene else { return }
    displayedNarration = ""
    showFeedback = false
    
    // Typewriter effect
    let text = scene.narration
    for (i, char) in text.enumerated() {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.03) {
        displayedNarration += String(char)
      }
    }
  }
  
  func handleChoice(_ choice: StoryChoice) {
    currentFeedback = choice.feedback
    withAnimation {
      showFeedback = true
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      withAnimation {
        showFeedback = false
        currentSceneIndex = choice.nextSceneIndex
        startScene()
      }
    }
  }
  
  func advanceScene() {
    guard let scene = currentScene else { return }
    if scene.isEndScene {
      withAnimation {
        isStoryComplete = true
      }
    } else {
      withAnimation {
        currentSceneIndex += 1
        startScene()
      }
    }
  }
  
  @ViewBuilder
  func animationOverlay(for type: StoryAnimationType) -> some View {
    switch type {
    case .menstruation:
      MenstruationAnimation()
    case .sparkles:
      SparklesAnimation()
    case .sweat:
      SweatAnimation()
    case .sleep:
      SleepAnimation()
    }
  }
}

// MARK: - Specific Animations
struct MenstruationAnimation: View {
  @State private var animate = false
  
  var body: some View {
    HStack(spacing: 15) {
      ForEach(0..<3) { i in
        Image(systemName: "drop.fill")
          .font(.system(size: 30))
          .foregroundColor(.red.opacity(0.8))
          .offset(y: animate ? 10 : -10)
          .animation(
            .easeInOut(duration: 1.0)
            .repeatForever(autoreverses: true)
            .delay(Double(i) * 0.3),
            value: animate
          )
      }
    }
    .onAppear { animate = true }
  }
}

struct SparklesAnimation: View {
  @State private var animate = false
  
  var body: some View {
    HStack(spacing: 20) {
      ForEach(0..<4) { i in
        Image(systemName: "sparkle")
          .font(.system(size: 35))
          .foregroundColor(.yellow)
          .scaleEffect(animate ? 1.2 : 0.5)
          .opacity(animate ? 1 : 0.3)
          .animation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
            .delay(Double(i) * 0.2),
            value: animate
          )
      }
    }
    .onAppear { animate = true }
  }
}

struct SweatAnimation: View {
  @State private var animate = false
  
  var body: some View {
    HStack(spacing: 10) {
      ForEach(0..<3) { i in
        Image(systemName: "drop")
          .font(.system(size: 25))
          .foregroundColor(.blue.opacity(0.6))
          .offset(y: animate ? 20 : -10)
          .opacity(animate ? 0 : 1)
          .animation(
            .easeIn(duration: 1.5)
            .repeatForever(autoreverses: false)
            .delay(Double(i) * 0.5),
            value: animate
          )
      }
    }
    .onAppear { animate = true }
  }
}

struct SleepAnimation: View {
  @State private var animate = false
  
  var body: some View {
    HStack(spacing: 5) {
      ForEach(0..<3) { i in
        Text("Z")
          .font(.system(size: 20 + CGFloat(i * 10), weight: .bold))
          .foregroundColor(.purple.opacity(0.6))
          .offset(x: animate ? 20 : -20, y: animate ? -30 : 10)
          .opacity(animate ? 0 : 1)
          .animation(
            .easeOut(duration: 2.0)
            .repeatForever(autoreverses: false)
            .delay(Double(i) * 0.7),
            value: animate
          )
      }
    }
    .onAppear { animate = true }
  }
}
