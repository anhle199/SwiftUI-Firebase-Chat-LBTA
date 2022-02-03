//
//  LoginView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 01/02/2022.
//

import SwiftUI

struct LoginView: View {
    
    // State variable to navigate login or create account view
    @State var isLoginMode = false
    
    // State variables to get login or create account info from user
    @State var email = ""
    @State var password = ""
    
    // State variables to show and get avatar image from user
    @State var shouldShowImagePicker = false
    @State var avatarImage: UIImage?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Segment option views
                    // Choose an option to display login or create account view
                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("This is login page")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        // Avatar selection button
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = avatarImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 64)
                                    .stroke(.black, lineWidth: 3)
                            )
                        }
                    }
                    
                    Group {
                        // Email text field
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        // Password text field
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    // Login or create account button
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                    .cornerRadius(5)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(
                Color(UIColor(white: 0, alpha: 0.07))
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $avatarImage)
        }
    }
    
    
    // MARK: - Action Methods
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(
            withEmail: email,
            password: password
        ) { result, error in
            if let error = error {
                print("Failed to login user: \(error)")
                return
            }
            
            print("Successfully logged in user: \(result?.user.uid ?? "")")
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(
            withEmail: email,
            password: password
        ) { result, error in
            if let error = error {
                print("Failed to create account: \(error)")
                return
            }
           
            print("Successfully created user: \(result?.user.uid ?? "")")
            persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid,
              let imageData = avatarImage?.jpegData(compressionQuality: 0.5)
        else {
            return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        ref.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                print("Failed to push image to storage: \(error)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve downloadURL: \(error)")
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                
                if let url = url {
                    storeUserInformation(imageProfileUrl: url)
                }
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        // User data needs to store
        let userData = [
            "email": email,
            "uid": uid,
            "imageProfileUrl": imageProfileUrl.absoluteString
        ]
        
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .setData(userData) { error in
                if let error = error {
                    print("Failed to store user information in Firestore: \(error)")
                    return
                }
                
                print("Successfully stored user information in Firestore")
            }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
