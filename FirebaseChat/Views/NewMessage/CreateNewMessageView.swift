//
//  CreateNewMessageView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct CreateNewMessageView: View {
    
    // View model
    @ObservedObject private var viewModel = CreateNewMessageViewModel()
    
    // Binding variable determines whether create new message screen is presented or not
    @Binding var isPresented: Bool
    
    // A callback function uses to get selected chat user
    let didSelectUser: (ChatUser) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.users) { user in
                    VStack {
                        // Message row button
                        Button{
                            self.isPresented = false
                            didSelectUser(user)
                        } label: {
                            CreateNewMessageRow(user: user)
                                .foregroundColor(Color(.label))
                        }
                        
                        // Separator of each messages
                        Divider()
                            .padding(.vertical, 8)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView(
            isPresented: .constant(true),
            didSelectUser: { _ in }
        )
    }
}
