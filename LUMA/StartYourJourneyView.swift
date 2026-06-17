import SwiftUI

struct StartYourJourneyView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @AppStorage("selectedStage") private var selectedStageRaw: String = LifeStage.reproductive.rawValue
    @AppStorage("userName") private var userName: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPage = 0
    
    // Page 2 State
    @State private var nameInput: String = ""
    
    // Page 3 State
    @State private var selectedGoals: Set<String> = []
    let goals = [
        "Track my symptoms",
        "Understand my body changes",
        "Get personalized daily tips",
        "Learn about women's health"
    ]
    
    // Page 4 State
    @State private var age: Int = 18
    @State private var suggestedStage: LifeStage = .reproductive
    @State private var selectedStage: LifeStage = .reproductive
    
    var body: some View {
        ZStack {
            LumaGradient.primary.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                welcomePage
                    .tag(0)
                namePage
                    .tag(1)
                goalsPage
                    .tag(2)
                phasePage
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
        }
        .onAppear {
            suggestedStage = LifeStage.stage(for: age)
            selectedStage = suggestedStage
            nameInput = userName // in case they came back
        }
        .onChange(of: age) { _, newValue in
            suggestedStage = LifeStage.stage(for: newValue)
            selectedStage = suggestedStage
        }
    }
    
    // MARK: - Welcome Page
    private var welcomePage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image("ProfileAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(color: .black.opacity(0.15), radius: 15, y: 8)
            
            VStack(spacing: 12) {
                Text("Welcome to Aarohi")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your personal companion for every stage of your journey.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            nextButton(title: "Let's Begin") {
                currentPage += 1
            }
        }
    }
    
    // MARK: - Name Page
    private var namePage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What should we call you?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                TextField("Your name", text: $nameInput)
                    .font(.title2)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .tint(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            HStack(spacing: 16) {
                backButton { currentPage -= 1 }
                nextButton(title: "Continue") {
                    if !nameInput.isEmpty {
                        userName = nameInput
                    }
                    currentPage += 1
                }
            }
        }
    }
    
    // MARK: - Goals Page
    private var goalsPage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What are your goals?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Select all that apply")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                VStack(spacing: 12) {
                    ForEach(goals, id: \.self) { goal in
                        Button {
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        } label: {
                            HStack {
                                Text(goal)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedGoals.contains(goal) ? Color.lumaAccent : .white)
                                
                                Spacer()
                                
                                if selectedGoals.contains(goal) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.lumaAccent)
                                        .font(.title3)
                                } else {
                                    Circle()
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                                        .frame(width: 22, height: 22)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedGoals.contains(goal) ? Color.white : Color.white.opacity(0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedGoals.contains(goal) ? Color.white : Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            HStack(spacing: 16) {
                backButton { currentPage -= 1 }
                nextButton(title: "Continue") {
                    currentPage += 1
                }
            }
        }
    }
    
    // MARK: - Phase Page
    private var phasePage: some View {
        VStack(spacing: 28) {
            
            Spacer()
            
            Text("Let's personalize your experience.")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            VStack(spacing: 24) {
                // Age selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("How old are you?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Stepper(value: $age, in: 9...70) {
                        Text("\(age) years")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                    .colorScheme(.dark)
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(16)
                
                // Suggested Phase
                VStack(alignment: .leading, spacing: 8) {
                    Text("Based on your age, you may be in:")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(suggestedStage.title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(16)
                
                // Manual Phase Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Adjust if needed:")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(LifeStage.allCases, id: \.self) { stage in
                                Button {
                                    withAnimation(.spring()) {
                                        selectedStage = stage
                                    }
                                } label: {
                                    Text(stage.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(selectedStage == stage ? Color.lumaAccent : .white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(selectedStage == stage ? Color.white : Color.white.opacity(0.15))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            HStack(spacing: 16) {
                backButton { currentPage -= 1 }
                
                Button {
                    completeOnboarding()
                } label: {
                    Text("Confirm & Continue")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.lumaAccent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                }
                .padding(.trailing, 32)
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Helpers
    private func completeOnboarding() {
        if !nameInput.isEmpty {
            userName = nameInput
        }
        selectedStageRaw = selectedStage.rawValue
        hasSeenOnboarding = true
        dismiss()
    }
    
    private func nextButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.lumaAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.white)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 20)
    }
    
    private func backButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
        }
        .padding(.leading, 32)
        .padding(.bottom, 20)
    }
}
