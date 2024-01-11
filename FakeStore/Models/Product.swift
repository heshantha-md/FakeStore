//
//  Product.swift
//  FakeStore
//
//  Created by Heshantha Don on 27/12/2023.
//

import Foundation
import SwiftData

// MARK: - PRODUCT
@Model
class Product: Identifiable {
    @Attribute(.unique) let id: Int
    var title: String
    var pDescription: String
    var category: String
    var image: String
    var price: Double
    var isFavorite: Bool?
    var ratingRate: Double
    var ratingCount: Int
    
    enum CodingKeys: CodingKey {
        case id, title, price, description, category, image, rating
    }
    
    init(id: Int,
         title: String,
         pDescription: String,
         category: String,
         image: String,
         price: Double,
         ratingRate: Double,
         ratingCount: Int) {
        self.id = id
        self.title = title
        self.pDescription = pDescription
        self.category = category
        self.image = image
        self.price = price
        self.ratingRate = ratingRate
        self.ratingCount = ratingCount
    }
    
    init(from productDecodable: ProductDecodable) {
        self.id = productDecodable.id
        self.title = productDecodable.title
        self.pDescription = productDecodable.description
        self.category = productDecodable.category
        self.image = productDecodable.image
        self.price = productDecodable.price
        self.ratingRate = productDecodable.rating.rate
        self.ratingCount = productDecodable.rating.count
    }
}

// MARK: - EXTENSION
extension Product {
    func update(with product: Product) {
        self.title = product.title
        self.pDescription = product.pDescription
        self.category = product.category
        self.image = product.image
        self.price = product.price
        self.ratingRate = product.ratingRate
        if product.isFavorite != nil {
            self.isFavorite = product.isFavorite
        }
        self.ratingCount = product.ratingCount
    }
}
