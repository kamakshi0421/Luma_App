import SwiftUI
internal import Combine
import Foundation

class SymptomStore: ObservableObject {
    
    @Published var logs: [SymptomLog] = []
    
    @Published var userAge: Int = 25 {
        didSet {
            saveAge()
        }
    }
    
    private let logKey = "symptom_logs"
    private let ageKey = "user_age"
    
   
    init() {
        load()
        loadAge()
    }
   
    var currentLifeStage: LifeStage {
        LifeStage.stage(for: userAge)
    }
 
    
    func addLog(_ log: SymptomLog) {
        logs.append(log)
        save()
    }
    
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: logKey)
        }
    }
    
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: logKey),
           let decoded = try? JSONDecoder().decode([SymptomLog].self, from: data) {
            logs = decoded
        }
    }
  
    
    private func saveAge() {
        UserDefaults.standard.set(userAge, forKey: ageKey)
    }
   
    private func loadAge() {
        let savedAge = UserDefaults.standard.integer(forKey: ageKey)
        if savedAge != 0 {
            userAge = savedAge
        }
    }
}
