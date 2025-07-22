//
//  CartItemView.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 20.07.2025.
//

import SwiftUI

struct CartItemView: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            AsyncImage(url: URL(string: item.sneaker.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 140, height: 140)
            .clipped()
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.sneaker.brand)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(item.sneaker.name)
                    .font(.caption)
                    .lineLimit(2)
                
                HStack {
                    Text("$\(Int(item.sneaker.price))")
                        .font(.system(size:12))
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                // Quantity controls
                    HStack(spacing: 8) {
                        Button(action: {
                            if item.quantity > 1 {
                                onQuantityChange(item.quantity - 1)
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(item.quantity > 1 ? .white : .gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(item.quantity <= 1)
                        
                        Text("\(item.quantity)")
                            .foregroundStyle(Color.white)
                            .fontWeight(.medium)
                            .frame(minWidth: 30)
                        
                        Button(action: {
                            onQuantityChange(item.quantity + 1)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.frame(width: 166, height: 36)
                        .background(Color.black)
                        .cornerRadius(18)
                        .padding(.top,10)
                
            }
            
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(4)
    }
}



