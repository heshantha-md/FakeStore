//
//  View+Extensions.swift
//  FakeStore
//
//  Created by Heshantha Don on 08/01/2024.
//

import SwiftUI
import SwiftData

extension View {
    @MainActor
    func sync(newProducts: [Product], with existingProducts: [Product], in model: ModelContext) async {
        newProducts.forEach { product in
            if let productDB = existingProducts.first(where: { $0.id == product.id }) {
                productDB.update(with: product)
            } else {
                model.insert(product)
            }
        }
    }
    
    @MainActor
    func sync(newCategories: [Category], with existingCategories: [Category], in model: ModelContext) async {
        newCategories.forEach { category in
            if let categoryDB = existingCategories.first(where: { $0.name == category.name }) {
                categoryDB.update(with: category)
            } else {
                model.insert(category)
            }
        }
    }
    
    @MainActor
    func sync(newCartItems: [CartItem], with existingCartItems: [CartItem], in model: ModelContext) async {
        newCartItems.forEach { item in
            if let itemDB = existingCartItems.first(where: { $0.id == item.id }) {
                itemDB.update(with: item)
            } else {
                model.insert(item)
            }
        }
    }
    
    @MainActor
    func delete(items: [any PersistentModel], in model: ModelContext) async {
        items.forEach { item in
            DispatchQueue.main.async {
                model.delete(item)
            }
        }
    }
}

extension View {
    func errorAlert() -> some View {
        modifier(ErrorAlertViewModifier())
    }
}
