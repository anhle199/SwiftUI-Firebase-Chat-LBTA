//
//  ChatLogView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct ChatLogView: View {
    
    // View model
    @ObservedObject var viewModel: ChatLogViewModel
    
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
        .navigationTitle(viewModel.chatUser?.chatName ?? "Username")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.firestoreListener?.remove()
            viewModel.chatUser = nil
            viewModel.chatText = ""
            viewModel.chatMessages.removeAll()
        }
    }
    
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(viewModel: ChatLogViewModel())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
