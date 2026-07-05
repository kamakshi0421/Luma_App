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
        .liquidGlass(cornerRadius: 22)
    }
}

@available(iOS 26.0, *)
struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            LumaBackground()
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
                    
                    LegalCard(title: "1. Data Storage", icon: "icloud.slash.fill", content: "All your personal and health data is strictly stored on your device. We do not use cloud storage or databases.")
                    
                    LegalCard(title: "2. What We Collect", icon: "list.clipboard.fill", content: "We only collect profile info, symptoms, and preferences locally. No emails, phone numbers, or contacts are accessed.")
                    
                    LegalCard(title: "3. AI Features", icon: "cpu", content: "Our AI wellness companion runs entirely on-device for maximum privacy. Your conversations are never sent to external servers.")
                    
                    LegalCard(title: "4. Third Parties", icon: "hand.raised.slash.fill", content: "We do not sell your data, nor do we use third-party trackers or ads. You have full control to delete your data at any time.")
                    
                    Link(destination: URL(string: "https://aarohiapp.vercel.app")!) {
                        Label("Visit our Official Website", systemImage: "globe")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.lumaAccent)
                    .controlSize(.large)
                    .padding(.vertical, 8)
                    
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
            LumaBackground()
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
                    
                    LegalCard(title: "1. Medical Disclaimer", icon: "exclamationmark.triangle.fill", content: "⚠️ Aarohi is NOT a medical device. It's for educational purposes. Consult a doctor for medical advice.")
                    
                    LegalCard(title: "2. Usage", icon: "person.text.rectangle.fill", content: "Aarohi is completely free with no in-app purchases. It's designed for users aged 9 and above.")
                    
                    LegalCard(title: "3. AI Companion", icon: "brain.head.profile", content: "AI can occasionally be inaccurate; use your judgment and do not rely solely on AI for medical decisions.")
                    
                    LegalCard(title: "4. Privacy & IP", icon: "lock.shield.fill", content: "Your data stays with you. All app content, illustrations, and designs are copyrighted and owned by Aarohi.")
                    
                    Link(destination: URL(string: "https://aarohiapp.vercel.app")!) {
                        Label("Visit our Official Website", systemImage: "globe")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.lumaAccent)
                    .controlSize(.large)
                    .padding(.vertical, 8)
                    
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
