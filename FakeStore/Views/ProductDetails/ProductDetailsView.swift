//
//  ProductDetailsView.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/12/2023.
//

import SwiftUI
import SwiftData

struct ProductDetailsView: View {
    // MARK: - PROPERTIES
    @Environment(\.modelContext) var modelContext
    @Query() private var cartItems: CartItems
    
    @State var viewModel: ProductDetailsViewModel
    @Binding var product: Product?
    @State private var dragAmount = CGSize.zero
    @State private var isAnimating = false
    
    // MARK: - BODY
    var body: some View {
        if let product {
            GeometryReader { geo in
                VStack {
                    ZStack(alignment: .top) {
                        // MARK: - Tool Bar
                        SecondaryToolBar(trailingActoin: {
                            self.product = nil
                        })
                        .zIndex(1)
                        
                        // MARK: - Product Image View
                        ProductImageView(product: $product)
                            .offset(y: isAnimating ? 0 : geo.size.height / 2)
                    } // ZSTACK
                    
                    Spacer()
                    
                    // MARK: - Product Detail Content View
                    ProductDetailContentView(product: $product, viewModel: $viewModel)
                        .frame(minHeight: geo.size.height/2)
                        .frame(height: ((geo.size.height/1.5 - dragAmount.height) > geo.size.height/2 ? geo.size.height/1.5 - dragAmount.height : 350))
                        .padding(.horizontal, 10)
                        .padding(.top)
                        .background(.clear)
                        .background {
                            // MARK: - Gradient Bottom Sheet
                            GradientBottomSheet(backgroundColor: Colors.BLUE_GRADIENT,
                                                dragBarVisible: true)
                        } // BACKGROUND
                        .gesture(
                            // MARK: - Drag Gesture
                            DragGesture()
                                .onChanged {
                                    if $0.translation.height < 0 {
                                        self.dragAmount = $0.translation
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        self.dragAmount = .zero
                                    }
                                }
                        ) // GESTURE
                        .offset(y: isAnimating ? 0 : -geo.size.height / 6)
                } // VSTACK
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .onChange(of: product, initial: true) {
                    viewModel.product = product
                }
                .onChange(of: cartItems, initial: true) {
                    viewModel.cartItems = cartItems
                }
                .onChange(of: viewModel.cartItems) {
                    Task {
                        await self.sync(newCartItems: viewModel.cartItems, with: cartItems, in: modelContext)
                    }
                }
                .onAppear {
                    withAnimation(.smooth(duration: 0.5)) {
                        isAnimating = true
                    }
                }
                .modifier(HideToolBar())
            } // GEOMETRY READER
        } // GEOMETRY READER
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ProductDetailsView(viewModel: ProductDetailsViewModel(), product: .constant(StoreService.mocProducts[0]))
    .environment(ErrorManager())
}
