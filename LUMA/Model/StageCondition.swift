import Foundation
import SwiftUI
import Foundation

struct StageCondition: Identifiable {
    
    let id = UUID()
    
    let name: String
    let shortDescription: String   
    
    let overview: String
    let imageName: String
    
    let symptoms: [String]
    let basicCare: [String]
    let whenToSeeDoctor: String
}
