//
//  MainMessageRow.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessageRow: View {
    
    let profileImageUrl: String
    let username: String
    let lastMessage: String
    
    var body: some View {
        // Message row
        HStack(spacing: 16) {
            // Sent user's avatar
            WebImage(url: URL(string: profileImageUrl))
                .placeholder {
                    Image(systemName: "person.fill")
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
                Text(username)
                    .font(.system(size: 16, weight: .bold))
                
                Text(lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            
            Spacer()
            
            // Duration from the last message which is sent
            Text("19th")
                .font(.system(size: 14, weight: .semibold))
        }
    }
}

struct MainMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageRow(
            profileImageUrl: "",
            username: "Username",
            lastMessage: "Message sent to user"
        )
    }
}
