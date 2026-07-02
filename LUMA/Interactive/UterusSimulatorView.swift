import SwiftUI
import SpriteKit

enum OrganSystem: String, CaseIterable, Identifiable {
  case reproductive = "Uterus"
  case endocrine = "Brain"
  case skeletal = "Bones"
  case breasts = "Breasts"
  var id: String { rawValue }
}

struct UterusSimulatorView: View {
  @State private var selectedStage: LifeStage = .reproductive
  @State private var selectedCondition: UterusCondition = .normal
  @State private var selectedSystem: OrganSystem = .reproductive
  
  // For Navigation Screen
  @State private var selectedOrganName: String = "Uterus"
  @State private var isSheetPresented = false
  @State private var organConditionContext: UterusCondition = .normal
  
  @AppStorage("hideGlobalFAB") private var hideGlobalFAB: Bool = false
  
  @State private var uterusScene: UterusScene = { let s = UterusScene(); s.scaleMode = .resizeFill; return s }()
  @State private var brainScene: BrainScene = { let s = BrainScene(); s.scaleMode = .resizeFill; return s }()
  @State private var boneScene: BoneScene = { let s = BoneScene(); s.scaleMode = .resizeFill; return s }()
  @State private var breastScene: BreastScene = { let s = BreastScene(); s.scaleMode = .resizeFill; return s }()
  
  var filteredConditions: [UterusCondition] {
    var baseConditions: [UterusCondition] = [.normal]
    
    switch selectedSystem {
    case .reproductive:
      switch selectedStage {
      case .prePuberty: baseConditions = [.normal]
      case .puberty: baseConditions = [.normal, .menarche, .pcos]
      case .reproductive: baseConditions = [.normal, .menstruation, .pcos, .endometriosis, .fibroids]
      case .perimenopause: baseConditions = [.normal, .irregular, .fibroids]
      case .menopause, .postMenopause: baseConditions = [.normal, .atrophy]
      }
    case .endocrine:
      switch selectedStage {
      case .menopause, .postMenopause: baseConditions = [.normal, .atrophy]
      default: baseConditions = [.normal]
      }
    case .skeletal:
      switch selectedStage {
      case .menopause, .postMenopause: baseConditions = [.normal, .atrophy]
      default: baseConditions = [.normal]
      }
    case .breasts:
      switch selectedStage {
      case .reproductive: baseConditions = [.normal, .menstruation]
      case .menopause, .postMenopause: baseConditions = [.normal, .atrophy]
      default: baseConditions = [.normal]
      }
    }
    return baseConditions
  }
  
  let allStages: [LifeStage] = [.prePuberty, .puberty, .reproductive, .perimenopause, .menopause, .postMenopause]
  
  var body: some View {
    ZStack {
      LumaBackground()
      
      VStack(spacing: 0) {
        // Sleek Header
        VStack(spacing: 4) {
          Text("Phase Simulator")
            .font(.title2.bold())
            .foregroundColor(.primary)
          
          Text("Explore how your body evolves")
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
        
        // 1. Sleek Phase Text Tabs (Dark mode compatible)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 24) {
            ForEach(allStages, id: \.self) { stage in
              VStack(spacing: 6) {
                Text(stage.title)
                  .font(.subheadline.weight(selectedStage == stage ? .bold : .medium))
                  .foregroundColor(selectedStage == stage ? .primary : .secondary)
                
                // Active Underline Indicator
                Rectangle()
                  .fill(selectedStage == stage ? Color.pink.opacity(0.4) : Color.clear)
                  .frame(height: 3)
                  .clipShape(RoundedRectangle(cornerRadius: 1, style: .continuous))
              }
              .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                  selectedStage = stage
                  if !filteredConditions.contains(selectedCondition) {
                    updateCondition(.normal)
                  }
                }
              }
            }
          }
          .padding(.horizontal, 24)
        }
        .padding(.bottom, 20)
        
        // 2. Elegant System Selector Grid (Dynamic background)
        HStack(spacing: 16) {
          ForEach(OrganSystem.allCases) { sys in
            Button {
              withAnimation(.spring()) {
                selectedSystem = sys
                if !filteredConditions.contains(selectedCondition) {
                  updateCondition(.normal)
                }
              }
            } label: {
              VStack(spacing: 6) {
                Image(systemName: sysIcon(sys))
                  .font(.title3)
                Text(sys.rawValue)
                  .font(.caption2.bold())
              }
              .foregroundColor(selectedSystem == sys ? .primary : .secondary)
              .frame(width: 75, height: 70)
              .background(
                Group {
                  if selectedSystem == sys {
                    RoundedRectangle(cornerRadius: 16)
                      .fill(AnyShapeStyle(Color.pink.opacity(0.15)))
                  } else {
                    RoundedRectangle(cornerRadius: 16)
                      .fill(Color.clear)
                  }
                }
              )
              .liquidGlass(cornerRadius: 16)
              .shadow(color: .clear, radius: 8, y: 4)
            }
          }
        }
        .padding(.bottom, 20)
        
        // 3. SpriteKit Scene inside a Premium Glass Frame
        Group {
          switch selectedSystem {
          case .reproductive:
            SpriteView(scene: uterusScene, options: [.allowsTransparency])
          case .endocrine:
            SpriteView(scene: brainScene, options: [.allowsTransparency])
          case .skeletal:
            SpriteView(scene: boneScene, options: [.allowsTransparency])
          case .breasts:
            SpriteView(scene: breastScene, options: [.allowsTransparency])
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 24)
        .frame(height: 300)
        .liquidGlass(cornerRadius: 32)
        .padding(.horizontal, 16)
        
        // Active Condition Minimal Info Label
        VStack(spacing: 2) {
          Text("Active Condition")
            .font(.caption)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
          Text(selectedCondition.rawValue)
            .font(.headline.weight(.heavy))
            .foregroundColor(.primary)
        }
        .padding(.top, 16)
        
        Spacer()
        
        // 4. Condition Picker Cards (Dynamic background)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
            ForEach(filteredConditions) { condition in
              Button {
                withAnimation(.spring()) { updateCondition(condition) }
              } label: {
                VStack(alignment: .leading, spacing: 6) {
                  Text(condition.rawValue)
                    .font(.subheadline.bold())
                    .foregroundColor(selectedCondition == condition ? .primary : .secondary)
                  
                  if selectedCondition == condition {
                    Text("Selected")
                      .font(.caption2)
                      .foregroundColor(.secondary)
                  }
                }
                .padding()
                .frame(width: 140, alignment: .leading)
                .background(
                  Group {
                    if selectedCondition == condition {
                      RoundedRectangle(cornerRadius: 20)
                        .fill(AnyShapeStyle(Color.pink.opacity(0.15)))
                    } else {
                      RoundedRectangle(cornerRadius: 20)
                        .fill(Color.clear)
                    }
                  }
                )
                .liquidGlass(cornerRadius: 20)
                .shadow(color: .clear, radius: 8, y: 4)
              }
            }
          }
          .padding(.horizontal, 24)
          .padding(.bottom, 40)
        }
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      hideGlobalFAB = true // Hide global Ask Aarohi button
      
      let handleTap: (String, UterusCondition) -> Void = { organName, condition in
        self.organConditionContext = condition
        self.selectedOrganName = organName
        self.isSheetPresented = true // Triggers sheet below
      }
      
      uterusScene.organTapped = handleTap
      brainScene.organTapped = handleTap
      boneScene.organTapped = handleTap
      breastScene.organTapped = handleTap
      
      updateCondition(selectedCondition)
    }
    .onDisappear {
      hideGlobalFAB = false // Restore global Ask Aarohi button
    }
    // Bottom sheet for Organ Info
    .sheet(isPresented: $isSheetPresented) {
      PremiumOrganInfoSheet(organName: selectedOrganName, condition: organConditionContext)
        .presentationDetents([.fraction(0.55), .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
    }
  }
  
  private func sysIcon(_ sys: OrganSystem) -> String {
    switch sys {
    case .reproductive: return "drop.fill"
    case .endocrine: return "brain.head.profile"
    case .skeletal: return "figure.stand"
    case .breasts: return "heart.circle.fill"
    }
  }
  
  private func updateCondition(_ condition: UterusCondition) {
    selectedCondition = condition
    uterusScene.currentCondition = condition
    brainScene.currentCondition = condition
    boneScene.currentCondition = condition
    breastScene.currentCondition = condition
  }
}

// MARK: - Premium Organ Info Sheet (Adaptive Dark Mode)

struct PremiumOrganInfoSheet: View {
  let organName: String
  let condition: UterusCondition
  
  var icon: String {
    switch organName {
    case "Uterus": return "heart.text.square.fill"
    case "Left Ovary", "Right Ovary": return "aqi.medium"
    case "Brain", "Hypothalamus": return "brain.head.profile"
    case "Bones": return "figure.stand"
    case "Breasts": return "heart.circle.fill"
    default: return "info.circle.fill"
    }
  }
  
  var function: String {
    switch organName {
    case "Uterus": return "The uterus is an incredibly strong, muscular organ. It nourishes and houses a fertilized egg until the fetus is ready for birth."
    case "Left Ovary", "Right Ovary": return "The ovaries are small, almond-shaped glands that store eggs and produce the essential hormones estrogen and progesterone."
    case "Brain": return "The brain controls your entire endocrine system. It reads hormone levels and adjusts them accordingly."
    case "Hypothalamus": return "The hypothalamus acts as your body's smart thermostat and control center. It tells the pituitary gland to release hormones that control your menstrual cycle."
    case "Bones": return "Your skeletal system provides structure. Estrogen plays a massive role in protecting bone density and preventing breakdown."
    case "Breasts": return "The breasts contain glandular tissue. They respond directly to the estrogen and progesterone fluctuations in your cycle."
    default: return ""
    }
  }
  
  var contextualInsight: String? {
    if condition == .normal { return nil }
    
    switch (organName, condition) {
    // Uterus
    case ("Uterus", .menarche), ("Uterus", .menstruation):
      return "Right now, the muscular walls of the uterus are contracting to shed the thickened lining (endometrium). This is what causes cramps!"
    case ("Uterus", .irregular):
      return "Hormonal fluctuations are causing the lining to shed unpredictably."
    case ("Uterus", .fibroids):
      return "Non-cancerous muscular tumors are growing on or within the uterine wall. These can apply pressure and cause heavy bleeding."
    case ("Uterus", .endometriosis):
      return "Tissue is growing outside the uterus. This tissue still thickens and bleeds with your cycle, causing severe pain because the blood has nowhere to exit."
    case ("Uterus", .atrophy):
      return "Due to a significant drop in estrogen levels, the uterine muscles shrink (atrophy) and the lining becomes very thin."
      
    // Ovary
    case ("Left Ovary", .pcos), ("Right Ovary", .pcos):
      return "Hormonal imbalances are preventing the ovary from releasing an egg. Instead, the follicle turns into a small fluid-filled cyst. Multiple cysts are forming on the edges."
    case ("Left Ovary", .endometriosis), ("Right Ovary", .endometriosis):
      return "Endometrial tissue is attaching to the ovary, causing inflammation. Blood trapped inside these tissues can form 'chocolate cysts'."
      
    // Brain
    case ("Brain", .atrophy), ("Hypothalamus", .atrophy):
      return "HOT FLASHES: Because the ovaries stop producing estrogen, the hypothalamus gets confused. It mistakenly thinks the body is overheating and triggers a massive heat release!"
      
    // Bones
    case ("Bones", .atrophy):
      return "OSTEOPOROSIS RISK: Estrogen normally protects bones. Without it during menopause, bone tissue breaks down much faster than it rebuilds, making bones porous and fragile."
      
    // Breasts
    case ("Breasts", .menstruation):
      return "SWELLING: Fluctuating progesterone and estrogen cause the milk glands and ducts to swell and retain fluid, making breasts tender during your period."
    case ("Breasts", .atrophy):
      return "INVOLUTION: The drop in estrogen causes the glandular tissue to shrink. The breast relies more on fatty tissue, causing a change in firmness and shape."
      
    default:
      return nil
    }
  }
  
  var body: some View {
    ZStack {
      Color(UIColor.systemGroupedBackground).ignoresSafeArea()
      
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          
          HStack(spacing: 16) {
            ZStack {
              Circle()
                .fill(LinearGradient(colors: [.lumaPinkBubble, .lumaAccent], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 60, height: 60)
                .shadow(color: .lumaPinkBubble.opacity(0.3), radius: 10, y: 5)
              Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
              Text("Interactive Anatomy")
                .font(.caption.bold())
                .foregroundColor(.lumaPinkBubble)
                .textCase(.uppercase)
              
              Text("The \(organName)")
                .font(.largeTitle.weight(.heavy))
                .foregroundColor(.primary)
            }
            Spacer()
          }
          .padding(.top, 24)
          
          if let insight = contextualInsight {
            VStack(alignment: .leading, spacing: 12) {
              HStack {
                Image(systemName: "bolt.fill")
                  .font(.title3)
                  .foregroundColor(.yellow)
                Text("Condition Context: \(condition.rawValue)")
                  .font(.headline.bold())
                  .foregroundColor(.white)
              }
              
              Text(insight)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(6)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
              LinearGradient(colors: [Color.orange.opacity(0.85), Color.pink.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .liquidGlass(cornerRadius: 24)
          }
          
          VStack(alignment: .leading, spacing: 12) {
            HStack {
              Image(systemName: "book.fill")
                .foregroundColor(.lumaPinkBubble)
              Text("Core Function")
                .font(.title3.bold())
                .foregroundColor(.primary)
            }
            
            Text(function)
              .font(.body)
              .foregroundColor(.secondary)
              .lineSpacing(6)
          }
          .padding(24)
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlass(cornerRadius: 24)
          
        }
        .padding(.horizontal, 24)
      }
    }
  }
}

// MARK: - Liquid Glass Modifier

struct LiquidGlassModifier: ViewModifier {
  var cornerRadius: CGFloat
  
  func body(content: Content) -> some View {
    content
      .background(.ultraThinMaterial)
      .cornerRadius(cornerRadius)
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(LinearGradient(colors: [.white.opacity(0.25), .clear, .white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.8)
      )
      .shadow(color: .black.opacity(0.1), radius: 10, y: 10)
  }
}

extension View {
  func liquidGlass(cornerRadius: CGFloat = 24) -> some View {
    self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius))
  }
}
