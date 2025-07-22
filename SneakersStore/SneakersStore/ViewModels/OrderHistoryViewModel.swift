import Foundation
import FirebaseFirestore

@MainActor
class OrderHistoryViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let firestore = FirebaseManager.shared.firestore
    private let auth = FirebaseManager.shared.auth

    func fetchOrders() async {
        guard let userId = auth.currentUser?.uid else { return }
        isLoading = true
        errorMessage = ""
        do {
            let snapshot = try await firestore.collection("orders").document(userId).collection("userOrders").getDocuments()
            orders = snapshot.documents.compactMap { doc in
                try? doc.data(as: Order.self)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
} 