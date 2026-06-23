import SwiftUI
import AVFoundation

@available(iOS 26.0, *)
struct AskLumaView: View {
    
    let currentStage: LifeStage
    @Environment(\.dismiss) var dismiss
    @StateObject private var chatbot = WomenHealthChatbot()
    
    @State private var messageText = ""
    
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Aarohi is here. Take a deep breath 🌷", isUser: false)
    ]
    var stageSuggestions: [(title: String, question: String)] {
        
        switch currentStage {
            
        case .prePuberty:
            return [
                ("Breast changes 🌸", "Is breast tenderness normal before first period?"),
                ("White discharge 🤍", "Is white discharge normal before periods?"),
                ("Mood changes 💭", "Why am I feeling emotional lately?"),
                ("Body odor 🧼", "Why is my body odor changing?")
            ]
            
        case .puberty:
            return [
                ("Irregular periods 🩸", "Are irregular periods normal?"),
                ("Acne 😣", "Why am I getting acne?"),
                ("Mood swings 🎢", "Why do I feel moody before my period?"),
                ("Cramps 🌿", "How can I reduce period cramps?")
            ]
            
        case .reproductive:
            return [
                ("Delayed cycle ⏳", "Why is my period late?"),
                ("Spotting 💧", "Is spotting between periods normal?"),
                ("Breast soreness 🌸", "Why do my breasts hurt before periods?"),
                ("Stress 😔", "Can stress delay my period?")
            ]
            
        case .perimenopause:
            return [
                ("Hot flashes 🔥", "Why am I getting hot flashes?"),
                ("Sleep issues 😴", "Why can't I sleep properly?"),
                ("Brain fog 🧠", "Why am I forgetting things?"),
                ("Irregular cycle 🔄", "Are irregular periods normal now?")
            ]
            
        case .menopause:
            return [
                ("Night sweats 🌙", "Why am I sweating at night?"),
                ("Vaginal dryness 💧", "Is vaginal dryness normal?"),
                ("Mood shifts 💭", "Why am I feeling low lately?"),
                ("Fatigue ⚡", "Why do I feel tired all the time?")
            ]
            
        case .postMenopause:
            return [
                ("Joint stiffness 🦴", "Why are my joints stiff?"),
                ("Bone health 🦴", "How can I protect my bones?"),
                ("Dry skin 🌿", "Why is my skin so dry?"),
                ("Urinary changes 🚻", "Why am I having urinary changes?")
            ]
        }
    }
    
    @State private var isTyping = false
    @State private var isSending = false
    @State private var hasSpokenGreeting = false
    @State private var isSpeaking = false
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        
        ZStack {
            
            LumaBackground()
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            VStack(spacing: 0) {
                headerView
                chatArea
                inputBar
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            speakGreetingIfNeeded()
        }
    }
   
    
    func speakGreetingIfNeeded() {
        guard !hasSpokenGreeting else { return }
        hasSpokenGreeting = true
        
        if !UIAccessibility.isVoiceOverRunning {
            
            let utterance = AVSpeechUtterance(
                string: "Hi, I'm Aarohi. How can I support you today?"
            )
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            utterance.pitchMultiplier = 1.1
            
            isSpeaking = true
            synthesizer.speak(utterance)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                isSpeaking = false
            }
        }
    }
   
    
    // MARK: - Premium Header
    var headerView: some View {
        HStack(spacing: 14) {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            
            // Luma avatar
            Image("ProfileAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 38, height: 38)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.pink.opacity(0.2), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("Aarohi")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.primary)
                    
                    // Online indicator
                    Circle()
                        .fill(Color.green)
                        .frame(width: 7, height: 7)
                }
                
                Text(isSpeaking ? "Speaking..." : "Your wellness companion")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSpeaking {
                MicPulseView()
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
        )
    }

    
    // MARK: - Chat Area
    var chatArea: some View {
        ScrollViewReader { proxy in
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 16) {
                    
                    // Date pill at the top
                    Text("Today")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(.ultraThinMaterial))
                        .padding(.top, 12)
                    
                    ForEach(messages) { msg in
                        ChatBubble(message: msg)
                            .id(msg.id)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.9).combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                    
                    if isTyping {
                        TypingDots()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    }
                    
                    if !isTyping && messages.count <= 2 {
                        suggestionSection
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .onChange(of: messages.count) { _, newCount in
                if let last = messages.last {
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }
 
    
    // MARK: - Premium Input Bar
    var inputBar: some View {
        HStack(spacing: 10) {
            
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.pink.opacity(0.6))
                
                TextField("Ask me anything...", text: $messageText)
                    .font(.subheadline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.primary.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
            
            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up")
                    .font(.body.weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                    .background(
                        LinearGradient(
                            colors: messageText.trimmingCharacters(in: .whitespaces).isEmpty
                                ? [Color.gray.opacity(0.4), Color.gray.opacity(0.3)]
                                : [Color.pink, Color.purple.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(
                        color: messageText.trimmingCharacters(in: .whitespaces).isEmpty
                            ? .clear
                            : Color.pink.opacity(0.35),
                        radius: 8,
                        y: 4
                    )
            }
            .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty || isSending)
            .animation(.easeInOut(duration: 0.2), value: messageText.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.03), radius: 10, y: -5)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    
    func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        messageText = ""
        isTyping = true
        isSending = true
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            messages.append(ChatMessage(text: trimmed, isUser: true))
        }
        
        Task {
            let reply = await chatbot.ask(question: trimmed)
            
            await MainActor.run {
                isTyping = false
                isSending = false
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    messages.append(ChatMessage(text: reply, isUser: false))
                }
            }
        }
    }
    
    
    
    func sendSuggestion(_ text: String) {
        messageText = text
        sendMessage()
    }
    
    // MARK: - Suggestion Section
    var suggestionSection: some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
                Text("Quick questions")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 4)
            
            // Use a wrapping layout for chips
            FlowLayout(spacing: 8) {
                ForEach(stageSuggestions, id: \.title) { item in
                    SuggestionChip(text: item.title) {
                        sendSuggestion(item.question)
                    }
                }
            }
        }
        .padding(.top, 12)
    }
}

// MARK: - Flow Layout for chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }
    
    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        
        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}

// MARK: - Typing Dots
struct TypingDots: View {
    
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.pink.opacity(0.6))
                    .frame(width: 8, height: 8)
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .opacity(animate ? 1 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Suggestion Chip
struct SuggestionChip: View {
    
    let text: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.caption.weight(.medium))
                .foregroundColor(.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.pink.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Mic Pulse
struct MicPulseView: View {
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(Color.pink.opacity(0.15))
                .scaleEffect(animate ? 1.5 : 1)
                .opacity(animate ? 0 : 0.8)
            
            Circle()
                .fill(Color.pink.opacity(0.1))
                .scaleEffect(animate ? 1.2 : 1)
            
            Image(systemName: "waveform")
                .foregroundColor(.pink)
                .font(.caption.weight(.bold))
        }
        .onAppear {
            withAnimation(
                .easeOut(duration: 1.2)
                .repeatForever(autoreverses: false)
            ) {
                animate = true
            }
        }
    }
}

