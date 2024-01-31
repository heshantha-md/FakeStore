//
//  ProductsView.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI
import SwiftData

struct ProductsView: View {
    // MARK: - PROPERTIES
    @Environment(StoreViewModel.self) var viewModel
    @Environment(ErrorManager.self) var errorManager

    @State private var productListingGridLayout: GridItems = Array(repeating: GridItem(spacing: 10), count: 1)
    @State private var didSelectCategory = false
    @State private var didSelectProduct = false
    @State private var selectedProduct: Product?
    @State private var tappedProduct: Int?
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    VStack(spacing: 0) {
                        // MARK: - Tool Bar
                        PrimaryToolBar(productListingGridLayout: $productListingGridLayout)
                        
                        // MARK: - Categories List
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: Array(repeating: GridItem(spacing: 10), count: 1)) {
                                ForEach(viewModel.categories) { category in
                                    // MARK: - HOME CATEGORIES GRID CELL VIEW
                                    CategoriesGridCellView(category: category, onTap: {
                                        Task {
                                            didSelectCategory.toggle()
                                            await viewModel.set(category: category)
                                        }
                                    }) // HOME CATEGORIES GRID CELL VIEW
                                    .animation(.spring(response: 0.5, dampingFraction: 1), value: category.isSelected)
                                } // LOOP
                            } // LAZY H GRID
                            .padding(.horizontal)
                        } // SCROLL VIEW
                        .frame(height: 70)
                    } // VSTACK
                    .background(Colors.BACKGROUND)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .opacity(didSelectProduct ? 0 : 1)
                    .zIndex(1)
                    
                    // MARK: - Products List
                    ScrollView {
                        // MARK: - PRODUCT LISTING VIEW
                        LazyVGrid(columns: productListingGridLayout, spacing: 10) {
                            ForEach(viewModel.filteredProducts != nil ? viewModel.filteredProducts ?? [] : viewModel.products) { product in
                                // MARK: - HOME GRID CELL VIEW
                                ProductGridCellView(product: product,
                                                 size: geo.size.width)
                                .scaleEffect(product.id == tappedProduct ? 10 : 1)
                                .zIndex(product.id == tappedProduct ? 1 : 0)
                                .gesture(
                                    TapGesture().onEnded { _ in
                                        didSelectProduct = true
                                        tappedProduct = product.id
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                            tappedProduct = nil
                                            didSelectProduct = false
                                            self.selectedProduct = product
                                        }
                                    }
                                ) // GESTURE
                                .animation(.easeIn(duration: 0.3), value: product.id == tappedProduct)
                            } // LOOP
                        } // LAZY V GRID
                        .background(Color.clear)
                        .padding(.top, 110)
                        .padding()
                        .onChange(of: selectedProduct) {
                            tappedProduct = nil
                        }
                    } // SCROLL VIEW
                    .background(Color.clear)
                    .refreshable {
                        Task {
                            do {
                                try await viewModel.refreshData()
                            } catch {
                                errorManager.handle(error: error)
                            }
                        }
                    } // REFRESHABLE
                } // ZSTACK
                .opacity(selectedProduct != nil ? 0 : 1)
                .blur(radius: selectedProduct != nil ? 4 : 0)
                .animation(.smooth(duration: 0.5), value: selectedProduct != nil)
                
                // MARK: - Show Product Details View
                if selectedProduct != nil {
                    withAnimation {
                        ProductDetailsView(viewModel: ProductDetailsViewModel(), product: $selectedProduct)
                    }
                }
            } // ZSTACK
            .onAppear {
                resetView()
            }
            .onDisappear {
                resetView()
            }
        } // GEOMETRY READER
    } // BODY
    
    // MARK: - FUNCTIONS
    private func resetView() {
        didSelectProduct = false
        selectedProduct = nil
    }
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ProductsView()
        .background(Colors.BACKGROUND)
        .modelContainer(for: FakeStoreApp.modelContainer, inMemory: false)
        .environment(StoreViewModel(service: StoreService(manager: MocNetworkManager())))
        .environment(ErrorManager())
}
