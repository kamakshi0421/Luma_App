import SwiftUI
internal import Combine
import Foundation
import FirebaseFirestore
import FirebaseAuth

class SymptomStore: ObservableObject {
    
    @Published var logs: [SymptomLog] = []
    
    @Published var userAge: Int = 25 {
        didSet {
            saveAge()
        }
    }
    
    private let logKey = "symptom_logs"
    private let ageKey = "user_age"
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var authListener: AuthStateDidChangeListenerHandle?
    
    private var userId: String {
        if let uid = Auth.auth().currentUser?.uid {
            return uid
        } else if let id = UserDefaults.standard.string(forKey: "user_id") {
            return id
        } else {
            let newId = UUID().uuidString
            UserDefaults.standard.set(newId, forKey: "user_id")
            return newId
        }
    }
    
    private var userLogsCollection: CollectionReference {
        db.collection("users").document(userId).collection("symptom_logs")
    }
    
    init() {
        load()
        loadAge()
        
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, _ in
            self?.setupFirestoreListener()
        }
    }
    
    deinit {
        listener?.remove()
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
   
    var currentLifeStage: LifeStage {
        LifeStage.stage(for: userAge)
    }
  
    
    func addLog(_ log: SymptomLog) {
        if !logs.contains(where: { $0.id == log.id }) {
            logs.append(log)
            save()
        }
        
        do {
            try userLogsCollection.document(log.id.uuidString).setData(from: log)
        } catch {
            print("Error saving log to Firestore: \(error)")
        }
    }
    
    private func setupFirestoreListener() {
        listener?.remove()
        
        listener = userLogsCollection.order(by: "date", descending: false).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let documents = querySnapshot?.documents else {
                print("Error loading Firestore logs: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let firestoreLogs = documents.compactMap { doc -> SymptomLog? in
                try? doc.data(as: SymptomLog.self)
            }
            
            DispatchQueue.main.async {
                self.logs = firestoreLogs
                self.save()
            }
        }
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
