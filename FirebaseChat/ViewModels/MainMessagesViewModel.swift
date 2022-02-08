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
    
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.currentUserID == nil
        }
        
        if !isUserCurrentlyLoggedOut {
            fetchCurrentUser()
            fetchRecentMessages()
        }
    }
    
    func fetchCurrentUser() {
        print("Starts fetching current user")
        guard let uid = FirebaseManager.currentUserID else {
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
                FirebaseManager.shared.currentUser = self.currentUser
                print("Successfully fetched current user")
            }
    }
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.currentUserID else {
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: FirebaseConstants.sentAt)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Failed to listen to recent messages: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach { change in
                    let documentId = change.document.documentID
                    
                    // Remove recent message
                    if let index = self.recentMessages.firstIndex(
                        where: { $0.documentId == documentId }
                    ) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    if change.type == .added || change.type == .modified {
                        // Insert newly recent message
                        self.recentMessages.insert(
                            RecentMessage(
                                docId: documentId,
                                data: change.document.data()
                            ),
                            at: 0
                        )
                    }
                }
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
