import SwiftUI

struct LifeStageDetailView: View {
  
  let stage: LifeStage
  @State private var selectedCondition: StageCondition?
  @State private var showStoryPlayer = false
  
  // Guided journey state
  @State private var revealedSections: Int = 0
  @State private var showGuideGreeting = true
  
  var body: some View {
    
    ZStack {
      LumaBackground()
        .ignoresSafeArea()
      
      ScrollView {
        VStack(spacing: 32) {
          
          // Luma Guide Greeting
          if showGuideGreeting {
            LumaGuideGreeting(stageName: stage.title)
              .transition(.scale.combined(with: .opacity))
          }
          
          heroSection
          
          // Story CTA — "Live the Story"button
          storyCTASection
          
          // Interactive checkpoint before core info
          CheckpointView(
            question: stageCheckpointQuestion,
            answer: stageCheckpointAnswer,
            style: .didYouKnow
          )
          .onDisappear {
            if revealedSections < 1 {
              withAnimation { revealedSections = 1 }
            }
          }
          
          // Core information with guided reveal
          GuidedSectionReveal(sectionIndex: 0, revealedUpTo: $revealedSections) {
            coreInformationSection
          }
          
          // Emoji reaction between sections
          if revealedSections >= 1 {
            EmojiReactionView(
              prompt: "How are you feeling about what you've learned so far?"
            ) { _ in
              withAnimation { revealedSections = max(revealedSections, 2) }
            }
            .onAppear {
              withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                revealedSections = max(revealedSections, 2)
              }
            }
          }
          
          // Quick knowledge check
          if revealedSections >= 2 {
            CheckpointView(
              question: stageQuickCheckQuestion,
              answer: stageQuickCheckAnswer,
              style: .trueFalse
            )
          }
          
          GuidedSectionReveal(sectionIndex: 2, revealedUpTo: $revealedSections) {
            insightsSection
          }
          
          // Luma speech bubble guide
          if revealedSections >= 2 {
            LumaSpeechBubble(
              text: stageLumaGuideMessage
            )
            .padding(.horizontal, 4)
            .onAppear {
              withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                revealedSections = max(revealedSections, 3)
              }
            }
          }
          
          GuidedSectionReveal(sectionIndex: 3, revealedUpTo: $revealedSections) {
            conditionsSection
          }
          
          // Journey Summary at the end
          if revealedSections >= 3 {
            JourneySummaryCard(
              stageName: stage.title,
              keyTakeaways: JourneyTakeaways.takeaways(for: stage)
            )
            .onAppear {
              showGuideGreeting = false
            }
          }
          
          Text("Every body experiences this stage differently.")
            .font(.caption)
            .foregroundColor(.lumaPinkBubble)
            .multilineTextAlignment(.center)
            .padding(.top)
        }
        .padding()
      }
    }
    .sheet(item: $selectedCondition) { condition in
      ConditionDetailSheet(condition: condition)
        .presentationDetents([.large])  
        .presentationDragIndicator(.visible)
    }
    .sheet(isPresented: $showStoryPlayer) {
      StoryPlayerView(stage: stage)
    }
    .onAppear {
      // Auto-unlock first section after a brief delay
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        withAnimation { revealedSections = max(revealedSections, 1) }
      }
    }
  }
}


// MARK: - Story CTA Section

private extension LifeStageDetailView {
  
  var storyCTASection: some View {
    Button {
      showStoryPlayer = true
    } label: {
      HStack(spacing: 14) {
        Image(systemName: "book.pages.fill")
          .font(.title2)
          .foregroundColor(.white)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Live the Story")
            .font(.subheadline.bold())
            .foregroundColor(.white)
          
          Text("Experience \(stage.title) through an interactive story")
            .font(.caption)
            .foregroundColor(.white.opacity(0.85))
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(.caption.bold())
          .foregroundColor(.white.opacity(0.7))
      }
      .padding(16)
      .background(
        LinearGradient(
          colors: [
            Color.lumaPinkBubble,
            Color.lumaAccent
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
      .shadow(color: Color.lumaPinkBubble.opacity(0.3), radius: 8, y: 4)
    }
    .buttonStyle(.plain)
  }
}


// MARK: - Hero Section

private extension LifeStageDetailView {
  
  var heroSection: some View {
    VStack(spacing: 18) {
      
      Image(stage.imageName)
        .resizable()
        .scaledToFit()
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: .infinity)
      
      Text(stage.title)
        .font(.title.bold())
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
      
      Text(stage.description)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 8)
  }
}


// MARK: - Core Information Section

private extension LifeStageDetailView {
  
  var coreInformationSection: some View {
    VStack(spacing: 20) {
      
      SectionCard(
        icon: "sparkles",
        title: "What's common",
        text: stage.content.commonInfo,
        background: Color.blue.opacity(0.06)
      )
      
      SectionCard(
        icon: "waveform.path.ecg",
        title: "Hormones at work",
        text: stage.content.hormoneInfo,
        background: Color.purple.opacity(0.10)
      )
      
      SectionCard(
        icon: "exclamationmark.circle",
        title: "Common concerns",
        text: stage.content.concerns,
        background: Color.orange.opacity(0.10)
      )
      
      SectionCard(
        icon: "leaf",
        title: "Gentle care tips",
        text: stage.content.careTips,
        background: Color.green.opacity(0.10)
      )
    }
  }
}


// MARK: - Insights Section

private extension LifeStageDetailView {
  
  var insightsSection: some View {
    VStack(spacing: 20) {
      
      if !stage.content.miniInsights.isEmpty {
        
        VStack(alignment: .leading, spacing: 20) {
          
          SectionHeader(title: "Helpful Insights", icon: "sparkles")
          
          VStack(alignment: .leading, spacing: 16) {
            
            ForEach(stage.content.miniInsights) { insight in
              
              VStack(alignment: .leading, spacing: 8) {
                
                HStack(alignment: .top, spacing: 10) {
                  
                  Image(systemName: "sparkle")
                    .foregroundColor(.lumaPinkBubble)
                    .font(.system(size: 14))
                    .padding(.top, 4)
                  
                  VStack(alignment: .leading, spacing: 4) {
                    
                    Text(insight.title)
                      .font(.subheadline.bold())
                      .foregroundColor(.primary)
                    
                    Text(insight.text)
                      .font(.subheadline)
                      .foregroundColor(.secondary)
                  }
                }
                
                if insight.id != stage.content.miniInsights.last?.id {
                  Rectangle()
                    .fill(Color.lumaDarkGray.opacity(0.18))
                    .frame(height: 1)
                }
              }
            }
          }
        }
        .padding()
        .liquidGlass(cornerRadius: 20)
      }
      
      if !stage.content.didYouKnow.isEmpty {
        
        VStack(alignment: .leading, spacing: 20) {
          
          SectionHeader(title: "Did You Know?", icon: "lightbulb")
          
          VStack(alignment: .leading, spacing: 14) {
            
            ForEach(stage.content.didYouKnow, id: \.self) { fact in
              
              HStack(alignment: .top, spacing: 10) {
                
                Image(systemName: "circle.fill")
                  .font(.system(size: 6))
                  .foregroundColor(.lumaPinkBubble)
                  .padding(.top, 6)
                
                Text(fact)
                  .font(.subheadline)
                  .foregroundColor(.primary)
              }
            }
          }
        }
        .padding()
        .liquidGlass(cornerRadius: 20)
      }
    }
    .padding(.top, 8)
  }
}


// MARK: - Conditions Section

private extension LifeStageDetailView {
  
  var conditionsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      
      if !stage.content.conditions.isEmpty {
        
        Text("Conditions to be aware of")
          .font(.headline)
          .foregroundColor(.primary)
        
        ForEach(stage.content.conditions) { condition in
          
          ConditionCard(condition: condition) {
            selectedCondition = condition
          }
        }
      }
    }
  }
}


// MARK: - Stage-Specific Checkpoint Content

private extension LifeStageDetailView {
  
  var stageCheckpointQuestion: String {
    switch stage {
    case .prePuberty:
      return "Did you know that hormonal changes begin years before the first period appears?"
    case .puberty:
      return "Did you know it can take 2-3 years after your first period for cycles to become regular?"
    case .reproductive:
      return "Did you know that a \"normal\"cycle can be anywhere from 21 to 35 days?"
    case .perimenopause:
      return "Did you know perimenopause can last 4-10 years before menopause begins?"
    case .menopause:
      return "Did you know menopause is only confirmed after 12 consecutive months without a period?"
    case .postMenopause:
      return "Did you know that bone density loss accelerates after menopause due to lower estrogen?"
    }
  }
  
  var stageCheckpointAnswer: String {
    switch stage {
    case .prePuberty:
      return "The hypothalamus starts sending signals to the pituitary gland well before any visible changes. Breast buds and vaginal discharge are often the first signs."
    case .puberty:
      return "The hypothalamic-pituitary-ovarian (HPO) axis needs time to mature. Early cycles are often anovulatory (no egg released), which is why timing varies."
    case .reproductive:
      return "The 28-day cycle is a myth! Cycle length varies person to person. What matters most is consistency in your own pattern."
    case .perimenopause:
      return "Estrogen fluctuates unpredictably during this time, causing symptoms like hot flashes, mood shifts, and irregular cycles well before periods actually stop."
    case .menopause:
      return "Before reaching this milestone, the body gradually reduces estrogen production. Symptoms like hot flashes and mood changes may continue even after periods stop."
    case .postMenopause:
      return "Estrogen plays a key role in maintaining bone density. After menopause, weight-bearing exercise, calcium, and vitamin D become especially important."
    }
  }
  
  var stageQuickCheckQuestion: String {
    switch stage {
    case .prePuberty:
      return "True or False: Learning about body changes early causes unnecessary anxiety."
    case .puberty:
      return "True or False: Exercise during your period makes cramps worse."
    case .reproductive:
      return "True or False: Stress cannot physically affect your menstrual cycle."
    case .perimenopause:
      return "True or False: Once perimenopause starts, you can no longer get pregnant."
    case .menopause:
      return "True or False: All symptoms disappear immediately once menopause is reached."
    case .postMenopause:
      return "True or False: Any vaginal bleeding after menopause is completely normal."
    }
  }
  
  var stageQuickCheckAnswer: String {
    switch stage {
    case .prePuberty:
      return "False! Research shows that age-appropriate education actually reduces anxiety and helps children feel more prepared and confident about their changing bodies."
    case .puberty:
      return "False! Light to moderate exercise actually helps reduce cramps by releasing endorphins — your body's natural painkillers."
    case .reproductive:
      return "False! Stress triggers cortisol release, which can suppress GnRH and delay or prevent ovulation, directly affecting your cycle."
    case .perimenopause:
      return "False! Ovulation can still occur sporadically during perimenopause. Contraception should be discussed with a healthcare provider."
    case .menopause:
      return "False! Hormonal adjustments continue after periods stop. Some symptoms like hot flashes and mood changes can persist for years."
    case .postMenopause:
      return "False! Any bleeding after menopause should always be evaluated by a healthcare provider to rule out potential concerns."
    }
  }
  
  var stageLumaGuideMessage: String {
    switch stage {
    case .prePuberty:
      return "Remember, every body grows at its own pace. These changes are your body preparing for an amazing journey ahead! "
    case .puberty:
      return "Puberty can feel overwhelming, but you're not alone. Understanding what's happening gives you power over your experience. "
    case .reproductive:
      return "Your cycle is like a monthly health report card. Learning to read it is one of the most empowering things you can do! "
    case .perimenopause:
      return "This transition is natural and temporary. Your body is finding a new balance — and you have tools to support it every step of the way. "
    case .menopause:
      return "Menopause isn't an ending — it's a powerful new chapter. Many women report feeling more confident and free during this time. "
    case .postMenopause:
      return "Your body has carried you through incredible changes. Now it's time to nurture it with the care and attention it deserves. "
    }
  }
}
