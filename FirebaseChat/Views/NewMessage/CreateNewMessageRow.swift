//
//  CreateNewMessageRow.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageRow: View {
    
    // Binding variable determines whether create new message screen is presented or not
    @Binding var isPresented: Bool
    
    // List of chat users information
    let user: ChatUser
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack(spacing: 16) {
                // User avatar image
                WebImage(url: URL(string: user.imageProfileUrl))
                    .placeholder {
                        Image(systemName: "person.fill")
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
            .foregroundColor(Color(.label))
        }
    }
}

struct CreateNewMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageRow(isPresented: .constant(true), user: .init(from: [:]))
    }
}
