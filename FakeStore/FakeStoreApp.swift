//
//  FakeStoreApp.swift
//  FakeStore
//
//  Created by Heshantha Don on 27/12/2023.
//

import SwiftUI
import SwiftData

@main
struct FakeStoreApp: App {
    // MARK: - PROPERTIES
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(FakeStoreApp.modelContainer)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var storeService = StoreService(manager: NetworkManager())
    @State private var errorManager = ErrorManager()
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
        .environment(storeService)
        .environment(errorManager)
    }
}

// MARK: - STATIC PROPERTIES
extension FakeStoreApp {
    static let modelContainer: [any PersistentModel.Type] = [Category.self, Product.self, CartItem.self]
}
