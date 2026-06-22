import SwiftUI

@available(iOS 26.0, *)
struct ConcernDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let topic: NormalTopic
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text(topic.shortDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    ConcernInfoCard(
                        title: "Why this happens",
                        icon: "waveform.path.ecg",
                        tintColor: .purple,
                        content: topic.whyItHappens
                    )
                    
                    ConcernInfoCard(
                        title: "When it is normal",
                        icon: "checkmark.seal",
                        tintColor: .green,
                        content: topic.whenItsNormal
                    )
                    
                    ConcernInfoCard(
                        title: "What may help",
                        icon: "leaf",
                        tintColor: .pink,
                        content: topic.whatHelps
                    )
                    
                    ConcernInfoCard(
                        title: "When to seek a doctor",
                        icon: "stethoscope",
                        tintColor: .orange,
                        content: topic.whenToSeekHelp
                    )
                }
                .padding()
            }
            .navigationTitle(topic.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Text("Your body communicates through patterns. Listening to it is a strength.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

@available(iOS 26.0, *)
struct ConcernInfoCard: View {
    let title: String
    let icon: String
    let tintColor: Color
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(tintColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(tintColor)
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(tintColor.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(tintColor.opacity(0.2), lineWidth: 1)
        )
    }
}
