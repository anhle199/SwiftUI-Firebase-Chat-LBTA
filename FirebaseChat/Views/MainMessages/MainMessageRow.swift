//
//  MainMessageRow.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI

struct MainMessageRow: View {
    
    let profileImage: String
    let username: String
    let lastMessage: String
    
    var body: some View {
        // Message row
        HStack(spacing: 16) {
            // Sent user's avatar
            Image(systemName: profileImage)
                .font(.system(size: 32))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(.label), lineWidth: 1)
                )
            
            // Sent user's information
            VStack(alignment: .leading) {
                Text(username)
                    .font(.system(size: 16, weight: .bold))
                
                Text(lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.lightGray))
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
            profileImage: "person.fill",
            username: "Username",
            lastMessage: "Message sent to user"
        )
    }
}
