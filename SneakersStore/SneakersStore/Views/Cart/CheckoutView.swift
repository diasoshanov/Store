//
//  CheckoutView.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 20.07.2025.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cartViewModel = CartViewModel.shared
    @State private var showingSuccess = false
    @State private var isOrderPlaced = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Image("image1")
                    .resizable()
                    .frame(width: 350, height: 200)
                    .offset(x:-50, y: -100)
                    .scaledToFill()
            
                
                Text("Your order is succesfully \nplaced. Thanks!")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Get back to shopping")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(32)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if !isOrderPlaced && !cartViewModel.cartItems.isEmpty {
                    cartViewModel.placeOrder { result in
                        switch result {
                        case .success:
                            isOrderPlaced = true
                        case .failure(let error):
                            errorMessage = "Order failed: \(error.localizedDescription)"
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CheckoutView()
}
