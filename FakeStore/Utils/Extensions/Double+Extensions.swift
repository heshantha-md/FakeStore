//
//  Double+Extentions.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/12/2023.
//

import Foundation

extension Double {
    var asPrice: String {
        return String(format: "%.2f", self)
    }
}
