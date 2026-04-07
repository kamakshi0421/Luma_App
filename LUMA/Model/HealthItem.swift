

import Foundation

struct HealthItem: Codable {
    
    let id: String
    let category: String
    let topic: String
    let keywords: [String]
    
    
    let explanation: String?
    let isNormal: String?
    
    
    let whatToDo: [String]?
    let seeDoctorIf: [String]?
    
   
    let lifeStage: [String]?
    let commonSymptoms: [String]?
    let commonProblems: [String]?
    let possibleComplications: [String]?
    let possibleCauses: [String]?
    let redFlagSymptoms: [String]?
    let action: String?
    
   
    let trimesterDetails: [String: String]?
    let flowTypes: [String: String]?
    let colorGuide: [String: String]?
}
