import SwiftUI
import AVFoundation

@available(iOS 26.0, *)
struct AskLumaView: View {
    
    let currentStage: LifeStage
    @Environment(\.dismiss) var dismiss
    @StateObject private var chatbot = WomenHealthChatbot()
    
    @State private var messageText = ""
    
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Luma is here. Take a deep breath 🌷", isUser: false)
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
            
            Color.lumaSurface
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
                string: "Hi, I’m Luma. How can I support you today?"
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
   
    
    var headerView: some View {
        HStack(spacing: 14) {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color.lumaPinkBubble)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Ask Luma 💬")
                    .font(.headline)
                    .foregroundColor(.lumaDarkGray)
                
                Text("No judgement. Just soft support.")
                    .font(.caption2)
                    .foregroundColor(.lumaMidGray)
            }
            
            Spacer()
            
            if isSpeaking {
                MicPulseView()
            }
        }
        .padding()
        .background(Color.white.opacity(0.6))
    }

    
    var chatArea: some View {
        ScrollViewReader { proxy in
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    ForEach(messages) { msg in
                        ChatBubble(message: msg)
                            .id(msg.id)
                    }
                    
                    if isTyping {
                        TypingDots()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if !isTyping && messages.count <= 2 {
                        suggestionSection
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal)
            }
            .onChange(of: messages.count) { _, newCount in
                if let last = messages.last {
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }        }
    }
 
    
    var inputBar: some View {
        HStack(spacing: 12) {
            
            TextField("Spill your mind...", text: $messageText)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.lumaPinkLight, lineWidth: 1)
                )
            
            Button {
                sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Color.lumaPinkLight)
                    .clipShape(Circle())
            }
            .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty || isSending)
        }
        .padding()
        .background(Color.white.opacity(0.6))
    }
    
    
    func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        messageText = ""
        isTyping = true
        isSending = true
        
        messages.append(ChatMessage(text: trimmed, isUser: true))
        
        Task {
            let reply = await chatbot.ask(question: trimmed)
            
            await MainActor.run {
                isTyping = false
                isSending = false
                messages.append(ChatMessage(text: reply, isUser: false))
            }
        }
    }
    
    
    
    func sendSuggestion(_ text: String) {
        messageText = text
        sendMessage()
    }
    
    var suggestionSection: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("You may explore 🌷")
                .font(.caption)
                .foregroundColor(.lumaMidGray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    
                    ForEach(stageSuggestions, id: \.title) { item in
                        
                        SuggestionChip(text: item.title) {
                            sendSuggestion(item.question)
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}

struct TypingDots: View {
    
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 6) {
            Circle().frame(width: 7, height: 7)
            Circle().frame(width: 7, height: 7)
            Circle().frame(width: 7, height: 7)
        }
        .foregroundColor(Color.lumaPinkLight.opacity(0.7))
        .opacity(animate ? 1 : 0.3)
        .animation(.easeInOut(duration: 0.8).repeatForever(), value: animate)
        .onAppear { animate = true }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
        )
        .shadow(color: .lumaPinkLight.opacity(0.1), radius: 8, y: 4)
    }
}

struct SuggestionChip: View {
    
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.lumaPinkLight.opacity(0.25), lineWidth: 1)
                )
                .foregroundColor(.lumaDarkGray)
                .shadow(color: .lumaPinkLight.opacity(0.05), radius: 4, y: 2)
        }
    }
}


struct MicPulseView: View {
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(Color.lumaPinkLight.opacity(0.2))
                .frame(width: 60, height: 60)
                .scaleEffect(animate ? 1.4 : 1)
                .opacity(animate ? 0 : 1)
            
            Image(systemName: "mic.fill")
                .foregroundColor(.lumaPinkLight)
                .font(.title3)
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

