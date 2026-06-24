import SpriteKit
import SwiftUI
import UIKit

class BrainScene: SKScene {
  
  var currentCondition: UterusCondition = .normal {
    didSet {
      updateCondition()
    }
  }
  
  var organTapped: ((String, UterusCondition) -> Void)?
  
  private let container = SKNode()
  private let brainNode = SKShapeNode()
  private let hypothalamusNode = SKShapeNode(circleOfRadius: 8)
  private var heatWaves: SKEmitterNode?
  
  override func didMove(to view: SKView) {
    guard container.parent == nil else { return }
    self.backgroundColor = .clear
    container.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(container)
    
    drawBrain()
    setupBreathingAnimation()
  }
  
  private func drawBrain() {
    let width = size.width * 0.5
    let height = size.height * 0.4
    
    // Simple Brain Outline (Cerebrum)
    let bPath = UIBezierPath()
    bPath.move(to: CGPoint(x: -width * 0.4, y: -height * 0.2))
    bPath.addCurve(to: CGPoint(x: 0, y: height * 0.5), controlPoint1: CGPoint(x: -width * 0.6, y: height * 0.1), controlPoint2: CGPoint(x: -width * 0.3, y: height * 0.6))
    bPath.addCurve(to: CGPoint(x: width * 0.4, y: -height * 0.2), controlPoint1: CGPoint(x: width * 0.3, y: height * 0.6), controlPoint2: CGPoint(x: width * 0.6, y: height * 0.1))
    bPath.addCurve(to: CGPoint(x: -width * 0.4, y: -height * 0.2), controlPoint1: CGPoint(x: width * 0.2, y: -height * 0.4), controlPoint2: CGPoint(x: -width * 0.2, y: -height * 0.4))
    bPath.close()
    
    brainNode.path = bPath.cgPath
    brainNode.fillColor = UIColor(red: 0.8, green: 0.7, blue: 0.9, alpha: 0.4)
    brainNode.strokeColor = UIColor.systemPurple.withAlphaComponent(0.8)
    brainNode.lineWidth = 4
    brainNode.glowWidth = 2
    brainNode.name = "Brain"
    container.addChild(brainNode)
    
    // Hypothalamus
    hypothalamusNode.position = CGPoint(x: 0, y: -height * 0.1)
    hypothalamusNode.fillColor = .white
    hypothalamusNode.strokeColor = .yellow
    hypothalamusNode.lineWidth = 2
    hypothalamusNode.glowWidth = 4
    hypothalamusNode.name = "Hypothalamus"
    container.addChild(hypothalamusNode)
  }
  
  private func setupBreathingAnimation() {
    let scaleUp = SKAction.scale(to: 1.02, duration: 2.5)
    scaleUp.timingMode = .easeInEaseOut
    let scaleDown = SKAction.scale(to: 0.98, duration: 2.5)
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
        let targetNode = (name == "Hypothalamus") ? hypothalamusNode : brainNode
        
        targetNode.removeAllActions()
        
        let squishDown = SKAction.scaleX(to: 1.1, y: 0.9, duration: 0.1)
        let squishUp = SKAction.scaleX(to: 0.9, y: 1.1, duration: 0.15)
        let settle = SKAction.scale(to: 1.0, duration: 0.15)
        
        targetNode.run(SKAction.sequence([squishDown, squishUp, settle]))
        
        organTapped?(name, currentCondition)
        break
      }
    }
  }
  
  private func updateCondition() {
    heatWaves?.removeFromParent()
    heatWaves = nil
    
    brainNode.fillColor = UIColor(red: 0.8, green: 0.7, blue: 0.9, alpha: 0.4)
    hypothalamusNode.fillColor = .white
    hypothalamusNode.strokeColor = .yellow
    
    switch currentCondition {
    case .atrophy: // Used as the proxy for Menopause
      setupHotFlash()
    default:
      break
    }
  }
  
  private func setupHotFlash() {
    // Hypothalamus turns angry red
    hypothalamusNode.fillColor = UIColor.systemRed
    hypothalamusNode.strokeColor = UIColor.systemOrange
    
    // Brain gets warmer
    brainNode.fillColor = UIColor(red: 0.9, green: 0.5, blue: 0.5, alpha: 0.6)
    
    // Heat waves emitter
    let emitter = SKEmitterNode()
    emitter.particleTexture = SKTexture(image: createCircleImage(radius: 5))
    emitter.particleBirthRate = 30
    emitter.particleLifetime = 2.0
    emitter.particlePositionRange = CGVector(dx: size.width * 0.4, dy: size.height * 0.2)
    emitter.particleSpeed = 20
    emitter.particleSpeedRange = 10
    emitter.particleAlpha = 0.6
    emitter.particleScale = 1.0
    emitter.particleScaleRange = 0.5
    emitter.particleColor = .orange
    emitter.particleColorBlendFactor = 1.0
    
    emitter.yAcceleration = 20 // Heat rises
    emitter.position = CGPoint(x: 0, y: 0)
    container.addChild(emitter)
    heatWaves = emitter
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
