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
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                
                Text("Your health data is yours. We protect it fiercely.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("""
**1. Introduction**
At Aarohi ("we", "our", or "us"), your privacy is our highest priority. As a women's health and wellness application, we understand the incredibly sensitive nature of the information you track. We have built Aarohi with strict privacy-by-design principles — your data stays on your device, always.

**2. Data We Collect**
To provide you with personalized insights, we collect the following data — all stored locally on your device only:
• Profile Information: Your name, age, selected avatar, and current life phase — used solely for personalized greetings and content.
• Health & Symptom Logs: Mood, menstrual flow, pain levels, energy levels, stress, and sleep hours that you explicitly choose to log.
• App Preferences: Notification settings, daily reminder preferences, onboarding status, and challenge streak data.

**3. Data We Do NOT Collect**
Because of the sensitive nature of female health tracking, we have a strict policy. We do not collect, store, or have access to:
• Email addresses, phone numbers, or contact information
• Location or GPS data
• Photos, camera, or microphone data
• Device identifiers (IDFA) or advertising data
• Financial or payment data
• Contacts or social media data
• Apple HealthKit data

**4. No Cloud Storage — Everything Stays on Your Device**
Aarohi stores all your personal and health data exclusively on your device using local storage (UserDefaults and SwiftData). We do not use any cloud databases, remote servers, or third-party storage services. Your data never leaves your iPhone.

**5. AI Features — On-Device Processing**
Aarohi includes an AI wellness companion powered by Apple Foundation Models (Apple Intelligence). This AI processes your questions and generates personalized insights entirely on your device. Your conversations with Aarohi AI are never sent to external servers, third-party AI services, or cloud APIs.

**6. Network Requests**
Aarohi makes a single, read-only network request to fetch updated health knowledge content (medical condition information) from our public repository. No personal or health data is sent during this request — it is a one-way download of educational content only.

**7. No Third-Party Tracking or Advertising**
Aarohi does not include any third-party analytics, tracking SDKs, advertising networks, crash reporting services, or social media tracking pixels.

**8. Local Notifications**
If you opt in during onboarding or in Settings, Aarohi sends local push notifications (daily reminders, myth teasers, streak alerts, and phase-specific check-ins). These notifications are generated and scheduled entirely on your device.

**9. Children's Privacy**
Aarohi is designed for users aged 9 and above, as it covers all life stages starting from Pre-Puberty. For users under 13, we recommend parental guidance. All data remains local on the device, and we do not collect any personal information from children (or any user) on our servers.

**10. Data Deletion**
Since all data is stored locally on your device, you have full control at all times. You can use the "Clear All Data" option in the app's Settings to permanently erase all personal information, health logs, and preferences. Alternatively, deleting the app from your device will remove all associated data.

**11. No User Accounts**
Aarohi does not require or support user accounts, sign-ups, or login credentials. There are no passwords to manage and no account data stored on any server.

**12. Data We Do NOT Sell**
We do not sell, share, rent, or trade your personal or health data to any third parties, data brokers, advertisers, or any other entities — period.

**13. Changes to This Policy**
We may update this Privacy Policy from time to time. We encourage you to review this page periodically.

**14. Contact Us**
If you have any questions about this Privacy Policy, please contact us at kamakshiig21@gmail.com.
""")
                .font(.body)
                
                Text("© 2026 Kamakshi Gupta. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 26.0, *)
struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms of Service")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                
                Text("Please read these terms carefully before using Aarohi.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("""
**1. Acceptance of Terms**
By downloading, accessing, or using the Aarohi application ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree with any part of these Terms, you may not use the App.

**2. Medical Disclaimer**
⚠️ **AAROHI IS NOT A MEDICAL DEVICE OR A SUBSTITUTE FOR PROFESSIONAL MEDICAL ADVICE.**
The information, insights, and conversations provided by Aarohi — including the AI wellness companion, Body Map, Phase Simulator, Symptom Tracker, and all educational content — are for educational and informational purposes only. They are not intended to diagnose, treat, cure, or prevent any disease or health condition. Never disregard professional medical advice or delay in seeking it because of something you have read, heard, or interacted with on this App. Always consult with a qualified healthcare provider regarding any medical condition, symptoms, or treatment.

**3. Aarohi AI Wellness Companion**
Aarohi includes an artificial intelligence companion powered by Apple Foundation Models (Apple Intelligence), which runs entirely on your device. While we strive for accuracy, AI systems can occasionally provide incomplete, inaccurate, or generalized information. You agree to use your own judgment, verify critical health information with a professional, and not rely solely on AI responses for medical decisions.

**4. Age Requirements**
Aarohi is designed for users aged 9 years and above. For users under the age of 13, we strongly recommend parental or guardian supervision while using the App. By using the App, you confirm that you meet the minimum age requirement or have obtained parental consent.

**5. Free App — No In-App Purchases**
Aarohi is a completely free application with all features fully unlocked. There are no in-app purchases, subscriptions, paywalls, or advertisements. All content and features are accessible without any payment.

**6. User Responsibilities**
You agree to use Aarohi only for lawful, personal wellness and educational purposes. You agree to provide accurate information about your age and life phase for the best experience, and not to attempt to reverse-engineer, modify, or distribute the App or its content. You also agree not to use the App's content to provide medical advice to others.

**7. Data & Privacy**
All your personal and health data is stored exclusively on your device. Aarohi does not require user accounts, does not collect data on external servers, and does not use third-party analytics or advertising.

**8. Health Content Accuracy**
While all health content in Aarohi has been carefully researched and curated, it is intended for general educational purposes. Individual health experiences may vary, and content may not apply to every user's specific situation.

**9. Intellectual Property**
The App, including its original content, features, interactive visualizations (Body Map, Phase Simulator, organ simulations), illustrations, character designs, UI/UX design, and functionality, are owned by Aarohi and are protected by international copyright and trademark laws. You may not reproduce, distribute, or create derivative works without our prior written consent.

**10. Limitation of Liability**
To the fullest extent permitted by law, Aarohi and its creator shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the App, including but not limited to health decisions made based on App content or AI responses.

**11. Modifications to the App and Terms**
We reserve the right to modify, update, or discontinue the App or these Terms at any time. Continued use of the App after changes constitutes acceptance of the updated Terms. We encourage you to review these Terms periodically.

**12. Governing Law**
These Terms shall be governed by and construed in accordance with the laws of India, without regard to its conflict of law provisions.

**13. Contact Us**
For questions about these Terms, please contact us at kamakshiig21@gmail.com.
""")
                .font(.body)
                
                Text("© 2026 Kamakshi Gupta. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}
