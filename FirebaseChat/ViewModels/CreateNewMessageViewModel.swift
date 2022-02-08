//
//  CreateNewMessageViewModel.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 04/02/2022.
//

import Foundation
import SDWebImageSwiftUI
import FirebaseFirestoreSwift

final class CreateNewMessageViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    
    init() {
        fetchAllUsers()
    }
    
    func fetchAllUsers() {
        guard let uid = FirebaseManager.currentUserID else {
            print("Cannot get current user id")
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("users")
            .whereField("uid", isNotEqualTo: uid)
            .getDocuments { documentsSnapshot, err in
                guard let documentsSnapshot = documentsSnapshot, err == nil
                else {
                    print("Cannot get documents from firestore")
                    return
                }
                
                documentsSnapshot.documents.forEach { snapshot in
                    do {
                        if let chatUser = try snapshot.data(as: ChatUser.self) {
                            self.users.append(chatUser)
                        }
                    } catch {
                        print("Error when decoding chat user information, error: \(error)")
                    }
                }
            }
    }
}
