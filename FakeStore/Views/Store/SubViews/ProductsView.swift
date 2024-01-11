//
//  ProductsView.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI
import SwiftData

struct ProductsView: View {
    // MARK: - PROPERTIES
    @Environment(StoreViewModel.self) var viewModel
    @Environment(ErrorManager.self) var errorManager
    
    var productListingGridLayout: GridItems
    
    init(productListingGridLayout: GridItems) {
        self.productListingGridLayout = productListingGridLayout
    }
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: Array(repeating: GridItem(spacing: 10), count: 1)) {
                        ForEach(viewModel.categories) { category in
                            // MARK: - HOME CATEGORIES GRID CELL VIEW
                            CategoriesGridCellView(category: category, onTap: {
                                Task {
                                    await viewModel.set(category: category)
                                }
                            }) // HOME CATEGORIES GRID CELL VIEW
                        } // LOOP
                    } // LAZY H GRID
                    .padding(.horizontal)
                } // SCROLL VIEW
                .frame(height: 80)
                
                ScrollView {
                    // MARK: - PRODUCT LISTING VIEW
                    ProductListingView(gridLayout: productListingGridLayout,
                                       category: viewModel.categories.first(where: { $0.isSelected ?? false })?.name ?? "All",
                                       size: geo.size.width)
                } // SCROLL VIEW
                .refreshable {
                    Task {
                        do {
                            try await viewModel.refreshData()
                        } catch {
                            errorManager.handle(error: error)
                        }
                    }
                } // REFRESHABLE
            } // HSTACK
        } // GEOMETRY READER
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ProductsView(productListingGridLayout: Array(repeating: GridItem(spacing: 10), count: 1))
        .environment(StoreViewModel(service: StoreService(manager: MocNetworkManager())))
        .environment(ErrorManager())
}
