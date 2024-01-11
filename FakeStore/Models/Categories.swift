//
//  Categorie.swift
//  FakeStore
//
//  Created by Heshantha Don on 27/12/2023.
//

import Foundation
import SwiftData

// MARK: - CATEGORY
@Model
class Category: Identifiable {
    private(set) var name: String
    private(set) var icon: String
    var isSelected: Bool?
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}

// MARK: - EXTENSION
extension Category {
    func update(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
    
    func update(with category: Category) {
        self.name = category.name
        self.icon = category.icon
        if category.isSelected != nil {
            self.isSelected = category.isSelected
        }
    }
}
