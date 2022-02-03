//
//  MainMessagesView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI

struct MainMessagesView: View {
    
    // View model
    @ObservedObject private var viewModel = MainMessagesViewModel()
    
    // State variable whether determine to show log out option or not
    @State private var shouldShowLogOut = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Customized navigation bar
                MainMessageNavigationBar(
                    imageProfileUrl: viewModel.currentUser?.imageProfileUrl ?? "",
                    username: viewModel.currentUser?.chatName ?? "Username",
                    shouldShowLogOut: $shouldShowLogOut
                )
                
                // List of scrollable messages
                MainMessageListView()
            }
            .navigationBarHidden(true)
            .overlay(alignment: .bottom) {
                // Add new message button
                NewMessageButton()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private func NewMessageButton() -> some View {
        Button {
            
        } label: {
            Text("+ New Message")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                // make background color
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 10)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
//            .preferredColorScheme(.dark)
    }
}
