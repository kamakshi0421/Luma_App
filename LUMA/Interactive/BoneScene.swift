import SpriteKit
import SwiftUI
import UIKit

class BoneScene: SKScene {
    
    var currentCondition: UterusCondition = .normal {
        didSet {
            updateCondition()
        }
    }
    
    var organTapped: ((String, UterusCondition) -> Void)?
    
    private let container = SKNode()
    private let boneNode = SKShapeNode()
    private var porousHoles: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        guard container.parent == nil else { return }
        self.backgroundColor = .clear
        container.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(container)
        
        drawBone()
        setupBreathingAnimation()
    }
    
    private func drawBone() {
        let width = size.width * 0.4
        let height = size.height * 0.6
        
        // Classic Femur Bone Shape
        let bPath = UIBezierPath()
        // Top joint
        bPath.addArc(withCenter: CGPoint(x: -width * 0.2, y: height * 0.4), radius: width * 0.3, startAngle: .pi, endAngle: 0, clockwise: true)
        bPath.addArc(withCenter: CGPoint(x: width * 0.2, y: height * 0.4), radius: width * 0.3, startAngle: .pi, endAngle: 0, clockwise: true)
        
        // Shaft
        bPath.addLine(to: CGPoint(x: width * 0.2, y: -height * 0.4))
        
        // Bottom joint
        bPath.addArc(withCenter: CGPoint(x: width * 0.2, y: -height * 0.4), radius: width * 0.3, startAngle: 0, endAngle: -.pi, clockwise: true)
        bPath.addArc(withCenter: CGPoint(x: -width * 0.2, y: -height * 0.4), radius: width * 0.3, startAngle: 0, endAngle: -.pi, clockwise: true)
        
        // Back up the shaft
        bPath.close()
        
        boneNode.path = bPath.cgPath
        boneNode.fillColor = UIColor.white
        boneNode.strokeColor = UIColor(white: 0.8, alpha: 1.0)
        boneNode.lineWidth = 4
        boneNode.glowWidth = 2
        boneNode.name = "Bones"
        container.addChild(boneNode)
    }
    
    private func setupBreathingAnimation() {
        let scaleUp = SKAction.scale(to: 1.01, duration: 3.0)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 0.99, duration: 3.0)
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
                let targetNode = boneNode
                
                targetNode.removeAllActions()
                
                let squishDown = SKAction.scaleX(to: 1.05, y: 0.95, duration: 0.1)
                let squishUp = SKAction.scaleX(to: 0.95, y: 1.05, duration: 0.15)
                let settle = SKAction.scale(to: 1.0, duration: 0.15)
                
                targetNode.run(SKAction.sequence([squishDown, squishUp, settle]))
                
                organTapped?(name, currentCondition)
                break
            }
        }
    }
    
    private func updateCondition() {
        for hole in porousHoles { hole.removeFromParent() }
        porousHoles.removeAll()
        
        boneNode.fillColor = .white
        boneNode.strokeColor = UIColor(white: 0.8, alpha: 1.0)
        
        switch currentCondition {
        case .atrophy: // Used as the proxy for Menopause
            setupOsteoporosis()
        default:
            break
        }
    }
    
    private func setupOsteoporosis() {
        boneNode.fillColor = UIColor(white: 0.9, alpha: 0.8) // Less dense
        
        let width = size.width * 0.4
        let height = size.height * 0.6
        
        // Create porous holes
        for _ in 0...40 {
            let hole = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...8))
            hole.fillColor = UIColor(red: 0.2, green: 0.0, blue: 0.1, alpha: 0.3)
            hole.strokeColor = .clear
            
            // Random position within the shaft
            let x = CGFloat.random(in: -width * 0.1...width * 0.1)
            let y = CGFloat.random(in: -height * 0.35...height * 0.35)
            hole.position = CGPoint(x: x, y: y)
            
            boneNode.addChild(hole)
            porousHoles.append(hole)
            
            // Subtle dissolving animation
            let fadeOut = SKAction.fadeAlpha(to: 0.1, duration: Double.random(in: 1.0...2.0))
            let fadeIn = SKAction.fadeAlpha(to: 0.3, duration: Double.random(in: 1.0...2.0))
            hole.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
        }
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
