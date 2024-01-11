//
//  ProductDetailsViewModel.swift
//  FakeStore
//
//  Created by Heshantha Don on 09/01/2024.
//

import Foundation

@Observable
final class ProductDetailsViewModel {
    // MARK: - PROPERTIES
    var cartItems: CartItems = []
    var product: Product?
    
    // MARK: - FUNCTIONS
    @MainActor
    func addToCart() async throws {
        if let product {
            var newCartItems = Set(cartItems)
            if let eItem = cartItems.first(where: { $0.id == product.id }) {
                eItem.quantity += 1
                newCartItems.insert(eItem)
            } else {
                newCartItems.insert(CartItem(id: product.id, quantity: 1))
            }
            cartItems = Array(newCartItems)
        } else {
            throw ValidationError.emptyProduct
        }
    }
}
