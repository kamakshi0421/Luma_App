import Foundation
import UserNotifications

@available(iOS 26.0, *)
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
  
  static let shared = NotificationManager()
  
  private override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
  }
  
  /// Requests notification permission from the user
  func requestPermission(completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if let error = error {
        print("Error requesting notification permission: \(error.localizedDescription)")
      }
      
      DispatchQueue.main.async {
        completion(granted)
      }
    }
  }
  
  /// Schedules reminders at 9:00 AM, 11:45 AM, and 3:00 PM using a Dynamic Notification Engine
  func scheduleDailyReminder(userName: String) {
    // First cancel any existing to avoid duplicates
    cancelAllNotifications()
    
    let times = [(9, 0), (15, 0)]
    
    for time in times {
      let content = createDynamicContent(for: userName)
      
      var dateComponents = DateComponents()
      dateComponents.hour = time.0
      dateComponents.minute = time.1
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      let request = UNNotificationRequest(identifier: "reminder_\(time.0)_\(time.1)", content: content, trigger: trigger)
      
      UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
          print("Error scheduling reminder at \(time.0):\(time.1): \(error.localizedDescription)")
        } else {
          print("Successfully scheduled dynamic reminder for \(time.0):\(time.1)")
        }
      }
    }
  }
  
  private func createDynamicContent(for userName: String) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    let name = userName.trimmingCharacters(in: .whitespacesAndNewlines)
    let greeting = name.isEmpty ? "beautiful" : name
    
    // Determine notification style randomly (0: Myth, 1: Streak, 2: Phase)
    let style = Int.random(in: 0...2)
    
    switch style {
    case 0:
      // Curiosity / Myth Drop
      let myths = [
        "Does eating chocolate actually cause hormonal breakouts? 🍫 Tap to reveal the truth!",
        "Myth of the Day is ready! Did you know periods don't actually sync up? 👯‍♀️ Learn why.",
        "Is PMDD just another word for regular PMS? 🧠 Tap to reveal the truth.",
        "Does tracking your cycle only matter if you want to get pregnant? 📅 Reveal the fact."
      ]
      content.title = "Aarohi Insights, \(greeting)! ✨"
      content.body = myths.randomElement() ?? myths[0]
      
    case 1:
      // Gamified Streak Alert
      content.title = "Don't lose your streak, \(greeting)! 🔥"
      content.body = "You're doing great! Complete today's women's health challenge in Aarohi to keep your streak alive."
      
    case 2:
      // Phase-Specific Check-in
      let savedStageRaw = UserDefaults.standard.string(forKey: "selectedStage") ?? "reproductive"
      
      switch savedStageRaw {
      case "prePuberty", "puberty":
        content.title = "Body check-in, \(greeting)! 🌸"
        content.body = "Feeling unsure about changes in your body? Open Aarohi to explore what is biologically normal for you right now."
      case "reproductive":
        content.title = "Cycle check-in, \(greeting)! 🌙"
        content.body = "Entering a new phase of your cycle? Here is why your energy or mood might be shifting today."
      case "perimenopause":
        content.title = "Phase check-in, \(greeting)! 🌡️"
        content.body = "Unexpected hot flashes or mood swings today? Open Aarohi to see what's biologically normal right now."
      case "menopause", "postMenopause":
        content.title = "Phase check-in, \(greeting)! ☀️"
        content.body = "Navigating new changes? Relieved from the fluctuations of the cycle, see what's new for you today in Aarohi."
      default:
        content.title = "Aarohi is here, \(greeting)! 💬"
        content.body = "Aarohi is ready to chat! Ask me anything about your hormones or mood today."
      }
      
    default:
      content.title = "Aarohi is here, \(greeting)! 💬"
      content.body = "Aarohi is ready to chat! Ask me anything about your cycle, hormones, or mood today."
    }
    
    content.sound = .default
    return content
  }  
  /// Cancels all scheduled local notifications
  func cancelAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    print("Cancelled all pending notifications.")
  }
  
  // MARK: - UNUserNotificationCenterDelegate
  
  // Allows notifications to show even when the app is in the foreground
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                willPresent notification: UNNotification,
                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound])
  }
}
