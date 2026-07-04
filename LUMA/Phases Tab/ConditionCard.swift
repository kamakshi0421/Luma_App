
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
          .frame(maxWidth: .infinity)
          .frame(height: 150)
          .scaleEffect(condition.imageName == "endometriosis_awareness" ? 1.3 : 1.0)
          .blendMode(condition.imageName == "endometriosis_awareness" ? .multiply : .normal)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 16))
        
        VStack(alignment: .leading, spacing: 6) {
          
          Text(condition.name)
            .font(.headline)
            .foregroundColor(.lumaDarkGray)
          
          Text(condition.shortDescription)
            .font(.caption)
            .foregroundColor(.lumaMidGray)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      .liquidGlass(cornerRadius: 24)
    }
    .buttonStyle(.plain)
  }
}
