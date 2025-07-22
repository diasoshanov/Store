//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 8.07.2025.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var cartViewModel = CartViewModel.shared
    
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Catalog")
                }
            
            CartView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
                .badge(cartViewModel.itemCount > 0 ? cartViewModel.itemCount : 0)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    MainTabView()
} 
