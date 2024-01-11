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
    @Environment(RouteManager.self) var router
    @Environment(ErrorManager.self) var errorManager
    
    // MARK: - BODY
    var body: some View {
        @Bindable var router = router
        
        TabView() {
            NavigationStack(path: $router.homeNavPath) {
                StoreView(service: productService)
            }
            .tabItem {
                Label("Store", systemImage: "storefront")
            }
            
            NavigationStack(path: $router.favoriteNavPath) {
                FavoritesView(service: productService)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
            
            NavigationStack(path: $router.settingsNavPath) {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        } // TAB VIEW
        .errorAlert()
        .onChange(of: router.currentTab, initial: false) {
            router.resetNavigationPaths()
        }
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
        .environment(RouteManager())
        .environment(ErrorManager())
}
