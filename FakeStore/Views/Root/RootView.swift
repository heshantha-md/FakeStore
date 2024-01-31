//
//  RootView.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI
import SwiftData

struct RootView: View {
    // MARK: - PROPERTIES
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.name) private var categories: Categories
    @Query() private var products: Products
    
    @Environment(StoreService.self) var productService
    @Environment(ErrorManager.self) var errorManager
    @State private var selectedTabIndex = 0
    @AppStorage("isTabBarHidden") var isTabBarHidden = false
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // MARK: - Tab Roots
            switch selectedTabIndex {
            case 0:
                withAnimation {
                    StoreView(viewModel: StoreViewModel(service: productService))
                }
            case 1:
                withAnimation {
                    FavoritesView(viewModel: StoreViewModel(service: productService))
                }
            case 2:
                withAnimation {
                    SettingsView()
                }
            default:
                withAnimation {
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .overlay(alignment: .bottom) {
            // MARK: - Tab Bar
            AppTabBar(tabIndex: $selectedTabIndex)
                .frame(height: 60, alignment: .bottom)
                .padding(.horizontal, 20)
                .opacity(isTabBarHidden ? 0 : 1)
        }
        .errorAlert() // MARK: - Alert Handler
        .onChange(of: productService.categories, initial: true) {
            Task {
                await self.sync(newCategories: productService.categories, with: categories, in: modelContext)
            }
        }
        .onChange(of: productService.products, initial: true) {
            Task {
                await self.sync(newProducts: productService.products, with: products, in: modelContext)
            }
        }
        .task {
            do {
                try await productService.fetchProducts()
                try await productService.fetchCategories()
            } catch {
                errorManager.handle(error: error)
            }
        }
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    RootView()
        .modelContainer(for: FakeStoreApp.modelContainer, inMemory: false)
        .environment(StoreService(manager: MocNetworkManager()))
        .environment(ErrorManager())
}
