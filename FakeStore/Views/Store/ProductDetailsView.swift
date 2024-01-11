//
//  ProductDetailsView.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/12/2023.
//

import SwiftUI
import SwiftData

// MARK: Needs to have it's own view model

struct ProductDetailsView: View {
    // MARK: - PROPERTIES
    @Environment(\.modelContext) var modelContext
    @Environment(ErrorManager.self) var errorManager
    
    @Query() private var cartItems: CartItems
    @Bindable var product: Product
    @State private var viewModel = ProductDetailsViewModel()
    @State private var rotateDegree: Double = 0
    @State private var imageScale: CGFloat = 1.2
    @State private var dragAmount = CGSize.zero
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            VStack {
                AsyncImage(url: URL(string: product.image)) { phase in
                    if let image = phase.image {
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
                    }
                } // IMAGE
                .frame(maxWidth: .infinity, minHeight: 150)
                .overlay(alignment: .bottomLeading) {
                    Text(product.category)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(.gray.opacity(0.4))
                        }
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: (product.isFavorite ?? false) ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 5)
                        .onTapGesture {
                            withAnimation {
                                if product.isFavorite == nil {
                                    product.isFavorite = true
                                } else {
                                    product.isFavorite?.toggle()
                                }
                            }
                        }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                
                Spacer()
                
                VStack(spacing: 15) {
                    Capsule()
                        .fill(.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                    
                    HStack {
                        Text(product.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text(product.price.asPrice)
                                .modifier(PriceTag())
                                .font(.title3)
                        }
                    }
                    
                    Text(product.pDescription)
                    
                    Spacer()
                    
                    Button("Add to cart".uppercased()) {
                        Task {
                            do {
                                try await viewModel.addToCart()
                            } catch {
                                errorManager.handle(error: error)
                            }
                        }
                    }
                    .buttonStyle(PrimaryButton(disabled: false))
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                .frame(minHeight: geo.size.height/2)
                .frame(height: ((geo.size.height/1.5 - dragAmount.height) > geo.size.height/2 ? geo.size.height/1.5 - dragAmount.height : 350))
                .padding(.horizontal, 10)
                .padding(.top)
                .background(.clear)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .shadow(radius: 3)
                        .ignoresSafeArea()
                }
                .gesture(
                    DragGesture()
                        .onChanged {
                            self.dragAmount = $0.translation
                        }
                        .onEnded { _ in
                            withAnimation {
                                self.dragAmount = .zero
                            }
                        }
                )
            } // VSTACK
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(content: {
                    CartToolBarItem()
                }) // TABITEM
            } // TOOLBAR
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
        } // GEOMETRY READER
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        ProductDetailsView(product: StoreService.mocProducts[0])
    }
    .environment(ErrorManager())
}
