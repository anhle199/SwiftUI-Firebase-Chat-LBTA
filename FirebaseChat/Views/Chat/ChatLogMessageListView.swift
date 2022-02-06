//
//  ChatLogMessageListView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct ChatLogMessageListView: View {
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.chatMessages) { message in
                let isRightSide = message.toId == viewModel.chatUser?.uid
                HStack {
                    if isRightSide {
                        Spacer()
                    }
                    
                    Text(message.text)
                        .foregroundColor(isRightSide ? .white : .black)
                        .padding()
                        .background(isRightSide ? Color.blue : Color.white)
                        .cornerRadius(8)
                    
                    if !isRightSide {
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.bottom, 8)
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
}

struct ChatLogMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogMessageListView(
            viewModel: ChatLogViewModel(
                chatUser: ChatUser(
                    from: [
                        "chatName": "Test Account 6",
                        "email": "testaccount6@gmail.com",
                        "imageProfileUrl": "https://firebasestorage.googleapis.com:443/v0/b/swiftui-firebase-chat-lbta.appspot.com/o/3A67ywYkxNg5TtMuULj8fYFFSWY2?alt=media&token=72c3eacc-6553-411f-b797-e750f2701837",
                        "uid": "3A67ywYkxNg5TtMuULj8fYFFSWY2",
                    ]
                )
            )
        )
    }
}
