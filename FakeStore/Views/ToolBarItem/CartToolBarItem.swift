//
//  CartToolBarItem.swift
//  FakeStore
//
//  Created by Heshantha Don on 30/12/2023.
//

import SwiftUI
import SwiftData

struct CartToolBarItem: View {
    // MARK: - PROPERTIES
    @Query() private var cartItems: CartItems
    
    @State private var itemCount: Int = 0
    @State private var isSheetPresented = false
    @State private var sheetSize: SheetSize = .medium
    
    // MARK: - BODY
    var body: some View {
        Button {
            isSheetPresented.toggle()
        } label: {
            Image(systemName: "cart.fill")
                .font(.title3)
                .foregroundStyle(.black)
        } // BUTTON
        .overlay(alignment: .topTrailing) {
            Text("\(itemCount)")
                .frame(width: 15, height: 15)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(.white)
                .padding(2)
                .background {
                    Circle()
                        .fill(.red)
                }
                .opacity(itemCount > 0 ? 1 : 0)
        } // OVERLAY
        .onChange(of: cartItems, initial: true) {
            Task {
                await updateCount()
            }
        } // ON CHANGE
        .sheet(isPresented: $isSheetPresented) {
            CartView()
                .presentationDetents([.medium, .large])
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if isVertical(width: value.translation.width, height: value.translation.height) {
                                if value.translation.height > 0 {
                                    sheetSize = .hidden
                                } else {
                                    sheetSize = value.translation.height < -100 ? .large : .medium
                                }
                            }
                        }
                        .onEnded { value in
                            if isVertical(width: value.translation.width, height: value.translation.height) {
                                if sheetSize == .hidden {
                                    isSheetPresented = false
                                }
                            }
                        }
                ) // GESTURE
        } // SHEET
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    CartToolBarItem()
        .modelContainer(for: FakeStoreApp.modelContainer, inMemory: false)
}

// MARK: - ENUM
enum SheetSize {
    case hidden, medium, large
}

// MARK: - EXTENSION
extension CartToolBarItem {
    @MainActor
    private func updateCount() async {
        itemCount = cartItems.count
    }
    
    private func isVertical(width: Double, height: Double) -> Bool {
        return abs(width) < abs(height)
    }
}
