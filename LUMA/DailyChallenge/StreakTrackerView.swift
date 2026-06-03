import SwiftUI
internal import Combine
import Foundation

class StreakManager: ObservableObject {
    @AppStorage("currentStreak") var currentStreak: Int = 0
    @AppStorage("longestStreak") var longestStreak: Int = 0
    @AppStorage("lastCompletedDateString") private var lastCompletedDateString: String = ""
    
    @Published var todayCompleted: Bool = false
    
    init() {
        checkStreak()
    }
    
    var lastCompletedDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: lastCompletedDateString)
    }
    
    func markTodayComplete() {
        guard !todayCompleted else { return }
        
        todayCompleted = true
        currentStreak += 1
        
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        
        let formatter = ISO8601DateFormatter()
        lastCompletedDateString = formatter.string(from: Date())
    }
    
    func checkStreak() {
        guard let lastDate = lastCompletedDate else { return }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(lastDate) {
            todayCompleted = true
        } else if !calendar.isDateInYesterday(lastDate) {
            // Gap of more than 1 day, reset streak
            currentStreak = 0
            todayCompleted = false
        }
    }
}

struct StreakBadgeView: View {
    @ObservedObject var streakManager: StreakManager
    @State private var pulsing = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .foregroundColor(streakColor)
                .scaleEffect(pulsing && streakManager.currentStreak >= 3 ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulsing)
            
            Text("\(streakManager.currentStreak)")
                .font(.subheadline.bold())
                .foregroundColor(streakColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(streakColor.opacity(0.1))
        .cornerRadius(12)
        .onAppear {
            pulsing = true
        }
    }
    
    var streakColor: Color {
        if streakManager.currentStreak >= 7 {
            return .lumaPinkBubble
        } else if streakManager.currentStreak >= 3 {
            return .orange
        } else {
            return .gray
        }
    }
}

struct StreakDetailView: View {
    @ObservedObject var streakManager: StreakManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Streak")
                .font(.headline)
                .foregroundColor(.lumaDarkGray)
            
            HStack {
                VStack {
                    Text("\(streakManager.currentStreak)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.orange)
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.lumaMidGray)
                }
                
                Spacer()
                
                VStack {
                    Text("\(streakManager.longestStreak)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.lumaPinkBubble)
                    Text("Longest")
                        .font(.caption)
                        .foregroundColor(.lumaMidGray)
                }
            }
            .padding(.horizontal, 40)
            
            Text(motivationalMessage)
                .font(.subheadline)
                .foregroundColor(.lumaMidGray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
    
    var motivationalMessage: String {
        if streakManager.currentStreak == 0 {
            return "Start your streak today!"
        } else if streakManager.currentStreak < 3 {
            return "Great start! Keep it up."
        } else if streakManager.currentStreak < 7 {
            return "You're on fire! 🔥"
        } else {
            return "Amazing consistency! 🌟"
        }
    }
}
