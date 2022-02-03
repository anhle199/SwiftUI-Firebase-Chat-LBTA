//
//  MainMessageListView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI

struct MainMessageListView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<19, id: \.self) { _ in
                VStack {
                    MainMessageRow(
                        profileImage: "person.fill",
                        username: "Username",
                        lastMessage: "Message sent to user"
                    )
                    
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
        MainMessageListView()
    }
}
