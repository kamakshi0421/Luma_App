import Foundation

class MythPollManager {
    static let shared = MythPollManager()
    
    private let defaults = UserDefaults.standard
    
    /// Converts a myth string into a stable document ID
    private func documentId(for myth: String) -> String {
        let id = myth.components(separatedBy: .alphanumerics.inverted).joined()
        return String(id.prefix(50))
    }
    
    /// Attaches a live listener to a specific myth's poll.
    /// Returns a closure so it can be detached when the view disappears.
    func attachPollListener(for myth: String, completion: @escaping (Int, Int) -> Void) -> () -> Void {
        let docId = documentId(for: myth)
        
        let yesKey = "\(docId)_yesCount"
        let noKey = "\(docId)_noCount"
        
        // Just call completion once immediately since there are no real-time updates anymore
        let yesCount = defaults.integer(forKey: yesKey)
        let noCount = defaults.integer(forKey: noKey)
        completion(yesCount, noCount)
        
        return {
            // No listener to remove
        }
    }
    
    /// Registers a user's vote locally
    func registerVote(for myth: String, answer: String) {
        let docId = documentId(for: myth)
        
        let yesKey = "\(docId)_yesCount"
        let noKey = "\(docId)_noCount"
        
        if answer == "Yes" {
            let current = defaults.integer(forKey: yesKey)
            defaults.set(current + 1, forKey: yesKey)
        } else {
            let current = defaults.integer(forKey: noKey)
            defaults.set(current + 1, forKey: noKey)
        }
    }
}
