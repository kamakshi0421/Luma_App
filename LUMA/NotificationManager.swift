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
    
    /// Schedules a daily reminder at 9:00 AM
    func scheduleDailyReminder(userName: String) {
        // First cancel any existing to avoid duplicates
        cancelAllNotifications()
        
        let content = UNMutableNotificationContent()
        
        let name = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            content.title = "Good Morning, beautiful! 🌸"
        } else {
            content.title = "Good Morning, \(name)! 🌸"
        }
        
        content.body = "Take a moment for yourself today. Open Aarohi to log your insights and check your phase."
        content.sound = .default
        
        // Configure the recurring date (9:00 AM every day)
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error.localizedDescription)")
            } else {
                print("Successfully scheduled daily reminder for 9:00 AM.")
            }
        }
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
