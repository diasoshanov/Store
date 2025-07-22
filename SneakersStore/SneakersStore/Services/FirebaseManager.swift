//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 10.07.2025.
//


import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    let auth: Auth
    let firestore: Firestore
    let storage: Storage
    
    private init() {
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
    }
}

extension FirebaseManager {
    func configure() {
        
    }
} 

