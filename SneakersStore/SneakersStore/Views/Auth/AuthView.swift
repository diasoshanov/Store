//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 6.07.2025.
//


import SwiftUI

struct AuthViewWithMode: View {
    @State var isSignUp: Bool
    var onDismiss: () -> Void
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Button(action: { onDismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                }
                Spacer()
                Text(isSignUp ? "New User" : "Welcome back!")
                    .font(.system(size: 17, weight: .bold))
                    .frame(alignment: .center)
                    .padding(.trailing,130)
            }
            if isSignUp {
                SignUpView(authViewModel: authViewModel)
            } else {
                SignInView(authViewModel: authViewModel)
            }
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: .constant(!authViewModel.errorMessage.isEmpty)) {
            Button("OK") {
                authViewModel.errorMessage = ""
            }
        } message: {
            Text(authViewModel.errorMessage)
        }
    }
}

struct SignInView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 358,height: 48)
                    .background(Color.textFieldBg)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 358,height: 48)
                    .background(Color.textFieldBg)
                  
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    await authViewModel.signIn(email: email, password: password)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .font(.headline)
                        .frame(width: 358, height: 54)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(32)
                }
            }
            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
        }
    }
}

struct SignUpView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 358,height: 48)
                    .background(Color.textFieldBg)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 358,height: 48)
                    .background(Color.textFieldBg)
                
                SecureField("Repeat password", text: $confirmPassword)
                    .padding()
                    .frame(width: 358,height: 48)
                    .background(Color.textFieldBg)
        
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    await authViewModel.signUp(email: email, password: password)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign Up")
                        .font(.headline)
                        .frame(width: 358, height: 54)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(32)
                }
            }
            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
        }
    }
}
