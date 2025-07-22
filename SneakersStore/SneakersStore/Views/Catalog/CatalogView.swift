//
//  CategoryButton.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 6.07.2025.
//


import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @State private var showingFilters = false
    @StateObject private  var authViewModel = AuthViewModel()
    @StateObject private var cartViewModel = CartViewModel.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            CategoryButton(
                                title: category,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Products grid
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.filteredSneakers.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(viewModel.filteredSneakers) { sneaker in
                                NavigationLink(destination: SneakerDetailView(sneaker: sneaker)) {
                                    SneakerCard(cartViewModel: cartViewModel, sneaker: sneaker)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Hello \(authViewModel.user?.name ?? "")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingFilters = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(viewModel: viewModel)
        }
        .onAppear {
            if viewModel.sneakers.isEmpty {
                Task {
                    await viewModel.fetchSneakers()
                }
            }
        }
    }
}






#Preview {
    CatalogView()
} 
