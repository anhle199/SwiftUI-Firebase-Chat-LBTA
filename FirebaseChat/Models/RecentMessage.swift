//
//  RecentMessage.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 08/02/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let fromId: String
    let toId: String
    let text: String
    let sentAt: Date
    let chatName: String
    let profileImageUrl: String
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.calendar.timeZone = .autoupdatingCurrent
        
        return formatter.string(for: sentAt) ?? sentAt.description
    }
}
