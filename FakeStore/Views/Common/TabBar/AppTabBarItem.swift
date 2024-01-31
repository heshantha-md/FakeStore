//
//  AppTabBarItem.swift
//  FakeStore
//
//  Created by Heshantha Don on 31/01/2024.
//

import SwiftUI

struct AppTabBarItem: View {
    // MARK: - PROPERTIES
    var iconNormal: String
    var iconHighlighted: String
    var isSelected: Bool
    var action: () async -> Void
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // MARK: - Button Background
            let rectangle = RoundedRectangle(cornerRadius: 10, style: .continuous)
            
            rectangle
                .fill(.white)
                .blur(radius: 4)
            
            rectangle
                .fill(.white)
            
            rectangle
                .foregroundStyle(.white)
                .blur(radius: 2)
                .offset(x: -3, y: -2)
            
            rectangle
                .foregroundStyle(.gray.opacity(0.2))
                .blur(radius: 2)
                .offset(x: 3, y: 3)
            
            rectangle
                .fill(Colors.WHITE_BACKGROUND_GRADIENT)
            
            rectangle
                .stroke(.white, lineWidth: 1)
                .blendMode(.overlay)
        } // ZSTACK
        .shadow(color: .white, radius: 4, x: -4, y: -4)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 4, y: 4)
        .overlay {
            // MARK: - Button Icon
            SecondaryButton(action: { _ in
                // MARK: - Button Action
                Task {
                    await action()
                }
            }, sfSymbol: .constant(isSelected ? iconHighlighted : iconNormal), color: isSelected ? Colors.GOLD_GRADIENT : Colors.BLUE_GRADIENT, buttonBackground: .white)
        } // OVERLAY
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    AppTabBarItem(iconNormal: "home",
               iconHighlighted: "home.fill",
               isSelected: false,
               action: {
        // Do Something here
    })
    .padding()
}
