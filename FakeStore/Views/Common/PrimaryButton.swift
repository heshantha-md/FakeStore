//
//  PrimaryButton.swift
//  FakeStore
//
//  Created by Heshantha Don on 31/01/2024.
//

import SwiftUI

struct PrimaryButton: View {
    // MARK: - PROPERTIES
    @GestureState private var didTap = false
    @State private var didPress = false
    var title: String
    var loadingSymbol: String
    var backgroundColor: LinearGradient
    var action: () async -> Void
    let disabled: Bool
    
    init(title: String,
         loadingSymbol: String,
         backgroundColor: LinearGradient = Colors.ORAGNE_GRADIENT,
         action: @escaping () async -> Void,
         disabled: Bool = false) {
            self.title = title
            self.loadingSymbol = loadingSymbol
            self.backgroundColor = backgroundColor
            self.action = action
            self.disabled = disabled
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // MARK: - Title
            Text(title)
                .opacity(didTap ? 0 : 1)
            
            // MARK: - Loading Icon
            Group {
                Image(systemName: loadingSymbol)
                    .foregroundStyle(.white)
                    .opacity(didTap ? 1 : 0)
                
                Image(systemName: loadingSymbol)
                    .foregroundStyle(backgroundColor)
                    .clipShape(Rectangle().offset(y: didTap ? 0 : 50))
                    .opacity(didTap ? 1 : 0)
            } // GROUP
        } // ZSTACK
        .gesture(
            // MARK: - Long Press Handler
            LongPressGesture().updating($didTap) { currentState, gestureState, transaction in
                if !disabled {
                    gestureState = currentState
                }
            }
            .onEnded { _ in
                if !disabled {
                    Task {
                        await action()
                        didPress.toggle()
                    }
                }
            }
        ) // GESTURE
        .animation(.smooth(duration: 0.6), value: didTap)
        .modifier(PrimaryButtonStyle(disabled: disabled))
        .padding(.horizontal, 10)
        .scaleEffect(didTap ? 0.95 : 1)
        .animation(.bouncy(duration: 0.4, extraBounce: 0.5), value: didPress)
        .padding(.bottom, 20)
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    PrimaryButton(title: "Title",
                  loadingSymbol: "home.fill",
                  action: {
        // Do Something here
    }, disabled: false)
    .padding(.horizontal, 20)
}
