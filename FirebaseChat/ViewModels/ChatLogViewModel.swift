//
//  ChatLogViewModel.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import Foundation
import Firebase

final class ChatLogViewModel: ObservableObject {
    
    // Specific conversation information
    @Published var chatMessages = [ChatMessage]()
    @Published var chatText: String
    let chatUser: ChatUser?
    
    //
    @Published var fireAutoScrolling = false
    
    init(chatUser: ChatUser?) {
        self.chatText = ""
        self.chatUser = chatUser
        
        // Fetch all messages of receiver's conversation
        fecthMessages()
    }
    
    private func fecthMessages() {
        guard let fromId = FirebaseManager.currentUserID,
              let toId = chatUser?.uid
        else {
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.sentAt)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Failed to listen to messages: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach { change in
                    if change.type == .added {
                        self.chatMessages.append(
                            ChatMessage(
                                documentId: change.document.documentID,
                                data: change.document.data()
                            )
                        )
                    }
                }

                // Performs automatically scroll
                DispatchQueue.main.async {
                    self.fireAutoScrolling.toggle()
                }
            }
        
    }
    
    func handSendMessage() {
        // If the message only contains whitespace or new line character, it will not be sent
        if chatText.allSatisfy({ $0.isNewline || $0.isWhitespace }) {
            self.chatText = ""
            return
        }
        
        guard let fromId = FirebaseManager.currentUserID,
              let toId = chatUser?.uid
        else {
            return
        }
        
        // Message data
        let now = Timestamp()
        let messageData: [String: Any] = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.chatText: chatText,
            FirebaseConstants.sentAt: now,
        ]
        
        // Get sender document
        let senderDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        // Starts saving message at the sender side
        senderDocument.setData(messageData) { error in
            if let error = error {
                print("Error when saving message which is sent from \(fromId) to \(toId), error: \(error)")
                return
            }


            self.persistRecentMessage(at: now)
            self.chatText = ""
            print("Successfully saved message at the sender side")
            
            // Performs automatically scroll
            DispatchQueue.main.async {
                self.fireAutoScrolling.toggle()
            }
        }
    
        // Get receiver document
        let receiverDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        // Starts saving message at the receiver side
        receiverDocument.setData(messageData) { error in
            if let error = error {
                print("Error when saving message which is sent from \(fromId) to \(toId), error: \(error)")
                return
            }
            
            print("Successfully saved message at the receiver side")
        }
    }
    
    private func persistRecentMessage(at sentAt: Timestamp) {
        guard let chatUser = chatUser,
              let fromId = FirebaseManager.currentUserID
        else {
            return
        }
        
        let toId = chatUser.uid
        
        // Recent message information is saved at the sender side
        let senderData: [String: Any] = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.chatText: chatText,
            FirebaseConstants.sentAt: sentAt,
            FirebaseConstants.chatName: chatUser.chatName,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
        ]
        
        // Starts saving at the sender side
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(fromId)
            .collection("messages")
            .document(toId)
            .setData(senderData) { error in
                if let error = error {
                    print("Failed to save recent message, error: \(error)")
                    return
                }
            }
       
        // Get the current user information
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        
        // Recent message information is saved at the receiver side
        let receiverData: [String: Any] = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.chatText: chatText,
            FirebaseConstants.sentAt: sentAt,
            FirebaseConstants.chatName: currentUser.chatName,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
        ]
        
        // Starts saving at the receiver side
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(fromId)
            .setData(receiverData) { error in
                if let error = error {
                    print("Failed to save recent message, error: \(error)")
                    return
                }
            }
    }
    
}
