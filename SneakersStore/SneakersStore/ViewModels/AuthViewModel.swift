//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 6.07.2025.
//



import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let auth = FirebaseManager.shared.auth
    private let firestore = FirebaseManager.shared.firestore
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                Task {
                    await self?.fetchUserData(userId: user.uid)
                    // Загружаем корзину после авторизации
                    CartViewModel.shared.loadCartItems()
                }
            } else {
                self?.isAuthenticated = false
                self?.user = nil
                // Очищаем корзину при выходе
                CartViewModel.shared.cartItems.removeAll()
            }
        }
    }
    
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let user = User(
                email: email,
                name: nil,
                phone: nil,
                address: nil,
                profileImageURL: nil
            )
            
            try await saveUserToFirestore(user: user, userId: result.user.uid)
            self.user = user
            self.isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            await fetchUserData(userId: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try auth.signOut()
            isAuthenticated = false
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveUserToFirestore(user: User, userId: String) async throws {
        try await firestore.collection("users").document(userId).setData([
            "email": user.email,
            "name": user.name,
            "phone": user.phone ?? "",
            "address": user.address ?? "",
            "profileImageURL": user.profileImageURL ?? ""
        ])
    }
    
    private func fetchUserData(userId: String) async {
        do {
            let document = try await firestore.collection("users").document(userId).getDocument()
            if let data = document.data() {
                let user = User(
                    id: userId,
                    email: data["email"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    phone: data["phone"] as? String,
                    address: data["address"] as? String,
                    profileImageURL: data["profileImageURL"] as? String
                )
                self.user = user
                self.isAuthenticated = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
} 
