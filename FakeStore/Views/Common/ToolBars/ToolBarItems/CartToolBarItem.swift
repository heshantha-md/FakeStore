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
    @State private var countBubbleAngle: Double = 0
    
    // MARK: - BODY
    var body: some View {
        SecondaryButton(action: { layout in
            isSheetPresented.toggle()
        }, sfSymbol: .constant("cart.fill"),
           color: Colors.GOLD_GRADIENT,
           buttonBackground: .white)
        .overlay(alignment: .topTrailing) {
            ZStack {
                Group {
                    Circle()
                        .fill(Colors.RED_GRADIENT)
                    
                    Circle()
                        .foregroundStyle(.black.opacity(0.2))
                    
                    Circle()
                        .foregroundStyle(.black.opacity(0.15))
                        .blur(radius: 0.5)
                        .offset(x: -1, y: -1)
                    
                    Circle()
                        .foregroundStyle(Colors.RED_GRADIENT)
                        .padding(1)
                        .blur(radius: 1)
                }
            }
            .frame(width: 20, height: 20)
            .overlay {
                Text("\(itemCount)")
                    .frame(width: 15, height: 15)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .rotation3DEffect(Angle(degrees: countBubbleAngle > 0 ? countBubbleAngle : 0), axis: (x: 0, y: 1, z: 0))
            }
            .rotation3DEffect(Angle(degrees: countBubbleAngle), axis: (x: 0, y: 1, z: 0))
            .offset(x: 5, y: -10)
            .shadow(color: .white.opacity(0.5), radius: 5, x: -2, y: -2)
            .shadow(color: .gray.opacity(0.5), radius: 3, x: 3, y: 3)
            .animation(.bouncy(duration: 1, extraBounce: 0.3), value: countBubbleAngle)
//            .opacity(itemCount > 0 ? 1 : 0)
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
                .background(Color.clear)
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
        await rotateCountBubble()
    }
    
    @MainActor
    private func rotateCountBubble() async {
        withAnimation {
            countBubbleAngle += 180
        }
    }
    
    private func isVertical(width: Double, height: Double) -> Bool {
        return abs(width) < abs(height)
    }
}
