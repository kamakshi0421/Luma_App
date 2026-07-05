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
        NavigationLink(destination: PrivacyPolicyView()) {
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
        
        NavigationLink(destination: TermsOfServiceView()) {
          HStack {
            Image(systemName: "doc.text.fill")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.white)
              .frame(width: 28, height: 28)
              .background(Color.gray)
              .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            Text("Terms of Service")
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

@available(iOS 26.0, *)
struct LegalCard: View {
    var title: String
    var icon: String
    var content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.lumaAccent)
                    .frame(width: 24)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

@available(iOS 26.0, *)
struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy Policy")
                            .font(.largeTitle.weight(.bold))
                        Text("Your health data is yours. We protect it fiercely.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    LegalCard(title: "1. Introduction", icon: "hand.raised.fill", content: "At Aarohi (\"we\", \"our\", or \"us\"), your privacy is our highest priority. As a women's health and wellness application, we understand the incredibly sensitive nature of the information you track. We have built Aarohi with strict privacy-by-design principles — your data stays on your device, always.")
                    
                    LegalCard(title: "2. Data We Collect", icon: "list.clipboard.fill", content: "To provide you with personalized insights, we collect the following data — all stored locally on your device only:\n• Profile Information: Your name, age, selected avatar, and current life phase.\n• Health & Symptom Logs: Mood, menstrual flow, pain levels, energy levels, stress, and sleep hours.\n• App Preferences: Notification settings, daily reminder preferences, onboarding status, and streak data.")
                    
                    LegalCard(title: "3. Data We Do NOT Collect", icon: "xmark.shield.fill", content: "Because of the sensitive nature of female health tracking, we have a strict policy. We do not collect, store, or have access to:\n• Email addresses, phone numbers, or contact information\n• Location or GPS data\n• Photos, camera, or microphone data\n• Device identifiers (IDFA) or advertising data\n• Financial or payment data\n• Contacts or social media data\n• Apple HealthKit data")
                    
                    LegalCard(title: "4. No Cloud Storage", icon: "icloud.slash.fill", content: "Aarohi stores all your personal and health data exclusively on your device using local storage (UserDefaults and SwiftData). We do not use any cloud databases, remote servers, or third-party storage services. Your data never leaves your iPhone.")
                    
                    LegalCard(title: "5. AI Features — On-Device Processing", icon: "cpu", content: "Aarohi includes an AI wellness companion powered by Apple Foundation Models (Apple Intelligence). This AI processes your questions and generates personalized insights entirely on your device. Your conversations with Aarohi AI are never sent to external servers, third-party AI services, or cloud APIs.")
                    
                    LegalCard(title: "6. No Third-Party Tracking", icon: "hand.raised.slash.fill", content: "Aarohi does not include any third-party analytics, tracking SDKs, advertising networks, crash reporting services, or social media tracking pixels.")
                    
                    LegalCard(title: "7. Data Deletion", icon: "trash.fill", content: "Since all data is stored locally on your device, you have full control at all times. You can use the \"Clear All Data\" option in the app's Settings to permanently erase all personal information, health logs, and preferences. Alternatively, deleting the app from your device will remove all associated data.")
                    
                    LegalCard(title: "8. No User Accounts", icon: "person.crop.circle.badge.xmark", content: "Aarohi does not require or support user accounts, sign-ups, or login credentials. There are no passwords to manage and no account data stored on any server.")
                    
                    Text("© 2026 Kamakshi Gupta. All rights reserved.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 16)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 26.0, *)
struct TermsOfServiceView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Terms of Service")
                            .font(.largeTitle.weight(.bold))
                        Text("Please read these terms carefully before using Aarohi.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    LegalCard(title: "1. Acceptance of Terms", icon: "checkmark.seal.fill", content: "By downloading, accessing, or using the Aarohi application (\"App\"), you agree to be bound by these Terms of Service (\"Terms\"). If you do not agree with any part of these Terms, you may not use the App.")
                    
                    LegalCard(title: "2. Medical Disclaimer", icon: "exclamationmark.triangle.fill", content: "⚠️ AAROHI IS NOT A MEDICAL DEVICE OR A SUBSTITUTE FOR PROFESSIONAL MEDICAL ADVICE.\nThe information, insights, and conversations provided by Aarohi are for educational and informational purposes only. They are not intended to diagnose, treat, cure, or prevent any disease or health condition. Never disregard professional medical advice or delay in seeking it because of something you have read, heard, or interacted with on this App.")
                    
                    LegalCard(title: "3. Aarohi AI Wellness Companion", icon: "brain.head.profile", content: "Aarohi includes an artificial intelligence companion powered by Apple Foundation Models (Apple Intelligence), which runs entirely on your device. While we strive for accuracy, AI systems can occasionally provide incomplete, inaccurate, or generalized information. You agree to use your own judgment and not rely solely on AI responses for medical decisions.")
                    
                    LegalCard(title: "4. Age Requirements", icon: "person.text.rectangle.fill", content: "Aarohi is designed for users aged 9 years and above. For users under the age of 13, we strongly recommend parental or guardian supervision while using the App.")
                    
                    LegalCard(title: "5. Free App — No In-App Purchases", icon: "gift.fill", content: "Aarohi is a completely free application with all features fully unlocked. There are no in-app purchases, subscriptions, paywalls, or advertisements.")
                    
                    LegalCard(title: "6. User Responsibilities", icon: "person.fill.checkmark", content: "You agree to use Aarohi only for lawful, personal wellness and educational purposes. You agree to provide accurate information about your age and life phase for the best experience, and not to attempt to reverse-engineer, modify, or distribute the App or its content.")
                    
                    LegalCard(title: "7. Data & Privacy", icon: "lock.shield.fill", content: "All your personal and health data is stored exclusively on your device. Aarohi does not require user accounts, does not collect data on external servers, and does not use third-party analytics or advertising.")
                    
                    LegalCard(title: "8. Intellectual Property", icon: "c.circle.fill", content: "The App, including its original content, features, interactive visualizations, illustrations, character designs, UI/UX design, and functionality, are owned by Aarohi and are protected by international copyright and trademark laws.")
                    
                    LegalCard(title: "9. Limitation of Liability", icon: "shield.slash.fill", content: "To the fullest extent permitted by law, Aarohi and its creator shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the App, including but not limited to health decisions made based on App content or AI responses.")
                    
                    Text("© 2026 Kamakshi Gupta. All rights reserved.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 16)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
