//
//  LoadingView.swift
//  FakeStore
//
//  Created by Heshantha Don on 31/01/2024.
//

import SwiftUI

struct LoadingView: View {
    // MARK: - PROPERTIES
    @State private var isRotating = 0.0
    
    // MARK: - PROPERTIES
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(LinearGradient(colors: [.cyan, .green.opacity(0.5)], startPoint: .bottomLeading, endPoint: .topLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .frame(width: 40, height: 40)
            .rotationEffect(.degrees(isRotating))
            .padding(.bottom, 25)
            .shadow(color: .cyan.opacity(0.3), radius: 5, x: 3, y: 3)
            .onAppear {
                withAnimation(.linear(duration: 1).speed(1).repeatForever(autoreverses: false)) {
                    isRotating = 360
                }
            }
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    LoadingView()
        .padding()
}
