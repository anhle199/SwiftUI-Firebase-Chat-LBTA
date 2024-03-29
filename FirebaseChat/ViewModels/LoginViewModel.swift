//
//  LoginViewModel.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 03/02/2022.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    // User information
    @Published var chatName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var avatarImage: UIImage?
    
    // This variable will be true when the user is logged in or registered a new account.
    @Published var isLoggedInOrRegistered = false
    
    @Published var errorMessage = ""
    
    func handLoginOrCreateAccountButton(isLoginMode: Bool) {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(
            withEmail: email,   // "testaccount1@gmail.com",
            password: password  // "123123"
        ) { result, error in
            if let error = error {
                self.errorMessage = "Failed to login user: \(error)"
                return
            }
            
            self.isLoggedInOrRegistered = true
            self.errorMessage = "Successfully logged in user)"
        }
    }
    
    private func createNewAccount() {
        guard let _ = avatarImage else {
            self.errorMessage = "You must select an image"
            return
        }
 
        FirebaseManager.shared.auth.createUser(
            withEmail: email,
            password: password
        ) { result, error in
            if let error = error {
                self.errorMessage = "Failed to create account: \(error)"
                return
            }
            
            self.errorMessage = "Successfully created user"
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.currentUserID,
              let imageData = avatarImage?.jpegData(compressionQuality: 0.5)
        else {
            return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        ref.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                self.errorMessage = "Failed to push image to storage: \(error)"
                return
            }
            
            ref.downloadURL { [weak self] url, error in
                guard let safeSelf = self else {
                    return
                }
                
                if let error = error {
                    safeSelf.errorMessage = "Failed to retrieve downloadURL: \(error)"
                    return
                }
                
                safeSelf.errorMessage = "Successfully stored image with url"
                
                if let url = url {
                    safeSelf.storeUserInformation(profileImageUrl: url)
                }
            }
        }
    }
    
    private func storeUserInformation(profileImageUrl: URL) {
        guard let uid = FirebaseManager.currentUserID else {
            return
        }
        
        // User data needs to store
        let userData = ChatUser(
            uid: uid,
            email: email,
            chatName: chatName,
            profileImageUrl: profileImageUrl.absoluteString
        )
        
        // Reference to firestore document object
        let docRef = FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
        
        do {
            try docRef.setData(from: userData) { error in
                if let error = error {
                    self.errorMessage = "Failed to store user information in Firestore: \(error)"
                    return
                }
                
                self.isLoggedInOrRegistered = true
                self.errorMessage = "Successfully stored user information in Firestore"
            }
        } catch {
            print("Error when encoding chat user information, error: \(error)")
        }
    }
    
}
