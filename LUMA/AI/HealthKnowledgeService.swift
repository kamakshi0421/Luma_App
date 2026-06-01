import Foundation

class HealthKnowledgeService {
    
    static let shared = HealthKnowledgeService()
    
    private var allItems: [HealthItem] = []
    private var emergencyItems: [HealthItem] = []
    
    init() {
        loadAllData()
        Task {
            await fetchRemoteUpdates()
        }
    }
    
    /// Fetches dynamic updates/new diseases from a server and merges them into the database
    func fetchRemoteUpdates() async {
        // This is a placeholder URL. You can change this to your actual API or raw JSON file URL (e.g., hosted on Firebase or GitHub)
        guard let url = URL(string: "https://raw.githubusercontent.com/kamakshi0421/Luma_App/luma_refactored/remote_health_updates.json") else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            let items = try JSONDecoder().decode([HealthItem].self, from: data)
            
            await MainActor.run {
                for item in items {
                    // Check if it's already present to prevent duplicate entries
                    if !self.allItems.contains(where: { $0.id == item.id }) &&
                       !self.emergencyItems.contains(where: { $0.id == item.id }) {
                        if item.category.lowercased().contains("emergency") || item.redFlagSymptoms != nil {
                            self.emergencyItems.append(item)
                        } else {
                            self.allItems.append(item)
                        }
                    }
                }
                print("✅ Successfully fetched and merged \(items.count) remote health items!")
            }
        } catch {
            print("ℹ️ Remote health updates fetch failed (expected if url is empty/placeholder): \(error.localizedDescription)")
        }
    }
   
    private func loadAllData() {
        
        let files = [
            "menstrual",
            "pcos",
            "pregnancy",
            "symptoms",
            "disorders",
            "contraceptive",
            "mental_health",
            "nutrition",
            "lifestyle",
            "medications",
            "emergency_flags"
        ]
        
        for file in files {
            let items = loadJSON(named: file)
            
            if file == "emergency_flags" {
                emergencyItems.append(contentsOf: items)
            } else {
                allItems.append(contentsOf: items)
            }
        }
    }
    
    private func loadJSON(named name: String) -> [HealthItem] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([HealthItem].self, from: data)
        else {
            print("⚠️ Failed to load \(name).json")
            return []
        }
        return items
    }
    
  
    
    func searchEmergencyContent(for query: String) -> HealthItem? {
        
        let lowerQuery = query.lowercased()
        
        for item in emergencyItems {
            for keyword in item.keywords {
                if lowerQuery.contains(keyword.lowercased()) {
                    return item
                }
            }
        }
        
        return nil
    }
    
    
    
    func searchRelevantContent(for query: String) -> HealthItem? {
        
        let lowerQuery = query.lowercased()
        
        var bestMatch: HealthItem?
        var highestScore = 0
        
        for item in allItems {
            var score = 0
            
            for keyword in item.keywords {
                if lowerQuery.contains(keyword.lowercased()) {
                    score += 1
                }
            }
            
            if score > highestScore {
                highestScore = score
                bestMatch = item
            }
        }
        
        return bestMatch
    }
}
