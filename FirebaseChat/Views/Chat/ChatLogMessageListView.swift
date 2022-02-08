//
//  ChatLogMessageListView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct ChatLogMessageListView: View {
    
    // View model of ChatLogView
    @ObservedObject var viewModel: ChatLogViewModel
    
    // A string is used to indicate id of a specific view for
    // automatically scroll to end
    private static let emptyScrollToLastMessage = "emptyScrollToLastMessage"
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    ForEach(viewModel.chatMessages) { message in
                        MessageView(
                            message,
                            atRightSide: message.fromId == FirebaseManager.currentUserID
                        )
                    }
                    
                    HStack(content: {})
                        .id(Self.emptyScrollToLastMessage)
                }
                .onReceive(viewModel.$fireAutoScrolling) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        proxy.scrollTo(
                            Self.emptyScrollToLastMessage,
                            anchor: .bottom
                        )
                    }
                }
            }
        }
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
                        "profileImageUrl": "https://firebasestorage.googleapis.com:443/v0/b/swiftui-firebase-chat-lbta.appspot.com/o/3A67ywYkxNg5TtMuULj8fYFFSWY2?alt=media&token=72c3eacc-6553-411f-b797-e750f2701837",
                        "uid": "3A67ywYkxNg5TtMuULj8fYFFSWY2",
                    ]
                )
            )
        )
            .background(Color(.init(white: 0.95, alpha: 1)))
    }
}
