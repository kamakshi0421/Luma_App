
import SwiftUI

struct ConditionCard: View {
    
    let condition: StageCondition
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            
            VStack(alignment: .leading, spacing: 14) {
                
                Image(condition.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(condition.name)
                        .font(.headline)
                        .foregroundColor(.lumaDarkGray)
                    
                    Text(condition.shortDescription)
                        .font(.caption)
                        .foregroundColor(.lumaMidGray)
                        .lineLimit(2)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.purple.opacity(0.07))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.purple.opacity(0.18), lineWidth: 1)
            )
            .shadow(
                color: Color.purple.opacity(0.10),   
                radius: 10,
                y: 4
            )
        }
        .buttonStyle(.plain)
    }
}
