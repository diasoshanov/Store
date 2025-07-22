//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 5.07.2025.
//


import Foundation
import FirebaseFirestore

@MainActor
class CatalogViewModel: ObservableObject {
    @Published var sneakers: [Sneaker] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var selectedCategory = "All"
    @Published var searchText = ""
    
    private let firestore = FirebaseManager.shared.firestore
    
    let categories = ["All", "Nike", "Adidas", "Puma", "New Balance", "Converse", "Off-White"]
    
    var filteredSneakers: [Sneaker] {
        var filtered = sneakers
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.brand == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { sneaker in
                sneaker.name.localizedCaseInsensitiveContains(searchText) ||
                sneaker.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    init() {
        
    }
    
    func fetchSneakers() async {
        isLoading = true
        errorMessage = ""
        
        do {
            let snapshot = try await firestore.collection("sneakers").getDocuments()
            print("Документов в snapshot: \(snapshot.documents.count)")
            for doc in snapshot.documents {
                do {
                    let sneaker = try doc.data(as: Sneaker.self)
                    sneakers.append(sneaker)
                } catch {
                    print("Ошибка декодирования документа id: \(doc.documentID)")
                    print("Данные документа: \(doc.data())")
                    print("Ошибка: \(error)")
                }
            }
            sneakers = snapshot.documents.compactMap { document in
                try? document.data(as: Sneaker.self)
            }
            print("Загружено кроссовок: \(sneakers.count)")
            for sneaker in sneakers {
                print("Кроссовка: \(sneaker.name)")
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Ошибка загрузки кроссовок: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func addToCart(sneaker: Sneaker, size: String, color: String) {
        CartViewModel.shared.addToCart(sneaker: sneaker, size: size, color: color)
    }
} 
