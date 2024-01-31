//
//  ProductImageView.swift
//  FakeStore
//
//  Created by Heshantha Don on 30/01/2024.
//

import SwiftUI

struct ProductImageView: View {
    // MARK: - PROPERTIES
    @Binding var product: Product?
    @State private var imageScale: CGFloat = 1.2
    
    // MARK: - BODY
    var body: some View {
        if let product {
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    // MARK: - Product Image
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                        .scaleEffect(imageScale)
                        .onAppear {
                            withAnimation(.spring(response: 1.3, dampingFraction: 0.6, blendDuration: 0)) {
                                imageScale = 1.0
                            }
                        }
                case .failure(_):
                    EmptyView()
                default:
                    // MARK: - Loading View
                    LoadingView()
                }
            } // IMAGE
            .frame(maxWidth: .infinity, minHeight: 150)
            .overlay(alignment: .bottomLeading) {
                // MARK: - Category Name
                Text(product.category.uppercased())
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background {
                        Capsule()
                            .fill(.gray.opacity(0.4))
                    } // BACKGROUND
            } // OVERLAY
            .overlay(alignment: .bottomTrailing) {
                // MARK: - FAVOURITE BUTTON
                FavoriteImage(isFavorite: .constant(product.isFavorite ?? false))
                    .frame(width: 23, height: 23)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 5)
                    .onTapGesture {
                        withAnimation() {
                            if product.isFavorite == nil {
                                product.isFavorite = true
                            } else {
                                product.isFavorite?.toggle()
                            }
                        }
                    } // GESTURE
            } // OVERLAY
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
        } // IF
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ProductImageView(product: .constant(StoreService.mocProducts[0]))
        .padding()
}
