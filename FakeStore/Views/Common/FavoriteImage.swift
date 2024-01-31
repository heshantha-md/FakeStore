//
//  FavoriteImage.swift
//  FakeStore
//
//  Created by Heshantha Don on 31/01/2024.
//

import SwiftUI

// MARK: - Favorite Icon
struct FavoriteIcon: View {
    // MARK: - PROPERTIES
    @Binding var isFavorite: Bool
    
    // MARK: - BODY
    var body: some View {
        Image(systemName: isFavorite ? "heart.fill" : "heart")
            .resizable()
            .scaledToFit()
    } // BODY
} // STRUCT

// MARK: - Favorite Image
struct FavoriteImage: View {
    // MARK: - PROPERTIES
    @Binding var isFavorite: Bool
    
    // MARK: - BODY
    var body: some View {
        let image = FavoriteIcon(isFavorite: $isFavorite)
        
        ZStack {
            image
                .foregroundStyle(.gray.opacity(0.2))
                .blur(radius: 1)
            
            image
                .foregroundStyle(.white)
                .offset(x: -0.5)
            
            image
                .foregroundStyle(.gray.opacity(0.6))
                .offset(x: 3, y: 1)
                .blur(radius: 2)
            
            image
                .foregroundStyle(Colors.ORAGNE_GRADIENT)
        } // ZSTACK
        .shadow(color: .white, radius: 1, x: -1, y: -1)
        .shadow(color: .gray.opacity(0.2), radius: 2, x: 2, y: 2)
        .contentTransition(.symbolEffect(.replace))
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    FavoriteImage(isFavorite: .constant(true))
        .padding()
}
