//
//  CreateNewMessageViewModel.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import Foundation
import SDWebImageSwiftUI

final class CreateNewMessageViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    
    init() {
        fetchAllUsers()
    }
    
    func fetchAllUsers() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Cannot get current user id")
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("users")
            .whereField("uid", isNotEqualTo: uid)
            .getDocuments { documentsSnapshot, error in
                guard let documentsSnapshot = documentsSnapshot, error == nil
                else {
                    print("Cannot get documents from firestore")
                    return
                }
                
                documentsSnapshot.documents.forEach { snapshot in
                    self.users.append(ChatUser(from: snapshot.data()))
                }
            }
    }
}
