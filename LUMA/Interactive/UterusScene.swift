import SpriteKit
import SwiftUI
import UIKit

enum UterusCondition: String, CaseIterable, Identifiable {
    case normal = "Healthy"
    case menarche = "First Period"
    case menstruation = "Period"
    case irregular = "Irregular Period"
    case pcos = "PCOS"
    case fibroids = "Fibroids"
    case endometriosis = "Endometriosis"
    case atrophy = "Atrophy"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .normal: return "The uterus and ovaries are in a balanced, resting state."
        case .menarche: return "The very first time the uterine lining is shed, marking the onset of puberty."
        case .menstruation: return "The thickened uterine lining sheds, flowing downward as menstrual blood."
        case .irregular: return "Unpredictable shedding of the lining, often due to hormonal fluctuations during perimenopause."
        case .pcos: return "Multiple small fluid-filled sacs (cysts) develop on the ovaries, causing inflammation and irregular cycles."
        case .fibroids: return "Non-cancerous muscular lumps grow on the uterine wall, which can cause heavy bleeding and cramps."
        case .endometriosis: return "Tissue similar to the uterine lining grows outside the uterus, causing severe pain and inflammation."
        case .atrophy: return "Due to lower estrogen during menopause, the vaginal and uterine tissues shrink and become thinner."
        }
    }
}

class UterusScene: SKScene {
    
    var currentCondition: UterusCondition = .normal {
        didSet {
            updateCondition()
        }
    }
    
    var organTapped: ((String, UterusCondition) -> Void)?
    
    // Core nodes
    private let container = SKNode()
    private let uterusNode = SKShapeNode()
    private let leftOvary = SKShapeNode(ellipseOf: CGSize(width: 45, height: 30))
    private let rightOvary = SKShapeNode(ellipseOf: CGSize(width: 45, height: 30))
    
    // Effect nodes
    private var bloodEmitter: SKEmitterNode?
    private var cystNodes: [SKShapeNode] = []
    private var fibroidNodes: [SKShapeNode] = []
    private var endoNodes: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        guard container.parent == nil else { return }
        self.backgroundColor = .clear
        
        container.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(container)
        
        drawReproductiveSystem()
        setupBreathingAnimation()
    }
    
    private func drawReproductiveSystem() {
        let width = size.width * 0.5
        let height = size.height * 0.4
        
        // 1. Realistic Uterus Body
        let uPath = UIBezierPath()
        uPath.move(to: CGPoint(x: -width * 0.35, y: height * 0.25))
        uPath.addQuadCurve(to: CGPoint(x: width * 0.35, y: height * 0.25), controlPoint: CGPoint(x: 0, y: height * 0.45))
        uPath.addCurve(to: CGPoint(x: width * 0.08, y: -height * 0.2), controlPoint1: CGPoint(x: width * 0.35, y: -height * 0.05), controlPoint2: CGPoint(x: width * 0.15, y: -height * 0.15))
        uPath.addQuadCurve(to: CGPoint(x: -width * 0.08, y: -height * 0.2), controlPoint: CGPoint(x: 0, y: -height * 0.28))
        uPath.addCurve(to: CGPoint(x: -width * 0.35, y: height * 0.25), controlPoint1: CGPoint(x: -width * 0.15, y: -height * 0.15), controlPoint2: CGPoint(x: -width * 0.35, y: -height * 0.05))
        uPath.close()
        
        uterusNode.path = uPath.cgPath
        uterusNode.fillColor = UIColor(red: 0.9, green: 0.4, blue: 0.5, alpha: 0.4)
        uterusNode.strokeColor = UIColor.systemPink.withAlphaComponent(0.8)
        uterusNode.lineWidth = 4
        uterusNode.glowWidth = 2
        uterusNode.name = "Uterus"
        container.addChild(uterusNode)
        
        // 2. Thick Fallopian Tubes
        let leftTube = UIBezierPath()
        leftTube.move(to: CGPoint(x: -width * 0.3, y: height * 0.2))
        leftTube.addCurve(to: CGPoint(x: -width * 0.75, y: height * 0.05), controlPoint1: CGPoint(x: -width * 0.5, y: height * 0.3), controlPoint2: CGPoint(x: -width * 0.65, y: height * 0.2))
        
        let lTubeNode = SKShapeNode(path: leftTube.cgPath)
        lTubeNode.strokeColor = UIColor.systemPink.withAlphaComponent(0.5)
        lTubeNode.lineWidth = 10
        lTubeNode.lineCap = .round
        container.addChild(lTubeNode)
        
        let rightTube = UIBezierPath()
        rightTube.move(to: CGPoint(x: width * 0.3, y: height * 0.2))
        rightTube.addCurve(to: CGPoint(x: width * 0.75, y: height * 0.05), controlPoint1: CGPoint(x: width * 0.5, y: height * 0.3), controlPoint2: CGPoint(x: width * 0.65, y: height * 0.2))
        
        let rTubeNode = SKShapeNode(path: rightTube.cgPath)
        rTubeNode.strokeColor = UIColor.systemPink.withAlphaComponent(0.5)
        rTubeNode.lineWidth = 10
        rTubeNode.lineCap = .round
        container.addChild(rTubeNode)
        
        // 3. Organic Ovaries
        leftOvary.position = CGPoint(x: -width * 0.85, y: height * 0.0)
        leftOvary.fillColor = UIColor.white.withAlphaComponent(0.6)
        leftOvary.strokeColor = UIColor.white.withAlphaComponent(0.9)
        leftOvary.lineWidth = 2
        leftOvary.glowWidth = 2
        leftOvary.zRotation = .pi / 5
        leftOvary.name = "Left Ovary"
        container.addChild(leftOvary)
        
        rightOvary.position = CGPoint(x: width * 0.85, y: height * 0.0)
        rightOvary.fillColor = UIColor.white.withAlphaComponent(0.6)
        rightOvary.strokeColor = UIColor.white.withAlphaComponent(0.9)
        rightOvary.lineWidth = 2
        rightOvary.glowWidth = 2
        rightOvary.zRotation = -.pi / 5
        rightOvary.name = "Right Ovary"
        container.addChild(rightOvary)
        
        // 4. Vagina Canal
        let canal = UIBezierPath()
        canal.move(to: CGPoint(x: -width * 0.08, y: -height * 0.25))
        canal.addLine(to: CGPoint(x: -width * 0.12, y: -height * 0.45))
        canal.move(to: CGPoint(x: width * 0.08, y: -height * 0.25))
        canal.addLine(to: CGPoint(x: width * 0.12, y: -height * 0.45))
        
        let canalNode = SKShapeNode(path: canal.cgPath)
        canalNode.strokeColor = UIColor.systemPink.withAlphaComponent(0.4)
        canalNode.lineWidth = 4
        canalNode.lineCap = .round
        container.addChild(canalNode)
    }
    
    private func setupBreathingAnimation() {
        let scaleUp = SKAction.scale(to: 1.02, duration: 2.0)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 0.98, duration: 2.0)
        scaleDown.timingMode = .easeInEaseOut
        container.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
    }
    
    // MARK: - Interactions (Squishy Physics)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        spawnTouchParticles(at: location)
        
        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            if let name = node.name {
                let targetNode: SKNode
                if name == "Uterus" { targetNode = uterusNode }
                else if name == "Left Ovary" { targetNode = leftOvary }
                else if name == "Right Ovary" { targetNode = rightOvary }
                else { continue }
                
                targetNode.removeAllActions()
                
                let squishDown = SKAction.scaleX(to: 1.15, y: 0.85, duration: 0.1)
                let squishUp = SKAction.scaleX(to: 0.95, y: 1.05, duration: 0.15)
                let settle = SKAction.scale(to: targetNode == uterusNode && currentCondition == .atrophy ? 0.8 : 1.0, duration: 0.15)
                
                squishDown.timingMode = .easeOut
                squishUp.timingMode = .easeInEaseOut
                settle.timingMode = .easeInEaseOut
                
                targetNode.run(SKAction.sequence([squishDown, squishUp, settle]))
                
                // Trigger SwiftUI callback with organ name AND condition
                organTapped?(name, currentCondition)
                
                break
            }
        }
    }
    
    private func spawnTouchParticles(at location: CGPoint) {
        let burst = SKEmitterNode()
        burst.particleTexture = SKTexture(image: createCircleImage(radius: 4))
        burst.particleBirthRate = 200
        burst.numParticlesToEmit = 10
        burst.particleLifetime = 0.5
        burst.particleSpeed = 50
        burst.particleSpeedRange = 20
        burst.emissionAngleRange = .pi * 2
        burst.particleAlpha = 0.8
        burst.particleAlphaSpeed = -1.6
        burst.particleScale = 0.5
        burst.particleScaleSpeed = -0.5
        burst.particleColorBlendFactor = 1.0
        burst.particleColor = .white
        
        burst.position = location
        addChild(burst)
        
        burst.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.removeFromParent()
        ]))
    }
    
    // MARK: - Condition States
    
    private func updateCondition() {
        // Reset all effects
        bloodEmitter?.removeFromParent()
        bloodEmitter = nil
        
        for cyst in cystNodes { cyst.removeFromParent() }
        cystNodes.removeAll()
        
        for fibroid in fibroidNodes { fibroid.removeFromParent() }
        fibroidNodes.removeAll()
        
        for endo in endoNodes { endo.removeFromParent() }
        endoNodes.removeAll()
        
        uterusNode.removeAllActions()
        uterusNode.setScale(1.0)
        
        uterusNode.fillColor = UIColor(red: 0.9, green: 0.4, blue: 0.5, alpha: 0.4)
        leftOvary.fillColor = UIColor.white.withAlphaComponent(0.6)
        rightOvary.fillColor = UIColor.white.withAlphaComponent(0.6)
        
        // Apply new condition
        switch currentCondition {
        case .normal:
            break
            
        case .menarche:
            uterusNode.fillColor = UIColor(red: 0.8, green: 0.1, blue: 0.2, alpha: 0.3)
            setupBloodEmitter(flowRate: 10, speed: 10) // Lighter flow
            
        case .menstruation:
            uterusNode.fillColor = UIColor(red: 0.8, green: 0.1, blue: 0.2, alpha: 0.4)
            setupBloodEmitter(flowRate: 20, speed: 20) // Normal flow
            
        case .irregular:
            uterusNode.fillColor = UIColor(red: 0.8, green: 0.1, blue: 0.2, alpha: 0.3)
            setupBloodEmitter(flowRate: 5, speed: 8) // Very light/spotting flow
            
        case .pcos:
            leftOvary.fillColor = UIColor.systemRed.withAlphaComponent(0.5)
            rightOvary.fillColor = UIColor.systemRed.withAlphaComponent(0.5)
            setupCysts(for: leftOvary)
            setupCysts(for: rightOvary)
            
        case .fibroids:
            setupFibroids()
            
        case .endometriosis:
            setupEndometriosis()
            
        case .atrophy:
            setupAtrophy()
        }
    }
    
    private func setupBloodEmitter(flowRate: CGFloat, speed: CGFloat) {
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(image: createCircleImage(radius: 3))
        emitter.particleBirthRate = flowRate
        emitter.particleLifetime = 4.0
        emitter.particlePositionRange = CGVector(dx: size.width * 0.25, dy: 10)
        emitter.particleSpeed = speed
        emitter.particleSpeedRange = 10
        emitter.particleAlpha = 0.8
        emitter.particleScale = 0.5
        emitter.particleScaleRange = 0.3
        emitter.particleColor = .red
        emitter.particleColorBlendFactor = 1.0
        
        emitter.yAcceleration = -30
        emitter.emissionAngle = -.pi / 2
        emitter.emissionAngleRange = .pi / 8
        
        emitter.position = CGPoint(x: 0, y: size.height * 0.05)
        container.addChild(emitter)
        bloodEmitter = emitter
    }
    
    private func setupCysts(for ovary: SKNode) {
        let cystPositions = [
            CGPoint(x: -12, y: 6),
            CGPoint(x: 12, y: 10),
            CGPoint(x: -6, y: -10),
            CGPoint(x: 14, y: -6),
            CGPoint(x: 0, y: 14)
        ]
        
        for pos in cystPositions {
            let cyst = SKShapeNode(circleOfRadius: 4)
            cyst.fillColor = UIColor.yellow.withAlphaComponent(0.6)
            cyst.strokeColor = .white
            cyst.lineWidth = 1
            cyst.position = pos
            
            let pulseUp = SKAction.scale(to: 1.3, duration: Double.random(in: 0.5...1.0))
            let pulseDown = SKAction.scale(to: 0.9, duration: Double.random(in: 0.5...1.0))
            cyst.run(SKAction.repeatForever(SKAction.sequence([pulseUp, pulseDown])))
            
            ovary.addChild(cyst)
            cystNodes.append(cyst)
        }
    }
    
    private func setupFibroids() {
        let fibroidPositions = [
            CGPoint(x: -size.width * 0.12, y: size.height * 0.05),
            CGPoint(x: size.width * 0.08, y: size.height * 0.1),
            CGPoint(x: size.width * 0.05, y: -size.height * 0.05)
        ]
        
        for pos in fibroidPositions {
            let fibroid = SKShapeNode(circleOfRadius: CGFloat.random(in: 12...22))
            fibroid.fillColor = UIColor(red: 0.6, green: 0.0, blue: 0.1, alpha: 0.8)
            fibroid.strokeColor = UIColor.systemPink
            fibroid.lineWidth = 2
            fibroid.position = pos
            
            let grow = SKAction.scale(to: 1.1, duration: 1.5)
            let shrink = SKAction.scale(to: 0.9, duration: 1.5)
            fibroid.run(SKAction.repeatForever(SKAction.sequence([grow, shrink])))
            
            container.addChild(fibroid)
            fibroidNodes.append(fibroid)
        }
    }
    
    private func setupEndometriosis() {
        let endoPositions = [
            CGPoint(x: -size.width * 0.25, y: size.height * 0.15),
            CGPoint(x: size.width * 0.25, y: size.height * 0.1),
            CGPoint(x: -size.width * 0.4, y: size.height * 0.02),
            CGPoint(x: size.width * 0.35, y: -size.height * 0.05)
        ]
        
        for pos in endoPositions {
            let patch = SKShapeNode(circleOfRadius: CGFloat.random(in: 5...12))
            patch.fillColor = UIColor(red: 0.4, green: 0.1, blue: 0.1, alpha: 0.9)
            patch.strokeColor = .red
            patch.lineWidth = 1
            patch.glowWidth = 2
            patch.position = pos
            
            let throbUp = SKAction.scale(to: 1.2, duration: 0.8)
            let throbDown = SKAction.scale(to: 0.8, duration: 0.8)
            patch.run(SKAction.repeatForever(SKAction.sequence([throbUp, throbDown])))
            
            container.addChild(patch)
            endoNodes.append(patch)
        }
    }
    
    private func setupAtrophy() {
        let shrink = SKAction.scale(to: 0.8, duration: 1.5)
        shrink.timingMode = .easeInEaseOut
        uterusNode.run(shrink)
        
        uterusNode.fillColor = UIColor(red: 0.95, green: 0.75, blue: 0.8, alpha: 0.3)
    }
    
    private func createCircleImage(radius: CGFloat) -> UIImage {
        let size = CGSize(width: radius * 2, height: radius * 2)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
