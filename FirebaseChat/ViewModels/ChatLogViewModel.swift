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
    @Published var chatText: String
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatText = ""
        self.chatUser = chatUser
        
        // Fetch all conversations
    }
    
    func handSendMessage() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid,
              let toId = chatUser?.uid
        else {
            return
        }
        
        // Message data
        let messageData: [String: Any] = [
            "fromId": fromId,
            "toId": toId,
            "text": chatText,
            "sentAt": Timestamp(),
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
