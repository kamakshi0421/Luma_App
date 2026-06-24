import SwiftUI
import SwiftUI

struct PopularQuestionSheet: View {
  
  let question: PopularQuestion
  
  var body: some View {
    ZStack {
      
      Color(UIColor.systemGroupedBackground)
      .ignoresSafeArea()

      ScrollView {
        
        VStack {
          
          VStack(alignment: .leading, spacing: 28) {
            
            
            VStack(alignment: .leading, spacing: 8) {
              
              HStack(spacing: 8) {
                Image(systemName: question.icon)
                  .foregroundColor(question.color)
                
                Text(question.title)
                  .font(.title2)
                  .fontWeight(.bold)
                  .foregroundColor(.lumaDarkGray)
              }
              
              Text(question.subtitle)
                .font(.subheadline)
                .foregroundColor(.lumaMidGray)
            }
            
            PopularQuestionDetailCard(
              icon: "questionmark.circle",
              title: "Why this happens",
              text: question.why,
              color: question.color
            )
            
            PopularQuestionDetailCard(
              icon: "checkmark.seal",
              title: "When it is normal",
              text: question.normal,
              color: .green
            )
            
            PopularQuestionDetailCard(
              icon: "leaf",
              title: "What may help",
              text: question.help,
              color: .purple
            )
            
            PopularQuestionDetailCard(
              icon: "stethoscope",
              title: "When to see a doctor",
              text: question.doctor,
              color: .orange
            )
            
            Text("Your body communicates through patterns. Listening to it is strength.")
              .font(.caption)
              .foregroundColor(question.color)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity)
          }
          .padding(.vertical, 30)
          .padding(.horizontal, 20)
          .frame(maxWidth: 640)     
          .frame(maxWidth: .infinity)
        }
      }
    }
  }
}
struct PopularQuestionDetailCard: View {
  
  let icon: String
  let title: String
  let text: String
  let color: Color
  
  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      
      HStack(spacing: 8) {
        Image(systemName: icon)
          .foregroundColor(color)
        
        Text(title)
          .font(.headline)
          .foregroundColor(.lumaDarkGray)
      }
      
      Text(text)
        .font(.subheadline)
        .foregroundColor(.lumaMidGray)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(20)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 22)
        .fill(Color(.systemBackground))
        .shadow(color: color.opacity(0.25), radius: 10, y: 6)
    )
  }
}
