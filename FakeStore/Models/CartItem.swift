//
//  CartItem.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import Foundation
import SwiftData

// MARK: - CART ITEM
@Model
class CartItem: Identifiable, Hashable {
    let id: Int
    var quantity: Int
    
    init(id: Int, quantity: Int) {
        self.id = id
        self.quantity = quantity
    }
    
    func update(with item: CartItem) {
        self.quantity = item.quantity
    }
}
