//
//  ChatUser.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import Foundation

struct ChatUser: Identifiable, Equatable, Codable {
    let uid: String
    let email: String
    let chatName: String
    let profileImageUrl: String
    
    var id: String {
        return uid
    }
}
