//
//  FirebaseManager.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 02/02/2022.
//

import Firebase
import FirebaseFirestore

// Applying singleton pattern
struct FirebaseManager {
    // Singleton object
    static let shared = FirebaseManager()
    
    // Get the ID of currently logged in user
    static var currentUserID: String? {
        return FirebaseManager.shared.auth.currentUser?.uid
    }
    
    // Firebase services
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    private init() {
        FirebaseApp.configure()
        
        // Initialize Firebase services
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
}
