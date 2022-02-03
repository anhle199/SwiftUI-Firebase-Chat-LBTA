//
//  FirebaseManager.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 02/02/2022.
//

import Firebase

// Applying singleton pattern
struct FirebaseManager {
    // Singleton object
    static let shared = FirebaseManager()
    
    // Firebase Authentication
    let auth: Auth
    
    // Firebase Storage
    let storage: Storage
    
    private init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
    }
}
