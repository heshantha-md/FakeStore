//
//  StoreService.swift
//  FakeStore
//
//  Created by Heshantha Don on 27/12/2023.
//

import Foundation

@Observable
class StoreService {
    // MARK: - PROPERTIES
    var categories: Categories = []
    var products: Products = []
    
    private let manager: NetworkProtocol?
    
    init(manager: NetworkProtocol) {
        self.manager = manager
    }
    
    // MARK: - FUNCTIONS
    fileprivate init(categories: Categories, products: Products) {
        self.categories = categories
        self.products = products
        self.manager = nil
    }
    
    func fetchCategories() async throws {
        var newCategories: Categories = []
        if let categoriesFetched: [String] = (try? await manager?.fetch(.getCategories)) {
            categoriesFetched.forEach { category in
                newCategories.append(Category(name: category, icon: "staroflife.fill"))
            }
            newCategories.append(Category(name: "All", icon: "staroflife.fill"))
        }
        self.categories = newCategories
    }
    
    func fetchProducts() async throws {
        var newProducts: Products = []
        if let productsFetched: [ProductDecodable] = (try? await manager?.fetch(.getProducts)) {
            productsFetched.forEach { product in
                newProducts.append(Product(from: product))
            }
        }
        self.products = newProducts
    }
}

// MARK: - STATIC PROPERTIES
extension StoreService {
    static let mocCategories: Categories = [Category(name: "men's clothing", icon: "staroflife.fill"),
                                            Category(name: "jewelery", icon: "staroflife.fill")]
    
    static let mocProducts: Products = [Product(id: 1,
                                                title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                                                pDescription: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                                                category: "men's clothing",
                                                image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
                                                price: 109.95,
                                                ratingRate: 3.9,
                                                ratingCount: 120),
                                        Product(id: 2,
                                                title: "Mens Casual Premium Slim Fit T-Shirts ",
                                                pDescription: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
                                                category: "jewelery",
                                                image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
                                                price: 209.50,
                                                ratingRate: 4.1,
                                                ratingCount: 259)]
}
