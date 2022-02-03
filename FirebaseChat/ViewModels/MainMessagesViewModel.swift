//
//  MainMessagesViewModel.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import Foundation

final class MainMessagesViewModel: ObservableObject {
    
    // Current user information
    @Published var currentUser: ChatUser?
    
    // This variable determines whether the current user is logged out or not
    @Published var isUserCurrentlyLoggedOut = false
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        print("Starts fetching current user")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    print("Error when fetching current user")
                    return
                }
                
                self.currentUser = ChatUser(from: data)
                print("Successfully fetched current user")
            }
    }
    
    func handleSignOut() {
        do {
            try FirebaseManager.shared.auth.signOut()
            isUserCurrentlyLoggedOut.toggle()
        } catch {
            print("Cannot log out of this account")
            print("Something went wrong, error: \(error)")
        }
    }
    
}
