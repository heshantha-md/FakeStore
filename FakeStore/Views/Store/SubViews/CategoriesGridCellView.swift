//
//  CategoriesGridCellView.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/12/2023.
//

import SwiftUI

struct CategoriesGridCellView: View {
    // MARK: - PROPERTIES
    @Bindable var category: Category
    let onTap: () -> Void
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Image(systemName: category.icon)
            Text(category.name.uppercased())
        } // HSTACK
        .foregroundStyle(category.isSelected ?? false ? .white : .black)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(category.isSelected ?? false ? .black : .white)
                .stroke(.black, lineWidth: 1)
        } // BACKGROUND
        .onTapGesture {
            onTap()
        } // GESTURE
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    CategoriesGridCellView(category: StoreService.mocCategories[0], onTap: {
        // Do something here
    })
}
