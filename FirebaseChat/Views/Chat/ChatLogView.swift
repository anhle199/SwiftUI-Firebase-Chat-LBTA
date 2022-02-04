//
//  ChatLogView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @State private var chatText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ChatLogMessageListView()
                .padding(.top, 1)

            Spacer()
            
            ChatBottomBar(chatText: $chatText)
        }
        .navigationTitle(chatUser?.chatName ?? "Username")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: ChatUser(
                from: [
                    "chatName": "Test Account 6",
                    "email": "testaccount6@gmail.com",
                    "imageProfileUrl": "https://firebasestorage.googleapis.com:443/v0/b/swiftui-firebase-chat-lbta.appspot.com/o/3A67ywYkxNg5TtMuULj8fYFFSWY2?alt=media&token=72c3eacc-6553-411f-b797-e750f2701837",
                    "uid": "3A67ywYkxNg5TtMuULj8fYFFSWY2",
                ]
            ))
        }
        .navigationViewStyle(StackNavigationViewStyle())
.previewInterfaceOrientation(.portrait)
    }
}
