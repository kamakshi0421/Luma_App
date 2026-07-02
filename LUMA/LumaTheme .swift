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
    Color.clear
      .overlay(
        ZStack {
          // Base color
          (colorScheme == .dark ? Color(red: 0.12, green: 0.02, blue: 0.15) : Color(white: 0.98))
          
          // Fluid Mesh Element 1 (Top Right)
          Circle()
            .fill(Color.lumaPinkBubble.opacity(colorScheme == .dark ? 0.7 : 0.4))
            .frame(width: 400, height: 400)
            .offset(x: 150, y: -200)
            .blur(radius: 80)
          
          // Fluid Mesh Element 2 (Middle Left)
          Circle()
            .fill(Color.lumaPinkLight.opacity(colorScheme == .dark ? 0.5 : 0.3))
            .frame(width: 350, height: 350)
            .offset(x: -150, y: 50)
            .blur(radius: 60)
            
          // Fluid Mesh Element 3 (Bottom Center)
          Circle()
            .fill(Color.lumaPurpleDeep.opacity(colorScheme == .dark ? 0.8 : 0.2))
            .frame(width: 500, height: 500)
            .offset(x: 50, y: 300)
            .blur(radius: 90)
        }
        .ignoresSafeArea()
      )
  }
}
