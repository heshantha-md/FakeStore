//
//  ErrorManager.swift
//  FakeStore
//
//  Created by Heshantha Don on 10/01/2024.
//

import Foundation
import SwiftUI

// MARK: - PROTOCOL
protocol ErrorManagerProtocol {
    var errorMessage: String? { get set }
    func handle(error: Error)
}

// MARK: - ERROR MANAGER
@Observable
final class ErrorManager: ErrorManagerProtocol {
    // MARK: - PROPERTIES
    var errorMessage: String?
    
    func handle(error: Error) {
        self.errorMessage = error.localizedDescription
    }
}

// MARK: - VIEW MODIFIER
struct ErrorAlertViewModifier: ViewModifier {
    @Environment(ErrorManager.self) var manager
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(manager.errorMessage != nil)) {
                Alert(title: Text("Error"),
                      message: Text(manager.errorMessage ?? "Something Went Wrong"),
                      dismissButton: .default(Text("OK")) {
                        manager.errorMessage = nil
                      }
                )
            }
    }
}
