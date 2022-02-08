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
            viewModel: ChatLogViewModel()
        )
            .background(Color(.init(white: 0.95, alpha: 1)))
    }
}
