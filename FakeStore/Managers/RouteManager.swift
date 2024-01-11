//
//  RouterManager.swift
//  FakeStore
//
//  Created by Heshantha Don on 27/12/2023.
//

import SwiftUI

@Observable 
class RouteManager {
    // MARK: - PROPERTIES
    var homeNavPath = NavigationPath()
    var favoriteNavPath = NavigationPath()
    var settingsNavPath = NavigationPath()
    var currentTab = tabEndPoint.Home
    
    // MARK: - FUNCTIONS
    func resetNavigationPaths() {
        homeNavPath = NavigationPath()
        favoriteNavPath = NavigationPath()
        settingsNavPath = NavigationPath()
    }
}

// MARK: - ENUM
enum tabEndPoint {
    case Home, Favorites, Settings
}

enum navigationEndPoint: Hashable {
    case HomeGridDetailsView(Product)
}
