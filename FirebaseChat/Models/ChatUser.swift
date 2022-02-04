//
//  ChatUser.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import Foundation

struct ChatUser: Identifiable, Equatable {
    let uid: String
    let email: String
    let chatName: String
    let imageProfileUrl: String
    
    var id: String {
        return uid
    }
    
    init(from data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.chatName = data["chatName"] as? String ?? ""
        self.imageProfileUrl = data["imageProfileUrl"] as? String ?? ""
    }
}
