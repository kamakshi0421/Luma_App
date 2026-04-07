import SwiftUI

extension Color {
    
    
    static let lumaPinkLight = Color(red: 0.98, green: 0.86, blue: 0.90)
    static let lumaPinkDark  = Color(red: 0.95, green: 0.72, blue: 0.82)
    
    
    static let lumaAccent = Color(red: 0.82, green: 0.36, blue: 0.54)
    
    static let lumaSurface = Color(red: 0.96, green: 0.92, blue: 0.94)
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
    static let lumaPinkBubble = Color(red: 0.86, green: 0.45, blue: 0.62) 
    static let lumaDarkGray = Color(red: 0.25, green: 0.25, blue: 0.27)
    static let lumaMidGray  = Color(red: 0.45, green: 0.45, blue: 0.47)
}
extension Color {
    static let tabUnselected = Color(red: 0.65, green: 0.65, blue: 0.68)
}


struct LumaBackground: View {
    
    var body: some View {
        ZStack {
            
            
            LinearGradient(
                colors: [
                    Color.lumaPinkBubble.opacity(0.15),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            RadialGradient(
                colors: [
                    Color.lumaPinkBubble.opacity(0.10),
                    Color.clear
                ],
                center: .top,
                startRadius: 0,
                endRadius: 450
            )
            .ignoresSafeArea()
        }
    }
}
