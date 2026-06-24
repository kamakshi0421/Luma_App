import SwiftUI

struct ConditionDetailSheet: View {
  
  let condition: StageCondition
  
  var body: some View {
    ZStack {
      
      Color(.systemBackground)
        .ignoresSafeArea()
      
      ScrollView {
        
        VStack {
          
          VStack(alignment: .leading, spacing: 24) {
            
            
            
            Image(condition.imageName)
              .resizable()
              .scaledToFit()
              .frame(maxWidth: 600)
              .frame(maxWidth: .infinity)
              .clipShape(RoundedRectangle(cornerRadius: 24))
              .shadow(color: .black.opacity(0.08), radius: 8)
            
            
            VStack(alignment: .leading, spacing: 6) {
              
              Text(condition.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
              
              Text(condition.shortDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            
            
            DetailCard(
              icon: "doc.text",
              title: "Overview",
              content: condition.overview,
              backgroundColor: Color.lumaPinkLight.opacity(0.25)
            )
           
            
            StandardCard {
              
              SectionHeader(title: "Common Symptoms", icon: "waveform.path.ecg")
              
              VStack(spacing: 14) {
                
                ForEach(Array(condition.symptoms.enumerated()), id: \.offset) { index, symptom in
                  
                  HStack(alignment: .top, spacing: 12) {
                    
                    Image(systemName: "circle.fill")
                      .font(.system(size: 6))
                      .foregroundColor(.lumaPinkBubble)
                      .padding(.top, 6)
                    
                    Text(symptom)
                      .font(.subheadline)
                      .foregroundColor(.primary)
                    
                    Spacer()
                  }
                  
                  if index != condition.symptoms.count - 1 {
                    Rectangle()
                      .fill(Color.primary.opacity(0.20))
                      .frame(height: 1)
                  }
                }
              }
            }
            
            
            StandardCard {
              
              SectionHeader(title: "Basic Care Tips", icon: "leaf")
              
              VStack(spacing: 14) {
                
                ForEach(Array(condition.basicCare.enumerated()), id: \.offset) { index, tip in
                  
                  HStack(alignment: .top, spacing: 12) {
                    
                    Image(systemName: "checkmark.circle.fill")
                      .foregroundColor(.lumaPinkBubble)
                      .font(.system(size: 16))
                    
                    Text(tip)
                      .font(.subheadline)
                      .foregroundColor(.primary)
                    
                    Spacer()
                  }
                  
                  if index != condition.basicCare.count - 1 {
                    Rectangle()
                      .fill(Color.primary.opacity(0.20)) 
                      .frame(height: 1)
                  }
                }
              }
            }
            
            DetailCard(
              icon: "stethoscope",
              title: "When to See a Doctor",
              content: condition.whenToSeeDoctor,
              backgroundColor: Color.orange.opacity(0.15)
            )
            
            
            Text("Educational information only. Not a medical diagnosis.")
              .font(.caption)
              .foregroundColor(.gray)
              .padding(.top, 8)
          }
          .padding(24)
          .frame(maxWidth: 720)
        }
        .frame(maxWidth: .infinity)
      }
    }
  }
}
struct SectionHeader: View {
  
  let title: String
  let icon: String
  
  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: icon)
        .foregroundColor(.lumaPinkBubble)
      
      Text(title)
        .font(.headline)
        .foregroundColor(.lumaPinkBubble)
    }
  }
}
struct StandardCard<Content: View>: View {
  
  @ViewBuilder let content: Content
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      content
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.lumaPinkLight.opacity(0.18))
    )
  }
}
struct DetailCard: View {
  
  let icon: String
  let title: String
  let content: String
  let backgroundColor: Color
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      
      HStack(spacing: 8) {
        Image(systemName: icon)
        Text(title)
          .font(.headline)
      }
      .foregroundColor(.primary)
      
      Text(content)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(backgroundColor)
    )
  }
}
