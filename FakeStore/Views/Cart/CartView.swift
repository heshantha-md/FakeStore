//
//  CartView.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI
import SwiftData

struct CartView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query() private var cartItems: CartItems
    @Query(sort: \Product.title, order: .reverse) private var products: Products
    
    @State private var viewModel: CartViewModel = CartViewModel()
    @State private var isEditing = false
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Cart")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: isEditing ? "trash.fill" : "trash")
                            .font(.title3)
                    } // BUTTON
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    } // BUTTON
                } // HSTACK
            } // HSTACK
            .padding(.horizontal, 10)
            
            List {
                Section("Items in your cart") {
                    ForEach(viewModel.cartItems.indices, id:\.self) { index in
                        if let product = viewModel.products.first(where: { $0.id == viewModel.cartItems[index].id }) {
                            HStack {
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .foregroundStyle(.white)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.gray.opacity(0.5))
                                    } // BACKGROUND
                                
                                Group {
                                    Text(product.title)
                                    
                                    Spacer()
                                    
                                    Text("£\(product.price.asPrice)")
                                        .modifier(PriceTag())
                                    
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .onTapGesture {
                                                Task {
                                                    await viewModel.update(quantity: 1, model: viewModel.cartItems[index])
                                                }
                                            } // GESTURE
                                        
                                        Text("\(viewModel.cartItems[index].quantity)")
                                        
                                        Image(systemName: "minus.circle.fill")
                                            .onTapGesture {
                                                Task {
                                                    await viewModel.update(quantity: -1, model: viewModel.cartItems[index])
                                                }
                                            } // GESTURE
                                            .fontWeight(.heavy)
                                    } // HSTACK
                                    .font(.title3)
                                    .onChange(of: viewModel.cartItems[index].quantity, initial: false) {
                                        Task {
                                            await viewModel.getTotal()
                                        }
                                    } // ON CHANGE
                                } // GROUP
                                .font(.callout)
                            } // HSTACK
                        }
                    } // LOOP
                    .onDelete(perform: viewModel.deleteItems(at:))
                } // SECTION
            } // LIST
            .listStyle(.plain)
            .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
            
            HStack {
                Text("Total")
                Spacer()
                Text("£\(viewModel.cartTotal.asPrice)")
                    .fontWeight(.heavy)
            } // HSTACK
            .font(.title3)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Button("Buy".uppercased()) {
                // TODO: Need to implementing buy feature
            } // BUTTON
            .buttonStyle(PrimaryButton(disabled: viewModel.cartItems.count == 0))
            .disabled(viewModel.cartItems.count == 0)
            .padding(.horizontal, 10)
        } // VSTACK
        .padding(.vertical, 20)
        .onChange(of: cartItems, initial: true) {
            viewModel.cartItems = cartItems
            Task {
                await viewModel.getTotal()
            }
        } // ON CHANGE
        .onChange(of: products, initial: true) {
            viewModel.products = products
        } // ON CHANGE
        .onChange(of: viewModel.cartItems) {
            Task {
                await self.sync(newCartItems: viewModel.cartItems, with: cartItems, in: modelContext)
            }
        } // ON CHANGE
        .onChange(of: viewModel.products) {
            Task {
                await self.sync(newProducts: viewModel.products, with: products, in: modelContext)
            }
        } // ON CHANGE
        .onChange(of: viewModel.deleteCartItems) {
            Task {
                await self.delete(items: viewModel.deleteCartItems, in: modelContext)
            }
        } // ON CHANGE
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    CartView()
        .modelContainer(for: FakeStoreApp.modelContainer, inMemory: false)
        .environment(StoreService(manager: MocNetworkManager()))
}
