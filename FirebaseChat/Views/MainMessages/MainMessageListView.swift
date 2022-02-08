//
//  MainMessageListView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI

struct MainMessageListView: View {
    
    // View model
    @ObservedObject var viewModel: MainMessagesViewModel
    
    let didSelectUser: (ChatUser) -> Void
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.recentMessages) { recentMessage in
                VStack {
                    let chatUser = ChatUser(
                        uid: recentMessage.fromId == FirebaseManager.currentUserID
                        ? recentMessage.toId
                        : recentMessage.fromId,
                        email: "Currently not yet",
                        chatName: recentMessage.chatName,
                        profileImageUrl: recentMessage.profileImageUrl
                    )
                    
                    Button {
                        self.didSelectUser(chatUser)
                    } label: {
                        MainMessageRow(with: recentMessage)
                            .foregroundColor(Color(.label))
                    }
                    
                    // Separator of each messages
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            .padding(.top, 5)
            .padding(.bottom, 50)
        }
    }
}

struct MainMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageListView(
            viewModel: MainMessagesViewModel(),
            didSelectUser: { _ in }
        )
    }
}
