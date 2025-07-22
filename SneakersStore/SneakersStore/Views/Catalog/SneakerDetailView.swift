import SwiftUI

struct SneakerDetailView: View {
    let sneaker: Sneaker
    @State private var selectedSize = ""
    @State private var selectedColor = ""
    @State private var showingSizeAlert = false
    @State private var showingColorAlert = false
    @State private var showingAddedToCart = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image
                AsyncImage(url: URL(string: sneaker.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(height: 300)
                .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(sneaker.brand)
                            .font(.title)
                            .fontWeight(.bold)
                            
                        
                        Text(sneaker.name)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    
                    // Rating
                    HStack {
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(sneaker.rating) ? "star.fill" : "star")
                                    .foregroundColor(.black)
                            }
                        }
                        Text(String(format: "%.1f", sneaker.rating))
                            .font(.subheadline)
                        Text("(\(sneaker.reviewsCount) отзывов)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Price
                    Text("$\(Int(sneaker.price))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Description
                    Text(sneaker.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Size selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Size")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(sneaker.sizes, id: \.self) { size in
                                SizeButton(
                                    size: size,
                                    isSelected: selectedSize == size
                                ) {
                                    selectedSize = size
                                }
                            }
                        }
                    }
                    
                    // Color selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(sneaker.colors, id: \.self) { color in
                                ColorButton(
                                    color: color,
                                    isSelected: selectedColor == color
                                ) {
                                    selectedColor = color
                                }
                            }
                        }
                    }
                    
                    // Add to cart button
                    Button(action: addToCart) {
                        Text("Add to cart")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canAddToCart ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!canAddToCart)
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Select size", isPresented: $showingSizeAlert) {
            Button("OK") { }
        }
        .alert("Select Colot", isPresented: $showingColorAlert) {
            Button("OK") { }
        }
        .alert("Add to cart", isPresented: $showingAddedToCart) {
            Button("OK") { }
        }
    }
    
    private var canAddToCart: Bool {
        !selectedSize.isEmpty && !selectedColor.isEmpty 
    }
    
    private func addToCart() {
        if selectedSize.isEmpty {
            showingSizeAlert = true
            return
        }
        
        if selectedColor.isEmpty {
            showingColorAlert = true
            return
        }
        
        CartViewModel.shared.addToCart(sneaker: sneaker, size: selectedSize, color: selectedColor)
        showingAddedToCart = true
    }
}

struct SizeButton: View {
    let size: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(size)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

struct ColorButton: View {
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(color)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationView {
        SneakerDetailView(sneaker: Sneaker(
            name: "Air Max 270",
            brand: "Nike",
            price: 129,
            description: "Кроссовки Nike Air Max 270 обеспечивают максимальный комфорт и стильный внешний вид.",
            imageURL: "https://ibb.co/XRPLWRF",
            sizes: ["39", "40", "41", "42", "43", "44"],
            colors: ["Черный", "Белый", "Красный"],
            category: "Nike",
            rating: 4.5,
            reviewsCount: 128
        ))
    }
} 
