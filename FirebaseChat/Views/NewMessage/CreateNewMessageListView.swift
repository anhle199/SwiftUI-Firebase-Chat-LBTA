//
//  CreateNewMessageListView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct CreateNewMessageListView: View {
    
    // Binding variable determines whether create new message screen is presented or not
    @Binding var isPresented: Bool
    
    // List of chat users information
    @Binding var users: [ChatUser]
    
    var body: some View {
        ScrollView {
            ForEach(users) { user in
                VStack {
                    // Message row
                    CreateNewMessageRow(isPresented: $isPresented, user: user)
                    
                    // Separator of each messages
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CreateNewMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageListView(isPresented: .constant(true), users: .constant([]))
    }
}
