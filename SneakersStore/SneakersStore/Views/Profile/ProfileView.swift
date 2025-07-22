//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 15.07.2025.
//


import SwiftUI

struct ProfileView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showingEditProfile = false
    @State private var showingOrderHistory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile header
                    VStack(spacing: 16) {
                        if let profileImageURL = authViewModel.user?.profileImageURL, !profileImageURL.isEmpty {
                            AsyncImage(url: URL(string: profileImageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.gray)
                                    )
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                )
                        }
                        
                        VStack(spacing: 4) {
                            Text(authViewModel.user?.name ?? "User")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(authViewModel.user?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    // Profile options
                    VStack(spacing: 16) {
                        ProfileOptionRow(
                            icon: "person.circle",
                            title: "Account information",
                            action: {
                                showingEditProfile = true
                            }
                        )
                        
                        ProfileOptionRow(
                            icon: "bag",
                            title: "Order history",
                            action: {
                                showingOrderHistory = true
                            }
                        )
                        
                      
                        ProfileOptionRow(
                            icon: "heart",
                            title: "Favorite",
                            action: {
                                // Navigate to favorites
                            }
                        )
                        
                        ProfileOptionRow(
                            icon: "questionmark.circle",
                            title: "Help",
                            action: {
                                // Navigate to help
                            }
                        )
                    }
                    .padding(.bottom,70)
                    
                  
                    Spacer()
                    
                    // Sign out button
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Sign Out")
                        .frame(width: 358, height: 54)
                        .foregroundColor(.white)
                        .background(Color(.black))
                        .cornerRadius(32)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: authViewModel.user)
        }
        .sheet(isPresented: $showingOrderHistory) {
            OrderHistoryView()
        }
    }
}

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .background(Color.white)
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    let user: User?
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var address = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Account Information") {
                    TextField("Name", text: $name)
                    TextField("Phone", text: $phone)
                    TextField("Adress", text: $address)
                        .keyboardType(.phonePad)
                }
                
                Section("Account") {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(user?.email ?? "")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save profile changes
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            name = user?.name ?? ""
            phone = user?.phone ?? ""
            address = user?.address ?? ""
        }
    }
}

#Preview {
    ProfileView()
} 
