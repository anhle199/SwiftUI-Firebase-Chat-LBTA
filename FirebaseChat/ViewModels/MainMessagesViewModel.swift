//
//  MainMessagesViewModel.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import Foundation

struct ChatUser: Identifiable {
    let uid: String
    let email: String
    let chatName: String
    let imageProfileUrl: String
    
    var id: String {
        return uid
    }
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var currentUser: ChatUser?
    @Published var errorMessage: String
    
    init() {
        self.errorMessage = ""
        
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        self.errorMessage = "Starts fetching current user"
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    self.errorMessage = "Error when fetching current user"
                    return
                }
                
                self.currentUser = ChatUser(
                    uid: data["uid"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    chatName: data["chatName"] as? String ?? "",
                    imageProfileUrl: data["imageProfileUrl"] as? String ?? ""
                )
                self.errorMessage = "Successfully fetched current user"
            }
    }
    
}
