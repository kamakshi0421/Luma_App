import SwiftUI

struct ConcernDetailSheet: View {
    
    let topic: NormalTopic
    
    var body: some View {
        ZStack {
            
            
            LinearGradient(
                colors: [
                    Color.lumaPinkBubble.opacity(0.12),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(topic.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.lumaDarkGray)
                        
                        Text(topic.shortDescription)
                            .font(.subheadline)
                            .foregroundColor(.lumaMidGray)
                    }
                    .padding(.horizontal)
                    
                   
                    
                    AskLumaSectionCard(
                        icon: "waveform.path.ecg",
                        title: "Why this happens",
                        content: topic.whyItHappens,
                        accentColor: .purple
                    )
                    
                    
                    AskLumaSectionCard(
                        icon: "checkmark.seal",
                        title: "When it is normal",
                        content: topic.whenItsNormal,
                        accentColor: .green
                    )
                   
                    AskLumaSectionCard(
                        icon: "leaf",
                        title: "What may help",
                        content: topic.whatHelps,
                        accentColor: .pink
                    )
                    
                    
                    AskLumaSectionCard(
                        icon: "stethoscope",
                        title: "When to seek a doctor",
                        content: topic.whenToSeekHelp,
                        accentColor: .orange
                    )
                  
                    
                    Text("Your body communicates through patterns. Listening to it is a strength.")
                        .font(.caption)
                        .foregroundColor(.lumaPinkBubble)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 6)
                }
                .padding(.vertical)
            }
        }
    }
}
struct AskLumaSectionCard: View {
    
    let icon: String
    let title: String
    let content: String
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(accentColor)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.lumaDarkGray)
            }
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.lumaMidGray)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading) 
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.10), radius: 12, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(accentColor.opacity(0.25), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
