import SpriteKit
import SwiftUI
import UIKit

class BreastScene: SKScene {
    
    var currentCondition: UterusCondition = .normal {
        didSet {
            updateCondition()
        }
    }
    
    var organTapped: ((String, UterusCondition) -> Void)?
    
    private let container = SKNode()
    private let breastNode = SKShapeNode()
    private let glandNodes = SKNode()
    private var glands: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        guard container.parent == nil else { return }
        self.backgroundColor = .clear
        container.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(container)
        
        drawBreast()
        setupBreathingAnimation()
    }
    
    private func drawBreast() {
        let width = size.width * 0.4
        let height = size.height * 0.4
        
        // Breast profile outline
        let bPath = UIBezierPath()
        bPath.move(to: CGPoint(x: -width * 0.5, y: height * 0.8))
        bPath.addCurve(to: CGPoint(x: width * 0.6, y: -height * 0.2), controlPoint1: CGPoint(x: width * 0.2, y: height * 0.5), controlPoint2: CGPoint(x: width * 0.8, y: height * 0.2))
        bPath.addCurve(to: CGPoint(x: -width * 0.5, y: -height * 0.6), controlPoint1: CGPoint(x: width * 0.2, y: -height * 0.5), controlPoint2: CGPoint(x: -width * 0.2, y: -height * 0.6))
        bPath.close()
        
        breastNode.path = bPath.cgPath
        breastNode.fillColor = UIColor(red: 0.95, green: 0.8, blue: 0.75, alpha: 0.4)
        breastNode.strokeColor = UIColor.systemPink.withAlphaComponent(0.6)
        breastNode.lineWidth = 4
        breastNode.glowWidth = 2
        breastNode.name = "Breasts"
        container.addChild(breastNode)
        
        // Glandular Tissue
        container.addChild(glandNodes)
        setupGlands(count: 8, scale: 1.0)
    }
    
    private func setupGlands(count: Int, scale: CGFloat) {
        for gland in glands { gland.removeFromParent() }
        glands.removeAll()
        
        let width = size.width * 0.4
        let height = size.height * 0.4
        
        for _ in 0..<count {
            let gland = SKShapeNode(ellipseOf: CGSize(width: 20 * scale, height: 12 * scale))
            gland.fillColor = UIColor.yellow.withAlphaComponent(0.6)
            gland.strokeColor = UIColor.systemOrange.withAlphaComponent(0.8)
            gland.lineWidth = 1
            
            let x = CGFloat.random(in: -width * 0.2...width * 0.3)
            let y = CGFloat.random(in: -height * 0.3...height * 0.3)
            gland.position = CGPoint(x: x, y: y)
            gland.zRotation = CGFloat.random(in: 0 ... .pi)
            
            glandNodes.addChild(gland)
            glands.append(gland)
        }
    }
    
    private func setupBreathingAnimation() {
        let scaleUp = SKAction.scale(to: 1.02, duration: 2.0)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 0.98, duration: 2.0)
        scaleDown.timingMode = .easeInEaseOut
        container.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        spawnTouchParticles(at: location)
        
        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            if let name = node.name {
                let targetNode = breastNode
                
                targetNode.removeAllActions()
                
                let squishDown = SKAction.scaleX(to: 1.1, y: 0.9, duration: 0.15)
                let squishUp = SKAction.scaleX(to: 0.9, y: 1.1, duration: 0.15)
                let settle = SKAction.scale(to: 1.0, duration: 0.2)
                
                squishDown.timingMode = .easeOut
                squishUp.timingMode = .easeInEaseOut
                settle.timingMode = .easeInEaseOut
                
                targetNode.run(SKAction.sequence([squishDown, squishUp, settle]))
                
                organTapped?(name, currentCondition)
                break
            }
        }
    }
    
    private func updateCondition() {
        breastNode.removeAllActions()
        breastNode.setScale(1.0)
        breastNode.fillColor = UIColor(red: 0.95, green: 0.8, blue: 0.75, alpha: 0.4)
        setupGlands(count: 8, scale: 1.0)
        
        switch currentCondition {
        case .menstruation: // Swelling during periods
            setupSwelling()
        case .atrophy: // Menopause involution
            setupAtrophy()
        default:
            break
        }
    }
    
    private func setupSwelling() {
        let swell = SKAction.scale(to: 1.1, duration: 1.0)
        swell.timingMode = .easeInEaseOut
        breastNode.run(swell)
        
        breastNode.fillColor = UIColor(red: 0.95, green: 0.7, blue: 0.7, alpha: 0.5) // Redder/inflamed
        setupGlands(count: 10, scale: 1.3) // Bigger, more active glands
    }
    
    private func setupAtrophy() {
        let shrink = SKAction.scale(to: 0.85, duration: 1.5)
        shrink.timingMode = .easeInEaseOut
        breastNode.run(shrink)
        
        breastNode.fillColor = UIColor(white: 0.9, alpha: 0.3) // Less blood flow
        setupGlands(count: 3, scale: 0.6) // Fatty replacement, fewer active glands
    }
    
    private func spawnTouchParticles(at location: CGPoint) {
        let burst = SKEmitterNode()
        burst.particleTexture = SKTexture(image: createCircleImage(radius: 4))
        burst.particleBirthRate = 200
        burst.numParticlesToEmit = 10
        burst.particleLifetime = 0.5
        burst.particleSpeed = 50
        burst.emissionAngleRange = .pi * 2
        burst.particleColor = .white
        burst.position = location
        addChild(burst)
        
        burst.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.removeFromParent()
        ]))
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
