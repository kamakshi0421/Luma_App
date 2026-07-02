import SwiftUI

extension Color {
  
  // Bright vibrant magenta from the logo
  static let lumaPinkLight = Color(red: 1.00, green: 0.60, blue: 0.80)
  static let lumaPinkDark = Color(red: 0.85, green: 0.10, blue: 0.50)
  
  static let lumaAccent = Color(red: 0.90, green: 0.15, blue: 0.55)
  static let lumaSurface = Color(red: 1.00, green: 0.96, blue: 0.98)
  
  // Deep rich purple from the logo background
  static let lumaPurpleDeep = Color(red: 0.25, green: 0.05, blue: 0.35)
}

extension Color {
  // Beautiful feminine violet-magenta, perfectly balancing the purple and pink of the logo
  static let lumaPinkBubble = Color(red: 0.78, green: 0.15, blue: 0.72) 
  static let lumaDarkGray = Color(red: 0.25, green: 0.25, blue: 0.27)
  static let lumaMidGray = Color(red: 0.45, green: 0.45, blue: 0.47)
}
extension Color {
  static let tabUnselected = Color(red: 0.65, green: 0.65, blue: 0.68)
}


struct LumaBackground: View {
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      // White in light mode, very deep violet (like the logo) in dark mode
      (colorScheme == .dark ? Color(red: 0.12, green: 0.02, blue: 0.20) : Color.white)
        .ignoresSafeArea()
      
      // Vibrant magenta to deep purple gradient
      LinearGradient(
        colors: [
          Color.lumaPinkBubble.opacity(colorScheme == .dark ? 0.35 : 0.20),
          (colorScheme == .dark ? Color.lumaPurpleDeep.opacity(0.3) : Color.lumaPinkBubble.opacity(0.0)),
          Color.clear
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      // Extra beautiful glow
      RadialGradient(
        colors: [
          Color.lumaPinkBubble.opacity(colorScheme == .dark ? 0.3 : 0.15),
          Color.clear
        ],
        center: .top,
        startRadius: 0,
        endRadius: 600
      )
      .ignoresSafeArea()
    }
  }
}
