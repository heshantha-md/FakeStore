//
//  ProductListingView.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/12/2023.
//

import SwiftUI
import SwiftData

struct ProductListingView: View {
    // MARK: - PROPERTIES
    @Environment(StoreViewModel.self) var viewModel
    
    var gridLayout: GridItems
    var category: String
    var size: Double
    
    // MARK: - BODY
    var body: some View {
        //gridColumns
        LazyVGrid(columns: gridLayout, spacing: 10) {
            ForEach(viewModel.filteredProducts != nil ? viewModel.filteredProducts ?? [] : viewModel.products) { product in
                // MARK: - HOME GRID CELL VIEW
                NavigationLink(value: navigationEndPoint.HomeGridDetailsView(product)) {
                    ProductGridCellView(product: product,
                                     size: size)
                }
            } // LOOP
        } // LAZY V GRID
        .navigationDestination(for: navigationEndPoint.self) { endPoint in
            switch endPoint {
            case .HomeGridDetailsView(let product):
                ProductDetailsView(product: product)
            }
        } // NAVIGATION DESTINATION
        .padding()
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ScrollView {
        ProductListingView(gridLayout: Array(repeating: GridItem(spacing: 10), count: 2),
                           category: "jewelery",
                           size: 100)
            .environment(StoreViewModel(service: StoreService(manager: MocNetworkManager())))
            .padding()
    }
}
