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
        HStack(spacing: 13) {
            // MARK: - Category Name
            ZStack {
                Text(category.name.uppercased())
                    .modifier(PrimaryTextStyle())
                
                Text(category.name.uppercased())
                    .offset(y: -1)
            } // ZSTACK
            .font(.system(size: 15).weight(.heavy))
            .foregroundStyle(LinearGradient(colors: category.isSelected ?? false ? [.white] : Colors.GREEN_SET, startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundStyle(.clear)
            .padding(.top, 2)
            .padding(.leading, 1)
        } // HSTACK
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background {
            // MARK: - Background
            ZStack {
                let roundedRectangle = Capsule()
                
                roundedRectangle
                    .foregroundStyle(.white)
                    .blur(radius: 4)
                    .offset(x: -4, y: -4)
                
                roundedRectangle
                    .stroke(.gray.opacity(0.3), lineWidth: 1)
                    .blendMode(.overlay)
                    .blur(radius: 1)
                    .padding(3)
                
                roundedRectangle
                    .foregroundStyle(.white)
                    .blur(radius: 1)
                    .padding(3)
                
                roundedRectangle
                    .foregroundStyle(.white)
                    .blur(radius: 1)
                    .offset(x: 4, y: 4)
                
                roundedRectangle
                    .fill(category.isSelected ?? false ? Colors.GOLD_GRADIENT : Colors.WHITE_BACKGROUND_GRADIENT)
                    .padding(3)
            } // ZSTACK
            .clipShape(Capsule())
            .shadow(color: .white, radius: 4, x: -4, y: -4)
            .shadow(color: .gray.opacity(0.25), radius: 4, x: 4, y: 4)
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
