//
//  GridToolBarItem.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI

struct GridToolBarItem: View {
    // MARK: - PROPERTIES
    @AppStorage("isTwoColumnsGrid") var isTwoColumnsGrid = false
    @State private var productListingGridLayout: GridItems = []
    var didChageLayout: (GridItems) -> Void
    private var sliderLabel: Image {
        return Image(systemName: isTwoColumnsGrid ? "rectangle.grid.1x2.fill" : "rectangle.grid.2x2.fill")
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            withAnimation {
                isTwoColumnsGrid.toggle()
                notifyGirdLayoutChanges()
            }
        } label: {
            sliderLabel
                .font(.title3)
                .foregroundStyle(.black)
        } // BUTTON
        .onAppear {
            notifyGirdLayoutChanges()
        } // ON APPEAR
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    GridToolBarItem(didChageLayout: { layout in
        // Do Something here
    })
}

// MARK: - EXTENSION
extension GridToolBarItem {
    @MainActor
    private func notifyGirdLayoutChanges() {
        didChageLayout(Array(repeating: GridItem(spacing: 10), count: isTwoColumnsGrid ? 2 : 1))
    }
}
