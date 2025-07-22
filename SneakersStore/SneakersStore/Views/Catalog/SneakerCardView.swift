//
//  SneakerCard.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 15.07.2025.
//

import SwiftUI

struct SneakerCard: View {
    
    @ObservedObject var cartViewModel: CartViewModel
    
    let sneaker: Sneaker
    var isInCart: Bool {
        cartViewModel.cartItems.contains { $0.sneaker.id == sneaker.id }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: sneaker.imageURL)) { image in
                image
                    .resizable()
                    .frame(width: 166, height: 166)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(sneaker.brand)
                    .font(.headline)
                    .lineLimit(2)
                Text(sneaker.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("$\(Int(sneaker.price))")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                }
                Button(action: {
                    if isInCart {
                        if let item = cartViewModel.cartItems.first(where: { $0.sneaker.id == sneaker.id }) {
                            cartViewModel.removeFromCart(itemId: item.id)
                        }
                    } else {
                        let size = sneaker.sizes.first ?? ""
                        let color = sneaker.colors.first ?? ""
                        cartViewModel.addToCart(sneaker: sneaker, size: size, color: color)
                    }
                }) {
                    Text(isInCart ? "Remove" : "Add to cart")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 166, height: 36)
                        .background(isInCart ? Color.gray : Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
