//
//  ChatMessage.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 06/02/2022.
//

import Foundation

struct ChatMessage: Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let fromId: String
    let toId: String
    let text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.chatText] as? String ?? ""
    }
}
