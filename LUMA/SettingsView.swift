import SwiftUI
import StoreKit

@available(iOS 26.0, *)
struct SettingsView: View {
  
  @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
  @AppStorage("notificationsEnabled") private var notificationsEnabled = false
  @AppStorage("dailyReminderEnabled") private var dailyReminderEnabled = false
  
  @Environment(\.requestReview) var requestReview
  
  // These are only used in clearAllData
  @AppStorage("user_name") private var userName: String = ""
  @AppStorage("user_age") private var userAge: Int = 25
  @AppStorage("selectedStage") private var selectedStageRaw: String = LifeStage.reproductive.rawValue
  @AppStorage("currentStreak") private var currentStreak: Int = 0
  @AppStorage("longestStreak") private var longestStreak: Int = 0
  
  @State private var showResetAlert = false
  @State private var showClearDataAlert = false
  
  var body: some View {
    Form {
      // ── Section: Preferences ──
      Section(header: Text("Preferences")) {
        Toggle(isOn: $notificationsEnabled) {
          HStack {
            Image(systemName: "bell.badge.fill")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.red)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Notifications")
          }
        }
        .tint(.lumaAccent)
        .onChange(of: notificationsEnabled) { _, newValue in
          if newValue {
            NotificationManager.shared.requestPermission { granted in
              if !granted {
                notificationsEnabled = false
                dailyReminderEnabled = false
              }
            }
          } else {
            dailyReminderEnabled = false
            NotificationManager.shared.cancelAllNotifications()
          }
        }
        
        Toggle(isOn: $dailyReminderEnabled) {
          HStack {
            Image(systemName: "calendar.badge.clock")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.purple)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Daily Reminders")
          }
        }
        .tint(.lumaAccent)
        .onChange(of: dailyReminderEnabled) { _, newValue in
          if newValue {
            if !notificationsEnabled {
              notificationsEnabled = true
              NotificationManager.shared.requestPermission { granted in
                if granted {
                  NotificationManager.shared.scheduleDailyReminder(userName: userName)
                } else {
                  notificationsEnabled = false
                  dailyReminderEnabled = false
                }
              }
            } else {
              NotificationManager.shared.scheduleDailyReminder(userName: userName)
            }
          } else {
            NotificationManager.shared.cancelAllNotifications()
          }
        }
      }
      
      // ── Section: About Aarohi ──
      Section(header: Text("About Aarohi")) {
        HStack {
          Image(systemName: "app.badge.fill")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
          Text("Version")
          Spacer()
          Text("1.0.0").foregroundColor(.secondary)
        }
        Button(action: {
          requestReview()
        }) {
          HStack {
            Image(systemName: "star.fill")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.yellow)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Rate Us")
              .foregroundColor(.primary)
          }
        }
        Button(action: shareApp) {
          HStack {
            Image(systemName: "square.and.arrow.up.fill")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.green)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Share App")
              .foregroundColor(.primary)
          }
        }
        Button(action: {}) {
          HStack {
            Image(systemName: "lock.shield.fill")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.gray)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Privacy Policy")
              .foregroundColor(.primary)
          }
        }
      }
      
      // ── Section: Danger Zone ──
      Section {
        Button(role: .destructive, action: { showResetAlert = true }) {
          HStack {
            Image(systemName: "arrow.counterclockwise")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.orange)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Reset Onboarding")
          }
        }
        Button(role: .destructive, action: { showClearDataAlert = true }) {
          HStack {
            Image(systemName: "trash.fill")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.red)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Clear All Data")
          }
        }
      }
    }
    .navigationTitle("Settings")
    .navigationBarTitleDisplayMode(.inline)
    .background(
      Color(.systemGroupedBackground)
        .alert("Reset Onboarding?", isPresented: $showResetAlert) {
          Button("Cancel", role: .cancel) { }
          Button("Reset", role: .destructive) {
            hasSeenOnboarding = false
          }
        } message: {
          Text("This will show the onboarding journey again on next launch.")
        }
        .alert("Clear All Data?", isPresented: $showClearDataAlert) {
          Button("Cancel", role: .cancel) { }
          Button("Clear Everything", role: .destructive) {
            clearAllData()
          }
        } message: {
          Text("This will reset your name, age, phase, streaks, and all preferences. This cannot be undone.")
        }
        .tint(.blue)
    )
  }
  
  private func shareApp() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first else { return }
    
    let shareText = "Check out Aarohi — a beautiful women's health app that guides you through every life stage! "
    let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
    
    window.rootViewController?.present(activityVC, animated: true)
  }
  
  private func clearAllData() {
    userName = ""
    userAge = 25
    selectedStageRaw = LifeStage.reproductive.rawValue
    hasSeenOnboarding = false
    currentStreak = 0
    longestStreak = 0
    notificationsEnabled = false
    dailyReminderEnabled = false
  }
}
