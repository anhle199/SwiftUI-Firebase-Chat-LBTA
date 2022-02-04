//
//  ChatLogMessageListView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import SwiftUI

struct ChatLogMessageListView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<19) { number in
                HStack {
                    Spacer()
                    
                    Text("MESSAGE \(number)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.bottom, 8)
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
}

struct ChatLogMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogMessageListView()
    }
}
