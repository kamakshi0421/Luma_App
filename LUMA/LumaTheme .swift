import SwiftUI

extension Color {
    
    
    static let lumaPinkLight = Color(red: 1.00, green: 0.55, blue: 0.78)
    static let lumaPinkDark  = Color(red: 0.95, green: 0.15, blue: 0.55)
    
    
    static let lumaAccent = Color(red: 0.85, green: 0.05, blue: 0.45)
    
    static let lumaSurface = Color(red: 1.00, green: 0.96, blue: 0.98)
}


struct LumaGradient {
    
    static let primary = LinearGradient(
        gradient: Gradient(colors: [
            Color.lumaPinkLight,
            Color.lumaPinkDark
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
  
    static let soft = LinearGradient(
        gradient: Gradient(colors: [
            Color.lumaPinkLight.opacity(0.9),
            Color.lumaPinkLight.opacity(0.6)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
extension Color {
    static let lumaPinkBubble = Color(red: 0.98, green: 0.30, blue: 0.65) 
    static let lumaDarkGray = Color(red: 0.25, green: 0.25, blue: 0.27)
    static let lumaMidGray  = Color(red: 0.45, green: 0.45, blue: 0.47)
}
extension Color {
    static let tabUnselected = Color(red: 0.65, green: 0.65, blue: 0.68)
}


struct LumaBackground: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            
            // Pure white base in light mode (no grey), dark rich plum in dark mode
            (colorScheme == .dark ? Color(red: 0.12, green: 0.05, blue: 0.10) : Color.white)
                .ignoresSafeArea()
            
            // Vibrant pink gradient from the top
            LinearGradient(
                colors: [
                    Color.lumaPinkBubble.opacity(colorScheme == .dark ? 0.3 : 0.25),
                    Color.lumaPinkBubble.opacity(0.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Extra beautiful glow
            RadialGradient(
                colors: [
                    Color.lumaPinkBubble.opacity(colorScheme == .dark ? 0.2 : 0.15),
                    Color.lumaPinkBubble.opacity(0.0)
                ],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
        }
    }
}
