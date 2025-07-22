//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 5.07.2025.
//



import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class CartViewModel: ObservableObject {
    static let shared = CartViewModel()
    
    @Published var cartItems: [CartItem] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let firestore = FirebaseManager.shared.firestore
    private let auth = FirebaseManager.shared.auth
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var itemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    private init() {
        // Не загружаем данные при инициализации, так как пользователь может быть не авторизован
    }
    
    func addToCart(sneaker: Sneaker, size: String, color: String) {
        guard let userId = auth.currentUser?.uid else { return }
        
        let cartItemId = "\(sneaker.id ?? "")_\(size)_\(color)"
        
        if let existingIndex = cartItems.firstIndex(where: { $0.id == cartItemId }) {
            cartItems[existingIndex] = CartItem(
                id: cartItemId,
                sneaker: sneaker,
                size: size,
                color: color,
                quantity: cartItems[existingIndex].quantity + 1
            )
        } else {
            let newItem = CartItem(
                id: cartItemId,
                sneaker: sneaker,
                size: size,
                color: color,
                quantity: 1
            )
            cartItems.append(newItem)
        }
        
        saveCartToFirestore(userId: userId)
    }
    
    func removeFromCart(itemId: String) {
        cartItems.removeAll { $0.id == itemId }
        
        if let userId = auth.currentUser?.uid {
            saveCartToFirestore(userId: userId)
        }
    }
    
    func updateQuantity(itemId: String, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == itemId }) {
            if quantity <= 0 {
                print("Removing item with id: \(itemId)")
                cartItems.remove(at: index)
            } else {
                cartItems[index] = CartItem(
                    id: itemId,
                    sneaker: cartItems[index].sneaker,
                    size: cartItems[index].size,
                    color: cartItems[index].color,
                    quantity: quantity
                )
            }
        }
        if let userId = auth.currentUser?.uid {
            saveCartToFirestore(userId: userId)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
        
        if let userId = auth.currentUser?.uid {
            saveCartToFirestore(userId: userId)
        }
    }
    
    func loadCartItems() {
        guard let userId = auth.currentUser?.uid else { return }
        
        isLoading = true
        
        Task {
            do {
                let document = try await firestore.collection("carts").document(userId).getDocument()
                if let data = document.data(), let itemsData = data["items"] as? [[String: Any]] {
                    cartItems = itemsData.compactMap { itemData in
                        guard let id = itemData["id"] as? String,
                              let size = itemData["size"] as? String,
                              let color = itemData["color"] as? String,
                              let quantity = itemData["quantity"] as? Int,
                              let sneakerData = itemData["sneaker"] as? [String: Any],
                              let sneaker = try? Firestore.Decoder().decode(Sneaker.self, from: sneakerData) else {
                            return nil
                        }
                        
                        return CartItem(id: id, sneaker: sneaker, size: size, color: color, quantity: quantity)
                    }
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    // --- Добавлено: оформление заказа ---
    func placeOrder(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = auth.currentUser?.uid else { return }
        let firestore = FirebaseManager.shared.firestore
        let ref = firestore
            .collection("orders")
            .document(userId)
            .collection("userOrders")
            .document() // создаём новый документ

        let order = Order(id: ref.documentID, items: cartItems, totalPrice: totalPrice, date: Date())

        do {
            try ref.setData(from: order) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.clearCart()
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    

    
    private func saveCartToFirestore(userId: String) {
        Task {
            do {
                let itemsData = try cartItems.map { item in
                    [
                        "id": item.id,
                        "sneaker": try Firestore.Encoder().encode(item.sneaker),
                        "size": item.size,
                        "color": item.color,
                        "quantity": item.quantity
                    ]
                }
                
                try await firestore.collection("carts").document(userId).setData([
                    "items": itemsData,
                    "updatedAt": FieldValue.serverTimestamp()
                ])
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
} 
