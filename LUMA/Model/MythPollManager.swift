import Foundation
import FirebaseFirestore


class MythPollManager {
    static let shared = MythPollManager()
    private let db = Firestore.firestore()
    
    /// Converts a myth string into a stable document ID
    private func documentId(for myth: String) -> String {
        let id = myth.components(separatedBy: .alphanumerics.inverted).joined()
        return String(id.prefix(50))
    }
    
    /// Attaches a live listener to a specific myth's poll.
    /// Returns a closure so it can be detached when the view disappears.
    func attachPollListener(for myth: String, completion: @escaping (Int, Int) -> Void) -> () -> Void {
        let docId = documentId(for: myth)
        
        let listener = db.collection("myth_polls").document(docId).addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data() else {
                // Document doesn't exist yet, return 0
                completion(0, 0)
                return
            }
            
            let yesCount = data["yesCount"] as? Int ?? 0
            let noCount = data["noCount"] as? Int ?? 0
            
            completion(yesCount, noCount)
        }
        
        return {
            listener.remove()
        }
    }
    
    /// Registers a user's vote and atomically increments the count on Firestore
    func registerVote(for myth: String, answer: String) {
        let docId = documentId(for: myth)
        let ref = db.collection("myth_polls").document(docId)
        
        let field = answer == "Yes" ? "yesCount" : "noCount"
        
        ref.getDocument { snapshot, error in
            if let snapshot = snapshot, snapshot.exists {
                // Atomically increment if document exists
                ref.updateData([
                    field: FieldValue.increment(Int64(1))
                ])
            } else {
                // Create document if it doesn't exist
                let initialData: [String: Any] = [
                    "yesCount": answer == "Yes" ? 1 : 0,
                    "noCount": answer == "No" ? 1 : 0
                ]
                ref.setData(initialData)
            }
        }
    }
}
