import SwiftUI

struct BodyZoneDetailView: View {
    let info: BodyZoneInfo
    @Environment(\.dismiss) var dismiss
    
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
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
            .padding(.top)
            
            Image(systemName: info.zone.icon)
                .font(.system(size: 60))
                .foregroundColor(.lumaPinkBubble)
                .scaleEffect(appear ? 1.0 : 0.5)
                .opacity(appear ? 1.0 : 0.0)
            
            Text(info.title)
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            ScrollView {
                VStack(spacing: 16) {
                    InfoCard(title: "What's Happening", content: info.description, color: .lumaPinkLight)
                    InfoCard(title: "Hormone Effect", content: info.hormoneEffect, color: .purple.opacity(0.1))
                    InfoCard(title: "Care Tip", content: info.careTip, color: .green.opacity(0.1))
                }
            }
        }
        .padding()
        .background(LumaBackground())
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}

struct InfoCard: View {
    let title: String
    let content: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
    }
}
