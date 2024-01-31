//
//  SecondaryToolBar.swift
//  FakeStore
//
//  Created by Heshantha Don on 30/01/2024.
//

import SwiftUI

struct SecondaryToolBar: View {
    // MARK: - PROPERTIES
    var trailingActoin: () async -> Void
    
    // MARK: - BODY
    var body: some View {
        HStack {
            // MARK: - Leading Item
            CartToolBarItem()
            
            Spacer()
            
            // MARK: - Trailing Item
            SecondaryButton(action: { _ in
                Task {
                    await trailingActoin()
                }
            }, sfSymbol: .constant("xmark"),
               color: Colors.BLUE_GRADIENT,
               buttonBackground: .white)
        } // HSTACK
        .frame(height: 48)
        .padding(.horizontal, 20)
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    SecondaryToolBar(trailingActoin: {
        // Do Something here
    })
}
