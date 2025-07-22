import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: CatalogViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var minPrice = 0.0
    @State private var maxPrice = 50000.0
    @State private var selectedBrands: Set<String> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("Price") {
                    VStack {
                        HStack {
                            Text("$\(Int(minPrice))")
                            Spacer()
                            Text("$\(Int(maxPrice))")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                        RangeSlider(minValue: $minPrice, maxValue: $maxPrice, range: 0...50000)
                    }
                }
                
                Section("Brands") {
                    ForEach(viewModel.categories.filter { $0 != "All" }, id: \.self) { brand in
                        HStack {
                            Text(brand)
                            Spacer()
                            if selectedBrands.contains(brand) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedBrands.contains(brand) {
                                selectedBrands.remove(brand)
                            } else {
                                selectedBrands.insert(brand)
                            }
                        }
                    }
                }
                
                Section("Сортировка") {
                    Picker("Сортировать по", selection: .constant("Популярности")) {
                        Text("Популярности").tag("Популярности")
                        Text("Цене (по возрастанию)").tag("Цене (по возрастанию)")
                        Text("Цене (по убыванию)").tag("Цене (по убыванию)")
                        Text("Названию").tag("Названию")
                    }
                }
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Сбросить") {
                        minPrice = 0.0
                        maxPrice = 50000.0
                        selectedBrands.removeAll()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Применить") {
                        applyFilters()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func applyFilters() {
        // Apply filters to viewModel
        // This would update the filtering logic in CatalogViewModel
    }
}

struct RangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 4)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: CGFloat((maxValue - minValue) / (range.upperBound - range.lowerBound)) * geometry.size.width,
                           height: 4)
                    .offset(x: CGFloat((minValue - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width)
                
                HStack(spacing: 0) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat((minValue - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width - 10)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newValue = range.lowerBound + Double(value.location.x / geometry.size.width) * (range.upperBound - range.lowerBound)
                                    minValue = min(maxValue - 1000, max(range.lowerBound, newValue))
                                }
                        )
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat((maxValue - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width - 10)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newValue = range.lowerBound + Double(value.location.x / geometry.size.width) * (range.upperBound - range.lowerBound)
                                    maxValue = max(minValue + 1000, min(range.upperBound, newValue))
                                }
                        )
                }
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    FilterView(viewModel: CatalogViewModel())
} 
