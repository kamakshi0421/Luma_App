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
                VStack {
                    // Header with progress and close
                    HStack {
                        ProgressView(value: Double(currentSceneIndex + 1), total: Double(currentChapter?.scenes.count ?? 1))
                            .tint(char.accentColor)
                        
                        Spacer()
                        
                        Button {
                            // Back to chapter selection
                            selectedChapterIndex = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.lumaMidGray)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Narration
                    Text(displayedNarration)
                        .font(.title3)
                        .foregroundColor(.lumaDarkGray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .transition(.opacity)
                        .id("narration_\(currentSceneIndex)")
                    
                    if let animType = scene.animationType {
                        animationOverlay(for: animType)
                            .frame(height: 80)
                    } else {
                        Spacer()
                    }
                    
                    // Character & Dialogue
                    if let dialogue = scene.characterDialogue {
                        VStack(spacing: 0) {
                            StoryDialogueBubble(text: dialogue, color: char.accentColor)
                                .padding(.bottom, -10)
                                .zIndex(1)
                            
                            StoryCharacterView(character: char)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        StoryCharacterView(character: char)
                    }
                    
                    Spacer()
                    
                    // Choices or Educational Reveal or Tap to continue
                    if showFeedback {
                        Text(currentFeedback)
                            .font(.headline)
                            .foregroundColor(char.accentColor)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)
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
                                .foregroundColor(.lumaDarkGray)
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
                                    .cornerRadius(16)
                            }
                            .padding(.top)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(colors: [Color.purple.opacity(0.1), Color.lumaPinkBubble.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.purple.opacity(0.3), lineWidth: 2))
                        .padding()
                    } else if let choices = scene.choices, !choices.isEmpty {
                        VStack(spacing: 12) {
                            ForEach(choices) { choice in
                                Button {
                                    handleChoice(choice)
                                } label: {
                                    Text(choice.text)
                                        .font(.headline)
                                        .foregroundColor(.lumaDarkGray)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                                }
                            }
                        }
                        .padding()
                        .transition(.move(edge: .bottom))
                    } else {
                        Button {
                            advanceScene()
                        } label: {
                            Text("Tap to continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(char.accentColor)
                                .cornerRadius(20)
                                .padding()
                        }
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
                        .foregroundColor(.lumaMidGray)
                }
            }
            .padding()
            
            if let char = character {
                Text("Stories with \(char.name)")
                    .font(.largeTitle.bold())
                    .foregroundColor(.lumaDarkGray)
                
                Text("Select a chapter to experience her journey through \(stage.title).")
                    .font(.subheadline)
                    .foregroundColor(.lumaMidGray)
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
                                            .foregroundColor(.lumaDarkGray)
                                        Text("\(chapters[index].scenes.count) scenes")
                                            .font(.caption)
                                            .foregroundColor(.lumaMidGray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "play.circle.fill")
                                        .font(.title)
                                        .foregroundColor(char.accentColor)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
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
                .foregroundColor(.lumaDarkGray)
            
            Text("You successfully helped \(character?.name ?? "your character") navigate this chapter. Keep learning and listening to your body!")
                .font(.body)
                .foregroundColor(.lumaMidGray)
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
                    .cornerRadius(20)
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
