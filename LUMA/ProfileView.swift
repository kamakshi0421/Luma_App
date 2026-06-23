import SwiftUI

@available(iOS 26.0, *)
struct ProfileView: View {
    
    // MARK: - Stored Properties
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_age") private var userAge: Int = 25
    @AppStorage("selectedStage") private var selectedStageRaw: String = LifeStage.reproductive.rawValue
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    @AppStorage("currentStreak") private var currentStreak: Int = 0
    @AppStorage("longestStreak") private var longestStreak: Int = 0
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("dailyReminderEnabled") private var dailyReminderEnabled = false
    @AppStorage("user_avatar") private var userAvatar: String = "person.crop.circle.fill"
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var showResetAlert = false
    @State private var showClearDataAlert = false
    @State private var phaseOverridden = false
    @State private var showingAvatarPicker = false
    
    private var currentStage: LifeStage {
        LifeStage(rawValue: selectedStageRaw) ?? .reproductive
    }
    
    // Beautiful abstract/nature options for women's profile avatars
    private let avatarOptions = [
        "person.crop.circle.fill", "person.circle.fill", "face.smiling.fill",
        "moon.stars.circle.fill", "sparkles", "heart.circle.fill", 
        "star.circle.fill", "leaf.circle.fill", "sun.max.circle.fill"
    ]
    
    // MARK: - Body
    var body: some View {
        Form {
            // ── Section 1: Profile & Avatar ──
            Section {
                VStack(spacing: 20) {
                    // Avatar Button
                    Button {
                        showingAvatarPicker = true
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: userAvatar)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundStyle(
                                    LinearGradient(colors: [Color.lumaPinkLight, Color.lumaPinkDark], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .shadow(color: Color.lumaPinkLight.opacity(0.3), radius: 10, y: 4)
                            
                            // Edit Badge
                            Image(systemName: "pencil.circle.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .background(Color.lumaAccent)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color(.systemGroupedBackground), lineWidth: 2))
                                .offset(x: 0, y: 0)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 10)
                    
                    // Name Edit (Native iOS Style)
                    HStack(alignment: .center, spacing: 6) {
                        TextField("Your Name", text: $userName)
                            .font(.title2.weight(.bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .submitLabel(.done)
                            .autocorrectionDisabled()
                            .fixedSize() // Keeps the text field hugging the text
                        
                        Image(systemName: "pencil")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: 280)
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .listRowBackground(Color.clear)
            
            // ── Section 2: Phase & Age ──
            Section(header: Text("My Phase & Age")) {
                Stepper("Age: \(userAge)", value: $userAge, in: 9...70)
                    .onChange(of: userAge) { _, _ in
                        syncPhaseFromAge()
                    }
                
                Picker("Life Phase", selection: $selectedStageRaw) {
                    ForEach(LifeStage.allCases) { stage in
                        Text(stage.title).tag(stage.rawValue)
                    }
                }
                .onChange(of: selectedStageRaw) { _, _ in
                    phaseOverridden = true
                }
            }
            
            // ── Section 3: Journey Stats ──
            Section(header: Text("Journey Stats")) {
                HStack {
                    Label("Current Streak", systemImage: "flame.fill")
                        .foregroundColor(.orange)
                    Spacer()
                    Text("\(currentStreak)")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Longest Streak", systemImage: "trophy.fill")
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("\(longestStreak)")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Phase Progress", systemImage: "chart.bar.fill")
                        .foregroundColor(.lumaAccent)
                    Spacer()
                    Text("\(currentStage.order + 1)/6")
                        .foregroundColor(.secondary)
                }
            }
            
            // ── Section 4: Preferences ──
            Section(header: Text("Preferences")) {
                Toggle(isOn: $notificationsEnabled) {
                    Label("Notifications", systemImage: "bell.badge.fill")
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
                    Label("Daily Reminders", systemImage: "calendar.badge.clock")
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
            
            // ── Section 5: About Aarohi ──
            Section(header: Text("About Aarohi")) {
                HStack {
                    Label("Version", systemImage: "app.badge.fill")
                    Spacer()
                    Text("1.0.0").foregroundColor(.secondary)
                }
                Button(action: {}) {
                    Label("Rate Us", systemImage: "star.fill")
                        .foregroundColor(.primary)
                }
                Button(action: shareApp) {
                    Label("Share App", systemImage: "square.and.arrow.up.fill")
                        .foregroundColor(.primary)
                }
                Button(action: {}) {
                    Label("Privacy Policy", systemImage: "lock.shield.fill")
                        .foregroundColor(.primary)
                }
            }
            
            // ── Section 6: Danger Zone ──
            Section {
                Button(role: .destructive, action: { showResetAlert = true }) {
                    Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
                }
                Button(role: .destructive, action: { showClearDataAlert = true }) {
                    Label("Clear All Data", systemImage: "trash.fill")
                }
            }
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        // Background color
        .background(Color(.systemGroupedBackground))
        // Alerts
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
        .sheet(isPresented: $showingAvatarPicker) {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                        ForEach(avatarOptions, id: \.self) { avatar in
                            Button {
                                userAvatar = avatar
                                showingAvatarPicker = false
                            } label: {
                                Image(systemName: avatar)
                                    .font(.system(size: 36))
                                    .foregroundColor(userAvatar == avatar ? .white : .lumaAccent)
                                    .frame(width: 80, height: 80)
                                    .background(userAvatar == avatar ? Color.lumaAccent : Color.lumaAccent.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(24)
                }
                .navigationTitle("Choose Avatar")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { showingAvatarPicker = false }
                            .fontWeight(.semibold)
                            .foregroundColor(.lumaAccent)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    // MARK: - Helpers
    private func syncPhaseFromAge() {
        if !phaseOverridden {
            let suggestedStage = LifeStage.stage(for: userAge)
            withAnimation(.spring(response: 0.3)) {
                selectedStageRaw = suggestedStage.rawValue
            }
        }
    }
    
    private func shareApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let shareText = "Check out Aarohi — a beautiful women's health app that guides you through every life stage! 🌸"
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
        phaseOverridden = false
        userAvatar = "person.crop.circle.fill"
    }
}
