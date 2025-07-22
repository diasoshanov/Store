//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 8.07.2025.
//


import SwiftUI
import FirebaseFirestore

struct CartView: View {
    @StateObject private var cartViewModel = CartViewModel.shared
    @State private var showingCheckout = false
    
    var body: some View {
        NavigationView {
            VStack {
                if cartViewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if cartViewModel.cartItems.isEmpty {
                    Spacer()
                    ZStack{
                        Image("welcomeImg3")
                            .resizable()
                            .scaledToFill()
                            .offset(x:0,y:-110)
                    }
                    VStack(spacing: 16) {
                        Text("Cart is empty")
                            .font(.system(size: 28, weight: .bold))
                        Text("Find interesting models in the Catalog.")
                            .font(.system(size: 17, weight: .medium))
                        Spacer()
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(cartViewModel.cartItems) { item in
                            CartItemView(item: item) { quantity in
                                cartViewModel.updateQuantity(itemId: item.id, quantity: quantity)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let item = cartViewModel.cartItems[index]
                                cartViewModel.removeFromCart(itemId: item.id)
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    // Checkout section
                    VStack(spacing: 16) {
                        Divider()
                        
                        HStack {
                            Text("Total:")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("$\(Int(cartViewModel.totalPrice))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            showingCheckout = true
                        }) {
                            Text("Confirm Order")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(32)
                        }
                        .disabled(cartViewModel.cartItems.isEmpty)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                }
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !cartViewModel.cartItems.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Очистить") {
                            cartViewModel.clearCart()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCheckout) {
            CheckoutView()
                .presentationDetents([.height(538)])
        }
        .onAppear {
            if cartViewModel.cartItems.isEmpty && !cartViewModel.isLoading {
                cartViewModel.loadCartItems()
            }
        }
    }
}


#Preview {
    CartView()
} 
