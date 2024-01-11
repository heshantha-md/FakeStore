//
//  FavoritesView.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    // MARK: - PROPERTIES
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Category.name) private var categories: Categories
    @Query(filter: #Predicate<Product> { product in
        product.isFavorite == true
    }, sort: \Product.title, order: .reverse) private var products: Products
    
    @State private var viewModel = StoreViewModel()
    @State private var productListingGridLayout: GridItems = []
    
    init(service: StoreService) {
        viewModel = StoreViewModel(service: service)
    }
    
    // MARK: - BODY
    var body: some View {
        // MARK: - PRODUCT VIEW
        ProductsView(productListingGridLayout: productListingGridLayout)
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CartToolBarItem()
                }
                
                ToolbarItem {
                    GridToolBarItem(didChageLayout: { layout in
                        productListingGridLayout = layout
                    })
                }
            } // TOOLBAR
            .onChange(of: categories, initial: true) {
                Task {
                    await viewModel.set(categories: categories)
                }
            } // ON CHANGE
            .onChange(of: products, initial: true) {
                Task {
                    await viewModel.set(products: products)
                }
            } // ON CHANGE
            .onChange(of: viewModel.categories) {
                Task {
                    await self.sync(newCategories: viewModel.categories, with: categories, in: modelContext)
                }
            } // ON CHANGE
            .onChange(of: viewModel.products) {
                Task {
                    await self.sync(newProducts: viewModel.products, with: products, in: modelContext)
                }
            } // ON CHANGE
            .environment(viewModel)
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        FavoritesView(service: StoreService(manager: MocNetworkManager()))
    }
    .modelContainer(for: FakeStoreApp.modelContainer, inMemory: false)
    .environment(ErrorManager())
}
