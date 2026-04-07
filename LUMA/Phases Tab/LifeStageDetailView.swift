import SwiftUI
import SwiftUI

struct LifeStageDetailView: View {
    
    let stage: LifeStage
    @State private var selectedCondition: StageCondition?
    
    var body: some View {
        
        ZStack {
            Color.lumaSurface
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    
                    heroSection
                    coreInformationSection
                    insightsSection
                    conditionsSection
                    
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
    }
}


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
                .foregroundColor(.lumaDarkGray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            
            Text(stage.description)
                .font(.subheadline)
                .foregroundColor(.lumaMidGray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}
private extension LifeStageDetailView {
    
    var coreInformationSection: some View {
        VStack(spacing: 20) {
            
            SectionCard(
                icon: "sparkles",
                title: "What’s common",
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

private extension LifeStageDetailView {
    
    var insightsSection: some View {
        VStack(spacing: 20) {
            
           
            
            if !stage.content.miniInsights.isEmpty {
                
                StandardListCard {
                    
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
                                            .foregroundColor(.lumaDarkGray)
                                        
                                        Text(insight.text)
                                            .font(.subheadline)
                                            .foregroundColor(.lumaMidGray)
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
            }
            
           
            
            if !stage.content.didYouKnow.isEmpty {
                
                StandardListCard {
                    
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
                                    .foregroundColor(.lumaDarkGray)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}
private extension LifeStageDetailView {
    
    var conditionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            if !stage.content.conditions.isEmpty {
                
                Text("Conditions to be aware of")
                    .font(.headline)
                    .foregroundColor(.lumaDarkGray)
                
                ForEach(stage.content.conditions) { condition in
                    
                    ConditionCard(condition: condition) {
                        selectedCondition = condition
                    }
                }
            }
        }
    }
}

struct StandardListCard<Content: View>: View {
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.lumaPinkLight.opacity(0.15))
        )
    }
}
