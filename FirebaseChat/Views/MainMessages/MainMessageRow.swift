//
//  MainMessageRow.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessageRow: View {
    
    let recentMessage: RecentMessage
    
    init(with recentMessage: RecentMessage) {
        self.recentMessage = recentMessage
    }
    
    var body: some View {
        // Message row
        HStack(spacing: 16) {
            // Sent user's avatar
            WebImage(url: URL(string: recentMessage.profileImageUrl))
                .placeholder {
                    Image(systemName: ImageConstants.defaultAvatarName)
                        .font(.system(size: 32))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipped()
                .cornerRadius(64)
                .overlay(
                    RoundedRectangle(cornerRadius: 64)
                        .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            // Sent user's information
            VStack(alignment: .leading, spacing: 4) {
                Text(recentMessage.chatName)
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                
                let prefix = getPrefixOfRecentMessage(senderID: recentMessage.fromId)
                Text(prefix + recentMessage.text)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Duration from the last message which is sent
            Text(recentMessage.timeAgo)
                .font(.system(size: 14, weight: .semibold))
        }
    }
    
    func getPrefixOfRecentMessage(senderID: String) -> String {
        return recentMessage.fromId == FirebaseManager.currentUserID ? "You: " : ""
    }
}

struct MainMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageRow(
            with: .init(
                id: "",
                fromId: "",
                toId: "",
                text: "jknaskdfnasjkdnfkjasdfjkasndfjkansdjkfnasjkdfnkasjdfkjasndfkjansdkfjnasdkjfnkasjdnf",
                sentAt: Date(),
                chatName: "Pikachu",
                profileImageUrl: ""
            )
        )
    }
}
