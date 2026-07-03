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
                  Color.lumaPinkBubble
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
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
      }
      .listRowBackground(Color.clear)
      
      // ── Section 2: Personal Details ──
      Section(header: Text("Name")) {
        TextField("Your Name", text: $userName)
          .submitLabel(.done)
          .autocorrectionDisabled()
      }
      
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
          Image(systemName: "flame.fill")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
          
          Text("Current Streak")
            .foregroundColor(.primary)
          Spacer()
          Text("\(currentStreak)")
            .foregroundColor(.secondary)
        }
        
        HStack {
          Image(systemName: "trophy.fill")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(Color.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
          
          Text("Longest Streak")
            .foregroundColor(.primary)
          Spacer()
          Text("\(longestStreak)")
            .foregroundColor(.secondary)
        }
        
        HStack {
          Image(systemName: "chart.bar.fill")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(Color.pink)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
          
          Text("Phase Progress")
            .foregroundColor(.primary)
          Spacer()
          Text("\(currentStage.order + 1)/6")
            .foregroundColor(.secondary)
        }
      }
    }
    .navigationTitle("My Profile")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color(.systemGroupedBackground))
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink(destination: SettingsView()) {
          Image(systemName: "gearshape.fill")
            .foregroundColor(.secondary)
        }
      }
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
}
