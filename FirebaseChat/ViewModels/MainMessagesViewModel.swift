//
//  MainMessagesViewModel.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class MainMessagesViewModel: ObservableObject {
    
    // Current user information
    @Published var currentUser: ChatUser?
    
    // This variable determines whether the current user is logged out or not
    @Published var isUserCurrentlyLoggedOut = false
    
    // List of recent messages of the current user.
    @Published var recentMessages = [RecentMessage]()
    
    // This variable can be used to remove firestore snapshot listener
    private var firestoreListener: ListenerRegistration?
    
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
            .getDocument { snapshot, err in
                if let err = err {
                    print("Error when fetching current user, error: \(err)")
                    return
                }

                do {
                    if let currentUser = try snapshot?.data(as: ChatUser.self) {
                        self.currentUser = currentUser
                        FirebaseManager.shared.currentUser = currentUser
                        print("Successfully fetched current user")
                    }
                } catch {
                    print("Error when decoding chat user information, error: \(error)")
                }
            }
    }
    
    func fetchRecentMessages() {        
        guard let uid = FirebaseManager.currentUserID else {
            return
        }
        
        // Remove a snapshot listener to listening recent messages
        firestoreListener?.remove()
        
        // Remove all currently recent messages to fetch the new list
        self.recentMessages.removeAll()

        self.firestoreListener = FirebaseManager.shared.firestore
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
                        where: { $0.id == documentId }
                    ) {
                        self.recentMessages.remove(at: index)
                    }
                     
                    if change.type == .added || change.type == .modified {
                        do {
                            // Insert newly recent message
                            if let recentMessage = try change.document.data(
                                as: RecentMessage.self
                            ) {
                                self.recentMessages.insert(recentMessage, at: 0)
                                print("Fetching recent message, at: \(Date())")
                            }
                        } catch {
                            print("Error when decoding Recent Message object, error: \(error)")
                        }
                    }
                }
            }
        
    }
    
    func handleSignOut() {
        do {
            // Sign out
            try FirebaseManager.shared.auth.signOut()
            isUserCurrentlyLoggedOut.toggle()

            // Remove a snapshot listener to listening recent messages
            firestoreListener?.remove()
            
            // Remove all currently recent messages to fetch the new list
            self.recentMessages.removeAll()
            
            //
            FirebaseManager.shared.currentUser = nil
        } catch {
            print("Cannot log out of this account")
            print("Something went wrong, error: \(error)")
        }
    }
    
}
