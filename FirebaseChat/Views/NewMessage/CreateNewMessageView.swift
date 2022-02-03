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
    
    var body: some View {
        NavigationView {
            CreateNewMessageListView(
                isPresented: $isPresented,
                users: $viewModel.users
            )
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
        CreateNewMessageView(isPresented: .constant(true))
//            .preferredColorScheme(.dark)
    }
}
