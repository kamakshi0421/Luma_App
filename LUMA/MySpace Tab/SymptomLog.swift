import SwiftUI
import Foundation

struct SymptomLog: Identifiable , Codable {
    
    let id: UUID
    let date: Date
    
   
    var mood: String
    var flow: String?
    var painLevel: Double?
    var energyLevel: Double?
    
   
    var stress: Int
    var sleepHours: Double
    
  
    var lifeStage: LifeStage
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        mood: String,
        flow: String? = nil,
        painLevel: Double? = nil,
        energyLevel: Double? = nil,
        stress: Int,
        sleepHours: Double,
        lifeStage: LifeStage
    ) {
        self.id = id
        self.date = date
        self.mood = mood
        self.flow = flow
        self.painLevel = painLevel
        self.energyLevel = energyLevel
        self.stress = stress
        self.sleepHours = sleepHours
        self.lifeStage = lifeStage
    }
}
