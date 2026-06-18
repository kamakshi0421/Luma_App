import SpriteKit
import SwiftUI

class BodyMapScene: SKScene {
    
    var zoneTapped: ((BodyZone) -> Void)?
    
    // Store zone positions to draw constellation lines
    private var zonePositions: [CGPoint] = []
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        
        setupBodyOutline()
        setupConstellationLines()
        setupInteractiveZones()
        setupAmbientParticles()
    }
    
    private func setupBodyOutline() {
        let width = size.width * 0.5
        let height = size.height * 0.6
        
        let container = SKNode()
        container.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(container)
        
        // 1. Smooth Hourglass Torso
        let torsoPath = UIBezierPath()
        torsoPath.move(to: CGPoint(x: -width * 0.25, y: height * 0.2)) // Top left shoulder
        torsoPath.addCurve(to: CGPoint(x: -width * 0.3, y: -height * 0.3), // Bottom left hip
                           controlPoint1: CGPoint(x: -width * 0.1, y: 0), // Pinch waist
                           controlPoint2: CGPoint(x: -width * 0.35, y: -height * 0.1))
        torsoPath.addCurve(to: CGPoint(x: width * 0.3, y: -height * 0.3), // Bottom right hip
                           controlPoint1: CGPoint(x: -width * 0.1, y: -height * 0.35),
                           controlPoint2: CGPoint(x: width * 0.1, y: -height * 0.35))
        torsoPath.addCurve(to: CGPoint(x: width * 0.25, y: height * 0.2), // Top right shoulder
                           controlPoint1: CGPoint(x: width * 0.35, y: -height * 0.1), // Pinch waist
                           controlPoint2: CGPoint(x: width * 0.1, y: 0))
        torsoPath.addCurve(to: CGPoint(x: -width * 0.25, y: height * 0.2), // Connect back to shoulder
                           controlPoint1: CGPoint(x: width * 0.1, y: height * 0.25),
                           controlPoint2: CGPoint(x: -width * 0.1, y: height * 0.25))
        torsoPath.close()
        
        let torso = SKShapeNode(path: torsoPath.cgPath)
        torso.strokeColor = UIColor.systemPink.withAlphaComponent(0.6)
        torso.lineWidth = 2
        torso.fillColor = UIColor.systemPink.withAlphaComponent(0.1)
        torso.glowWidth = 4.0
        container.addChild(torso)
        
        // 2. Head
        let head = SKShapeNode(circleOfRadius: width * 0.18)
        head.position = CGPoint(x: 0, y: height * 0.45)
        head.strokeColor = UIColor.systemPink.withAlphaComponent(0.6)
        head.lineWidth = 2
        head.fillColor = UIColor.systemPink.withAlphaComponent(0.1)
        head.glowWidth = 4.0
        container.addChild(head)
        
        // 3. Breathing Animation (Aura)
        let scaleUp = SKAction.scale(to: 1.02, duration: 2.0)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 0.98, duration: 2.0)
        scaleDown.timingMode = .easeInEaseOut
        container.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
    }
    
    private func setupConstellationLines() {
        // Collect positions
        let zones = BodyZone.allCases
        for zone in zones {
            let x = size.width * zone.position.x
            let y = size.height * (1.0 - zone.position.y)
            zonePositions.append(CGPoint(x: x, y: y))
        }
        
        // Draw lines connecting them
        for i in 0..<zonePositions.count {
            for j in (i+1)..<zonePositions.count {
                // Only connect nodes that are somewhat close to each other to form a web
                let p1 = zonePositions[i]
                let p2 = zonePositions[j]
                let distance = hypot(p1.x - p2.x, p1.y - p2.y)
                
                if distance < size.height * 0.3 {
                    let linePath = CGMutablePath()
                    linePath.move(to: p1)
                    linePath.addLine(to: p2)
                    
                    let line = SKShapeNode(path: linePath)
                    line.strokeColor = UIColor.white.withAlphaComponent(0.15)
                    line.lineWidth = 1.0
                    addChild(line)
                    
                    // Energy pulse animation on lines
                    let fadeOut = SKAction.fadeAlpha(to: 0.05, duration: Double.random(in: 1.5...3.0))
                    let fadeIn = SKAction.fadeAlpha(to: 0.25, duration: Double.random(in: 1.5...3.0))
                    line.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
                }
            }
        }
    }
    
    private func setupInteractiveZones() {
        for zone in BodyZone.allCases {
            let x = size.width * zone.position.x
            let y = size.height * (1.0 - zone.position.y) // Invert Y since SwiftUI GeometryReader 0 is top
            
            // Container node for the zone
            let zoneNode = SKNode()
            zoneNode.position = CGPoint(x: x, y: y)
            zoneNode.name = zone.rawValue // Important for touch detection
            addChild(zoneNode)
            
            // Base Circle
            let baseCircle = SKShapeNode(circleOfRadius: 18)
            baseCircle.fillColor = UIColor.systemPink.withAlphaComponent(0.4)
            baseCircle.strokeColor = UIColor.systemPink
            baseCircle.lineWidth = 1
            baseCircle.name = zone.rawValue
            zoneNode.addChild(baseCircle)
            
            // Continuous Radar Ripple Generator
            let rippleAction = SKAction.run { [weak self] in
                guard let self = self else { return }
                let ripple = SKShapeNode(circleOfRadius: 18)
                ripple.strokeColor = UIColor.systemPink.withAlphaComponent(0.8)
                ripple.lineWidth = 2
                ripple.fillColor = .clear
                zoneNode.addChild(ripple)
                
                let expand = SKAction.scale(to: 2.5, duration: 2.0)
                let fade = SKAction.fadeOut(withDuration: 2.0)
                let group = SKAction.group([expand, fade])
                let remove = SKAction.removeFromParent()
                ripple.run(SKAction.sequence([group, remove]))
            }
            
            zoneNode.run(SKAction.sequence([
                SKAction.wait(forDuration: Double.random(in: 0...1.0)),
                SKAction.repeatForever(SKAction.sequence([
                    rippleAction,
                    SKAction.wait(forDuration: 1.5)
                ]))
            ]))
            
            // Inner Circle
            let innerCircle = SKShapeNode(circleOfRadius: 12)
            innerCircle.fillColor = UIColor.systemPink
            innerCircle.strokeColor = .clear
            innerCircle.name = zone.rawValue
            zoneNode.addChild(innerCircle)
            
            // Icon (Fixed to be bright white)
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            if let uiImage = UIImage(systemName: zone.icon, withConfiguration: config) {
                let texture = SKTexture(image: uiImage)
                let iconNode = SKSpriteNode(texture: texture)
                iconNode.size = CGSize(width: 14, height: 14)
                iconNode.color = .white
                iconNode.colorBlendFactor = 1.0 // Force it to be tinted white
                iconNode.name = zone.rawValue
                zoneNode.addChild(iconNode)
            }
        }
    }
    
    private func setupAmbientParticles() {
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(image: createCircleImage(radius: 4))
        emitter.particleBirthRate = 8
        emitter.particleLifetime = 15
        emitter.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        emitter.particleSpeed = 10
        emitter.particleSpeedRange = 5
        emitter.particleAlpha = 0.5
        emitter.particleAlphaRange = 0.3
        emitter.particleScale = 0.4
        emitter.particleScaleRange = 0.2
        emitter.particleColor = .white
        emitter.particleColorBlendFactor = 1.0
        
        // Gentle float upwards like magical dust
        emitter.yAcceleration = 5
        emitter.xAcceleration = 2
        emitter.emissionAngleRange = .pi * 2
        
        emitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        emitter.zPosition = -2 // Keep it far behind
        
        addChild(emitter)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Find tapped nodes
        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            if let name = node.name, let zone = BodyZone(rawValue: name) {
                // Add an intense impact ripple on tap
                let impactRipple = SKShapeNode(circleOfRadius: 18)
                impactRipple.fillColor = UIColor.white.withAlphaComponent(0.6)
                impactRipple.strokeColor = .white
                node.parent?.addChild(impactRipple)
                
                impactRipple.run(SKAction.sequence([
                    SKAction.group([
                        SKAction.scale(to: 3.0, duration: 0.3),
                        SKAction.fadeOut(withDuration: 0.3)
                    ]),
                    SKAction.removeFromParent()
                ]))
                
                // Add a cute bounce effect to the node itself
                let scaleDown = SKAction.scale(to: 0.8, duration: 0.1)
                let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
                node.parent?.run(SKAction.sequence([scaleDown, scaleUp]))
                
                // Trigger SwiftUI sheet
                zoneTapped?(zone)
                return
            }
        }
    }
}
