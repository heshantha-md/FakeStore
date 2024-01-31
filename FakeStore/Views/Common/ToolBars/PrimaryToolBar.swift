//
//  PrimaryToolBar.swift
//  FakeStore
//
//  Created by Heshantha Don on 26/01/2024.
//

import SwiftUI

struct PrimaryToolBar: View {
    // MARK: - PROPERTIES
    @AppStorage("isTwoColumnsGrid") var isTwoColumnsGrid = false
    @Binding var productListingGridLayout: GridItems
    
    // MARK: - BODY
    var body: some View {
        HStack {
            // MARK: - Leading Item
            CartToolBarItem()
            
            Spacer()
            
            // MARK: - App Logo
            Text(Constants.FAKE_STORE)
                .font(.system(size: 35, weight: .heavy))
                .modifier(AppLogoStyle())
            
            Spacer()
            
            // MARK: - Trailing Item
            SecondaryButton(action: { _ in
                isTwoColumnsGrid.toggle()
            }, sfSymbol: .constant(isTwoColumnsGrid ? "rectangle.grid.1x2.fill" : "rectangle.grid.2x2.fill"),
               color: Colors.BLUE_GRADIENT,
               buttonBackground: .white)
        } // HSTACK
        .frame(height: 48)
        .padding(.horizontal, 20)
        .onChange(of: isTwoColumnsGrid, initial: true) {
            productListingGridLayout = Array(repeating: GridItem(spacing: 10), count: isTwoColumnsGrid ? 2 : 1)
        }
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    PrimaryToolBar(productListingGridLayout: .constant(Array(repeating: GridItem(spacing: 10), count: 1)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.BACKGROUND)
        .modelContainer(for: FakeStoreApp.modelContainer, inMemory: false)
        .environment(ErrorManager())
}
