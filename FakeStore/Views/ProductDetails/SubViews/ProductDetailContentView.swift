//
//  ProductDetailContentView.swift
//  FakeStore
//
//  Created by Heshantha Don on 30/01/2024.
//

import SwiftUI

struct ProductDetailContentView: View {
    // MARK: - PROPERTIES
    @Environment(ErrorManager.self) var errorManager
    
    @Binding var product: Product?
    @Binding var viewModel: ProductDetailsViewModel
    @State private var isAnimating: Bool = false
    
    var body: some View {
        if let product {
            VStack(spacing: 15) {
                HStack {
                    // MARK: - Product Title
                    Text(product.title)
                        .font(.title2.weight(.heavy))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    // MARK: - Product Price
                    Text("\(Constants.currencySymbol + product.price.asPrice)")
                        .modifier(FlexibleTextWrapper(shape: Capsule(),
                                                      fillColor: .white,
                                                      foregroundGradient: Colors.GREEN_GRADIENT))
                        .opacity(isAnimating ? 1 : 0)
                        .font(.title3.weight(.heavy))
                        .foregroundStyle(Colors.BLUE_GRADIENT)
                } // HSTACK
                .padding(.top, 20)
                
                // MARK: - Product Description
                Text(product.pDescription)
                    .foregroundStyle(.white)
                
                Spacer()
                
                // MARK: - Add to Cart Button
                PrimaryButton(title: Constants.ADD_TO_CART.uppercased(),
                              loadingSymbol: "cart.fill",
                              action: {
                    Task {
                        do {
                            try await viewModel.addToCart()
                        } catch {
                            errorManager.handle(error: error)
                        }
                    }
                })
            } // HSTACK
            .onAppear {
                isAnimating = true
            }
        } // VSTACK
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ProductDetailContentView(product: .constant(StoreService.mocProducts[0]),
                  viewModel: .constant(ProductDetailsViewModel()))
}
