import Foundation

struct Order: Identifiable, Codable {
    let id: String
    let items: [CartItem]
    let totalPrice: Double
    let date: Date
} 