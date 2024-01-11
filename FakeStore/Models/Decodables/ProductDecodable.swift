//
//  ProductDecodable.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/12/2023.
//

import Foundation

// MARK: - PRODUCT DECODABLE
class ProductDecodable: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let image: String
    let price: Double
    let rating: RatingDecodable
    
    init(id: Int,
         title: String,
         description: String,
         category: String,
         image: String,
         price: Double,
         rating: RatingDecodable) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.image = image
        self.price = price
        self.rating = rating
    }
}

// MARK: - RATING DECODABLE
class RatingDecodable: Codable {
    let rate: Double
    let count: Int
    
    init(rate: Double, count: Int) {
        self.rate = rate
        self.count = count
    }
}
