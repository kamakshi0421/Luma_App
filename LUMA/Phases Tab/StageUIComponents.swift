import SwiftUI


struct SectionCard: View {
  
  let icon: String
  let title: String
  let text: String
  let background: Color
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      
      HStack(spacing: 10) {
        
        Image(systemName: icon)
          .font(.headline)
          .foregroundColor(.lumaPinkBubble)
        
        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
        
        Spacer()
      }
      
      Text(text)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(background)
    .liquidGlass(cornerRadius: 24)
    .overlay(
      RoundedRectangle(cornerRadius: 24)
        .stroke(Color(.systemBackground).opacity(0.4), lineWidth: 1)
    )
    
  }
}
struct MiniInsightCard: View {
  
  let title: String
  let text: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      HStack(spacing: 8) {
        
        Image(systemName: "lightbulb.fill")
          .font(.caption)
          .foregroundColor(Color.indigo.opacity(0.8))
        
        Text(title)
          .font(.subheadline)
          .fontWeight(.semibold)
          .foregroundColor(.lumaDarkGray)
        
        Spacer()
      }
      
      Text(text)
        .font(.caption)
        .foregroundColor(.lumaMidGray)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.indigo.opacity(0.08)) 
    )
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color.indigo.opacity(0.15), lineWidth: 1)
    )
    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
  }
}
struct DidYouKnowBubble: View {
  
  let text: String
  
  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      
      Image(systemName: "sparkles")
        .foregroundColor(.lumaPinkBubble.opacity(0.8))
        .font(.caption)
      
      Text(text)
        .font(.subheadline)
        .foregroundColor(.lumaDarkGray)
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer()
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.gray.opacity(0.06))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
    )
    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
  }
}
