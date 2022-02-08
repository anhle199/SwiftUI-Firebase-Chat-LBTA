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
    
    // State variable determines whether to show log out option or not
    @State private var shouldShowLogOut = false
    
    // State variable determines whether to show create new message screen or not
    @State private var shouldShowNewMessagesScreen = false
    
    // State variable determines whether to show chat log view or not
    @State private var shouldNavigateToChatLogView = false
    
    // User will be selected to start conversation
    @State private var chatUser: ChatUser?
    
    var body: some View {
        NavigationView {
            VStack {
                // Customized navigation bar
                MainMessageNavigationBar(
                    viewModel: viewModel,
                    shouldShowLogOut: $shouldShowLogOut
                )
                
                // List of scrollable messages
                MainMessageListView(viewModel: viewModel)
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
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
            shouldShowNewMessagesScreen.toggle()
        } label: {
            Text("+ New Message")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                // make background color
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessagesScreen) {
            CreateNewMessageView(
                isPresented: $shouldShowNewMessagesScreen,
                didSelectUser: didSelecteNewUser
            )
        }
    }
    
    private func didSelecteNewUser(_ selectedUser: ChatUser) {
        self.chatUser = selectedUser
        self.shouldNavigateToChatLogView = true
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
