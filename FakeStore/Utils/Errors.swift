//
//  Errors.swift
//  FakeStore
//
//  Created by Heshantha Don on 10/01/2024.
//

import Foundation

enum FetchError: LocalizedError {
    case badRequest, badJSON
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            "Bad request has been found"
        case .badJSON:
            "Bad json has been found"
        }
    }
}

enum ValidationError: LocalizedError {
    case emptyProduct
    
    var errorDescription: String? {
        switch self {
        case .emptyProduct:
            "No product has been found"
        }
    }
}
