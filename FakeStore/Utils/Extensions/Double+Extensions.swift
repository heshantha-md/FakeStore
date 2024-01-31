//
//  Double+Extentions.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/12/2023.
//

import Foundation

extension Double {
    // MARK: - Convert String decimal value to Two decimal points
    var asPrice: String {
        return String(format: "%.2f", self)
    }
}
