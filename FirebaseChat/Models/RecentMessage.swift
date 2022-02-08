//
//  RecentMessage.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 08/02/2022.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let fromId: String
    let toId: String
    let chatText: String
    let sentAt: Timestamp
    let chatName: String
    let profileImageUrl: String
    
    init(docId documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.chatText = data[FirebaseConstants.chatText] as? String ?? ""
        self.sentAt = data[FirebaseConstants.sentAt] as? Timestamp ?? Timestamp()
        self.chatName = data[FirebaseConstants.chatName] as? String ?? ""
        self.profileImageUrl = data[FirebaseConstants.profileImageUrl] as? String ?? ""
    }
}
