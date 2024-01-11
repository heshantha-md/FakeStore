//
//  StoreViewModel.swift
//  FakeStore
//
//  Created by Heshantha Don on 03/01/2024.
//

import Foundation

@Observable
final class StoreViewModel {
    // MARK: - PROPERTIES
    private var service: StoreService? = nil
    var categories: Categories = []
    var filteredProducts: Products?
    var products: Products = []
    
    init() {}
    
    init(service: StoreService) {
        self.service = service
    }
    
    // MARK: - FUNCTIONS
    @MainActor
    final func set(categories: Categories) async {
        if let item = categories.first(where: { $0.name == "All" }) {
            Task {
                await self.set(category: item)
            }
        }
        self.categories = categories
    }
    
    @MainActor
    final func set(products: Products, isFavoriteOnly: Bool = false) async {
        self.products = isFavoriteOnly ? products.filter({ $0.isFavorite == true }) : products
    }
    
    @MainActor
    final func refreshData() async throws {
        try await self.service?.fetchCategories()
        try await self.service?.fetchProducts()
    }
    
    @MainActor
    final func set(category: Category) async {
        categories.forEach { item in
            item.isSelected = item.name == category.name ? true : false
        }
        if category.name == "All" {
            self.filteredProducts = nil
            return
        }
        self.filteredProducts = products.filter({ $0.category == category.name })
    }
}
