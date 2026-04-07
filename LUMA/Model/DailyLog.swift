
import Foundation
struct DailyLog: Identifiable {
    let id = UUID()
    var date: Date
    var moodScore: Int
    var stressLevel: Int
    var hadSymptoms: Bool
}




