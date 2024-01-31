//
//  GridToolBarItem.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI

enum SecondaryButtonBackground {
    case white
    case cyan
}

struct SecondaryButton: View {
    // MARK: - PROPERTIES
    var action: (Any?) async -> Void
    @Binding var sfSymbol: String
    var color: LinearGradient
    var buttonBackground: SecondaryButtonBackground
    
    private var icon: Image {
        return Image(systemName: sfSymbol)
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            Task {
                await action(nil)
            }
        } label: {
            ZStack {
                icon
                    .foregroundStyle(.gray.opacity(0.2))
                    .blur(radius: 1)
                
                Group {
                    if buttonBackground == .white {
                        icon
                            .foregroundStyle(color)
                    } else {
                        icon
                            .foregroundStyle(.white)
                    }
                }
                .offset(x: -0.5)
                
                icon
                    .foregroundStyle(.gray.opacity(0.4))
                    .offset(x: 3, y: 1)
                    .blur(radius: 2)
                
                if buttonBackground == .white {
                    icon
                        .foregroundStyle(color)
                } else {
                    icon
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 30, height: 30)
            .font(.system(size: 24, weight: .heavy))
            .modifier(SecondaryButtonShadows(buttonBackground: buttonBackground))
        } // BUTTON
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    SecondaryButton(action: { layout in
        // Do Something here
    }, sfSymbol: .constant("rectangle.grid.1x2.fill"), 
       color: Colors.BLUE_GRADIENT,
       buttonBackground: .white)
}
