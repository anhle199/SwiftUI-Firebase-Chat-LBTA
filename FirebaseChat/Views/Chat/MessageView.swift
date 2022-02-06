//
//  MessageView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 06/02/2022.
//

import SwiftUI

struct MessageView: View {
    
    private let message: ChatMessage
    private let isAtRightSide: Bool
    private let textColor: Color
    private let backgroundColor: Color
    
    init(_ message: ChatMessage, atRightSide isAtRightSide: Bool) {
        self.message = message
        self.isAtRightSide = isAtRightSide
        self.textColor = isAtRightSide ? .white : .black
        self.backgroundColor = isAtRightSide ? Color.blue : Color.white
    }
    
    var body: some View {
        HStack {
            if isAtRightSide {
                Spacer()
            }
            
            Text(message.text)
                .foregroundColor(textColor)
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
            
            if !isAtRightSide {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(ChatMessage(documentId: "", data: [:]), atRightSide: true)
    }
}
