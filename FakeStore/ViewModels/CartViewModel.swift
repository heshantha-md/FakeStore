//
//  CartViewModel.swift
//  FakeStore
//
//  Created by Heshantha Don on 09/01/2024.
//

import Foundation
import SwiftData

@Observable
final class CartViewModel {
    // MARK: - PROPERTIES
    var cartItems: CartItems = []
    var deleteCartItems: CartItems = []
    var products: Products = []
    var cartTotal: Double = 0.00
    
    // MARK: - FUNCTIONS
    @MainActor
    func getTotal() async {
        cartTotal = cartItems.reduce(into: 0.00) { (result, item) in
            if let product = products.first(where: { $0.id == item.id }) {
                result += (product.price * Double(item.quantity))
            }
        }
    }
    
    @MainActor
    func update(quantity: Int, model: CartItem) async {
        let newQuantity = model.quantity + quantity
        if newQuantity <= 0 {
            return
        }
        let newItem = CartItem(id: model.id, quantity: newQuantity)
        cartItems.removeAll(where: { $0.id == newItem.id })
        cartItems.append(newItem)
    }
    
    func deleteItems(at offset: IndexSet) {
        offset.forEach { index in
            deleteCartItems.append(cartItems[index])
        }
    }
}
