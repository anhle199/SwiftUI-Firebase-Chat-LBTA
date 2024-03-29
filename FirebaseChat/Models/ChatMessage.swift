//
//  ChatMessage.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 06/02/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let fromId: String
    let toId: String
    let text: String
    let sentAt: Date
}
