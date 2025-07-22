//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 10.07.2025.
//


import Foundation
import FirebaseFirestore

struct Sneaker: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let brand: String
    let price: Double
    let description: String
    let imageURL: String
    let sizes: [String]
    let colors: [String]
    let category: String
    let rating: Double
    let reviewsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case brand
        case price
        case description
        case imageURL
        case sizes
        case colors
        case category
        case rating
        case reviewsCount
    }
}

struct CartItem: Identifiable, Codable {
    let id: String
    let sneaker: Sneaker
    let size: String
    let color: String
    let quantity: Int
    
    var totalPrice: Double {
        return sneaker.price * Double(quantity)
    }
}

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String
    let name: String?
    let phone: String?
    let address: String?
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case phone
        case address
        case profileImageURL
    }
} 
