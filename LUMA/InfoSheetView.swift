import SwiftUI

struct InfoSheetView: View {
    
    let tab: LumaTab
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text(sheetTitle)
                        .font(.title2.bold())
                        .foregroundColor(.lumaDarkGray)
                    
                    ForEach(sections, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            
                            HStack(spacing: 8) {
                                Image(systemName: section.icon)
                                    .foregroundColor(.lumaPinkBubble)
                                
                                Text(section.title)
                                    .font(.headline)
                                    .foregroundColor(.lumaPinkBubble)
                            }
                            
                            Text(section.content)
                                .font(.body)
                                .foregroundColor(.lumaDarkGray)
                        }
                    }
                    
                    Text("Your body deserves understanding, not fear.")
                        .font(.footnote)
                        .foregroundColor(.lumaMidGray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
private struct InfoSection {
    let title: String
    let content: String
    let icon: String
}
private extension InfoSheetView {
    
    var sheetTitle: String {
        switch tab {
        case .herSpace:
            return "About MySpace"
        case .phases:
            return "Understanding Life Phases"
        case .reveal:
            return "Reveal — Myths & Normal Experiences"
        }
    }
    
    var sections: [InfoSection] {
        switch tab {
            
        case .herSpace:
            return [
                InfoSection(
                    title: "What This Space Is",
                    content: "MySpace is your gentle home base. It reflects your current life stage and helps you stay connected to your body through awareness, not pressure.",
                    icon: "heart.fill"
                ),
                InfoSection(
                    title: "What You’ll See Here",
                    content: "• Your current phase\n• Weekly AI-powered insight\n• Stage-specific conditions\n• Quick symptom tracking",
                    icon: "chart.bar.fill"
                ),
                InfoSection(
                    title: "How Insights Work",
                    content: "Insights are generated from your logged patterns. They are supportive reflections, not medical diagnoses.",
                    icon: "brain.head.profile"
                )
            ]
            
        case .phases:
            return [
                InfoSection(
                    title: "What This Section Does",
                    content: "Phases explains how the female body changes across different life stages — from puberty to post-menopause.",
                    icon: "leaf.fill"
                ),
                InfoSection(
                    title: "What You’ll Learn",
                    content: "• Hormonal changes\n• Common experiences\n• Gentle care suggestions\n• When to seek medical advice",
                    icon: "book.fill"
                ),
                InfoSection(
                    title: "Why This Matters",
                    content: "Every stage is normal. Understanding your phase builds clarity and confidence.",
                    icon: "sparkles"
                )
            ]
            
        case .reveal:
            return [
                InfoSection(
                    title: "What Reveal Does",
                    content: "Reveal separates myths from facts and helps you understand what’s biologically normal.",
                    icon: "lightbulb.fill"
                ),
                InfoSection(
                    title: "Inside This Section",
                    content: "• Myth vs Fact cards\n• Quick 'Is it normal?' checks\n• Detailed explanations",
                    icon: "doc.text.fill"
                ),
                InfoSection(
                    title: "A Gentle Reminder",
                    content: "Bodies vary. Normal is a range, not a single definition.",
                    icon: "hands.sparkles.fill"
                )
            ]
        }
    }
}
