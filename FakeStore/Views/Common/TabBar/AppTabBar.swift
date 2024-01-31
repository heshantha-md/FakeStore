//
//  AppTabBar.swift
//  FakeStore
//
//  Created by Heshantha Don on 31/01/2024.
//

import SwiftUI

struct AppTabBar: View {
    // MARK: - PROPERTIES
    @Binding var tabIndex: Int
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // MARK: - Tab Background
            let capsule = Capsule()
            
            ZStack {
                capsule
                    .foregroundStyle(.white)
                
                capsule
                    .foregroundStyle(.gray.opacity(0.05))
                    .padding(5)
                    .blur(radius: 1)
            } // ZSTACK
            .shadow(color: .white.opacity(0.4), radius: 20, x: -20, y: -20)
            .shadow(color: .gray.opacity(0.4), radius: 20, x: 20, y: 20)
            
            HStack(spacing: 40) {
                // MARK: - Tab Item 0
                AppTabBarItem(iconNormal: "storefront",
                           iconHighlighted: "storefront.fill",
                           isSelected: tabIndex == 0,
                           action: {
                    DispatchQueue.main.async {
                        tabIndex = 0
                    }
                })
                
                // MARK: - Tab Item 1
                AppTabBarItem(iconNormal: "heart",
                           iconHighlighted: "heart.fill",
                           isSelected: tabIndex == 1,
                           action: {
                    DispatchQueue.main.async {
                        tabIndex = 1
                    }
                })
                
                // MARK: - Tab Item 2
                AppTabBarItem(iconNormal: "gear",
                           iconHighlighted: "gearshape.fill",
                           isSelected: tabIndex == 2,
                           action: {
                    DispatchQueue.main.async {
                        tabIndex = 2
                    }
                })
            } // HSTACK
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .padding(.top, 2)
        } // ZSTACK
    } // BODY
} // STRUCT

#Preview {
    AppTabBar(tabIndex: .constant(0))
        .frame(height: 60)
        .padding()
}
