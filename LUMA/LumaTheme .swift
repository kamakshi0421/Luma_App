import SwiftUI

extension Color {
  
  
  static let lumaPinkLight = Color(red: 1.00, green: 0.55, blue: 0.78)
  static let lumaPinkDark = Color(red: 0.95, green: 0.15, blue: 0.55)
  
  
  static let lumaAccent = Color(red: 0.85, green: 0.05, blue: 0.45)
  
  static let lumaSurface = Color(red: 1.00, green: 0.96, blue: 0.98)
}

// Removed LumaGradient as per native iOS design guidelines
extension Color {
  // Reverted to Vibrant Rose / Magenta (original app color)
  static let lumaPinkBubble = Color(red: 0.98, green: 0.35, blue: 0.68) 
  static let lumaDarkGray = Color(red: 0.25, green: 0.25, blue: 0.27)
  static let lumaMidGray = Color(red: 0.45, green: 0.45, blue: 0.47)
}
extension Color {
  static let tabUnselected = Color(red: 0.65, green: 0.65, blue: 0.68)
}


struct LumaBackground: View {
  var body: some View {
    Color(UIColor.systemGroupedBackground)
      .ignoresSafeArea()
  }
}
