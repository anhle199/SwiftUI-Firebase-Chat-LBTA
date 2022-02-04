//
//  ChatBottomBar.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct ChatBottomBar: View {
    
    @Binding var chatText: String
    
    var body: some View {
        HStack(spacing: 12) {
            Button{
                
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .foregroundColor(Color(.label))
                    .font(.system(size: 24))
            }
            
            ZStack {
                TypingMessagePlaceholder()
                    .padding(.leading, 4)
                
                TextEditor(text: $chatText)
                    .opacity(chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 42)
            
            Button {
                self.chatText = "This message is sent"
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(Color(.label))
                    .font(.system(size: 24))
            }
        }
        .padding(.bottom, 4)
        .padding(.horizontal)
    }
 
    @ViewBuilder
    private func TypingMessagePlaceholder() -> some View {
        Text("Type message here")
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

struct ChatBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatBottomBar(chatText: .constant(""))
    }
}