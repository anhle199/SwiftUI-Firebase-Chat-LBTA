//
//  MainMessageNavigationBar.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI

struct MainMessageNavigationBar: View {
    
    // User information
    let profileImage: String
    let username: String
    
    // Binding variable whether determine to show log out option or not
    @Binding var shouldShowLogOut: Bool
    
    var body: some View {
        HStack {
            // Profile avatar
            Image(systemName: profileImage)
                .font(.system(size: 34, weight: .heavy))
            
            
            // User information
            VStack(alignment: .leading, spacing: 4) {
                // Username
                Text(username)
                    .font(.system(size: 24, weight: .bold))
                
                // Current status: online or offline
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
            
            // Log out button
            Button {
                shouldShowLogOut.toggle()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOut) {
            .init(
                title: Text("Are you sure you want to log out?"),
                message: nil,
                buttons: [
                    .destructive(Text("Log out"), action: {
                        print("Needs to handle log out")
                    }),
                    .cancel(),
                ]
            )
        }
    }
}

struct MainMessageNavigationbar_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageNavigationBar(
            profileImage: "person.fill",
            username: "Username",
            shouldShowLogOut: .constant(false)
        )
    }
}
