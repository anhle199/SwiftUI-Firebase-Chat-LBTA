//
//  LoginView.swift
//  FirebaseChat
//
//  Created by Le Hoang Anh on 01/02/2022.
//

import SwiftUI

struct LoginView: View {
    
    // View model
    @ObservedObject private var viewModel = LoginViewModel()
    
    // State variable to navigate login or create account view
    @State private var isLoginMode = false
    
    // State variables to show and get avatar image from user
    @State private var shouldShowImagePicker = false
    
    let didCompleteLogInAndRegisterProcess: () -> Void
    
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
                                if let image = viewModel.avatarImage {
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
                        if !isLoginMode {
                            // Chat name text field
                            TextField("Chat name", text: $viewModel.chatName)
                        }
                        
                        // Email text field
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        // Password text field
                        SecureField("Password", text: $viewModel.password)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    // Login or create account button
                    Button {
                        if isLoginMode {
                            viewModel.loginUser()
                        } else {
                            viewModel.createNewAccount()
                        }
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
                    .onChange(
                        of: viewModel.isLoggedInOrRegistered
                    ) { isLoggedInOrRegistered in
                        if isLoggedInOrRegistered {
                            didCompleteLogInAndRegisterProcess()
                        }
                    }
                    
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
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
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $viewModel.avatarImage)
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLogInAndRegisterProcess: {})
    }
}
