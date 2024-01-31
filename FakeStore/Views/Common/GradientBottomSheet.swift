//
//  GradientBottomSheet.swift
//  FakeStore
//
//  Created by Heshantha Don on 30/01/2024.
//

import SwiftUI

struct GradientBottomSheet: View {
    // MARK: - PROPERTIES
    var backgroundColor: LinearGradient
    var cornerRadius: CGFloat
    var dragBarVisible: Bool
    
    init(backgroundColor: LinearGradient, 
         cornerRadius: CGFloat = 15,
         dragBarVisible: Bool = false) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.dragBarVisible = dragBarVisible
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            let roundedRectangle = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            
            roundedRectangle
                .fill(backgroundColor)
                .overlay {
                    roundedRectangle
                        .fill(.black.opacity(0.2))
                    
                    roundedRectangle
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .blendMode(.overlay)
                } // OVERLAY
                .shadow(color: .gray.opacity(0.6), radius: 5)
                .ignoresSafeArea()
        } // ZSTACK
        .overlay(alignment: .top) {
            if dragBarVisible {
                Capsule()
                    .fill(.white)
                    .frame(width: 40, height: 5)
                    .modifier(InnerShadow(shape: Capsule(),
                                          depth: 3,
                                          offset: (x: 0, y: -1)))
                    .padding(.top, 13)
            }
        } // OVERLAY
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ZStack {
        Text("Hello World")
    } // ZSTACK
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
        GradientBottomSheet(backgroundColor: Colors.BLUE_GRADIENT)
            .padding(.top, 10)
    } // BACKGROUND
}
