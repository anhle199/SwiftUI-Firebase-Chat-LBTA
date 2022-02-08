//
//  CreateNewMessageRow.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageRow: View {
    
    // User information
    let user: ChatUser
    
    var body: some View {
        HStack(spacing: 16) {
            // User avatar image
            WebImage(url: URL(string: user.profileImageUrl))
                .placeholder {
                    Image(systemName: ImageConstants.defaultAvatarName)
                        .font(.system(size: 34, weight: .heavy))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color(.label), lineWidth: 2)
                )
                .shadow(radius: 5)
            
            // User information
            VStack(alignment: .leading, spacing: 4) {
                Text(user.chatName)
                    .font(.system(size: 16, weight: .bold))
                
                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct CreateNewMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageRow(
            user: ChatUser(
                uid: "",
                email: "",
                chatName: "",
                profileImageUrl: ""
            )
        )
    }
}
