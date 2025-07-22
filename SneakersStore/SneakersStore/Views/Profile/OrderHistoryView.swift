import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var viewModel = OrderHistoryViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.orders) { order in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Order #\(order.id.prefix(6))")
                        .font(.headline)
                    Text("Total: $\(Int(order.totalPrice))")
                        .font(.subheadline)
                    Text("Date: \(order.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Order History")
            .onAppear {
                Task { await viewModel.fetchOrders() }
            }
        }
    }
} 