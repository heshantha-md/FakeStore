//
//  NetworkManager.swift
//  FakeStore
//
//  Created by Heshantha Don on 27/12/2023.
//

import Foundation

// MARK: - PROTOCOL
protocol NetworkProtocol {
    func fetch<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T?
}

// MARK: - NETWORK MANAGER
class NetworkManager: NetworkProtocol {
    func fetch<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T? {
        guard let urlPath = URL(string: Constants.baseUrl + endpoint.path),
              var urlComponents = URLComponents(string: urlPath.path)
        else { return nil }
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
//        let dataString = String(data: data, encoding: .utf8)
//        print("response: \(String(describing: dataString))")
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - MOC NETWORK MANAGER
class MocNetworkManager: NetworkProtocol {
    func fetch<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T? {
        switch endpoint {
        case .getCategories:
            return MocNetworkManager.mocCategories as? T
        case .getProducts:
            return MocNetworkManager.mocProducts as? T
        }
    }
    
    static let mocCategories: [String] = ["men's clothing", "jewelery"]
    
    static let mocProducts: [ProductDecodable] = [ProductDecodable(id: 1,
                                                title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                                                description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                                                category: "men's clothing",
                                                image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
                                                price: 109.95,
                                                rating: RatingDecodable(rate: 3.9, count: 120)),
                                        ProductDecodable(id: 2,
                                                title: "Mens Casual Premium Slim Fit T-Shirts ",
                                                description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
                                                category: "jewelery",
                                                image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
                                                price: 209.50,
                                                rating: RatingDecodable(rate: 4.1, count: 259))]
}

// MARK: - ENUM
enum ApiEndpoint {
    case getCategories, getProducts
    
    enum Method: String {
        case GET
    }
}

// MARK: - EXTENSION
extension ApiEndpoint {
    var path: String {
        switch self {
        case .getCategories:
            return "products/categories"
        case .getProducts:
            return "products"
        }
    }
    
    var method: ApiEndpoint.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
}
