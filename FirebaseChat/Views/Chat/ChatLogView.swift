//
//  ChatLogView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct ChatLogView: View {
    
    // Optional variable stores receiver information
    let chatUser: ChatUser?
    
    // View model
    @ObservedObject private var viewModel: ChatLogViewModel
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.viewModel = ChatLogViewModel(chatUser: chatUser)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // safeAreaInset modifier only available on the iOS 15.0 or later.
            if #available(iOS 15.0, *) {
                ChatLogMessageListView(viewModel: viewModel)
                    .background(Color(.init(white: 0.95, alpha: 1)))
                    .safeAreaInset(edge: .bottom) {
                        ChatBottomBar(
                            chatText: $viewModel.chatText,
                            didPressSendButton: viewModel.handSendMessage
                        )
                        .padding(.top, 4)
                        .background(
                            Color(.systemBackground)
                                .ignoresSafeArea()
                        )
                    }
            } else {
                ChatLogMessageListView(viewModel: viewModel)
                    .padding(.bottom, 8)  // padding for last message
                    .background(Color(.init(white: 0.95, alpha: 1)))
                
                Spacer()
                
                ChatBottomBar(
                    chatText: $viewModel.chatText,
                    didPressSendButton: viewModel.handSendMessage
                )
            }
        }
        .navigationTitle(chatUser?.chatName ?? "Username")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(
                chatUser: ChatUser(
                    uid: "",
                    email: "",
                    chatName: "",
                    profileImageUrl: ""
                )
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
