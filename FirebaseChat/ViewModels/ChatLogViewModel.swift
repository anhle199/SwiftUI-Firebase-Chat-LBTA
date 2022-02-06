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
        let messageData: [String: Any] = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.chatText: chatText,
            FirebaseConstants.sentAt: Timestamp(),
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
    
}
