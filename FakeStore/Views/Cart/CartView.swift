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
        VStack(spacing: 12) {
            // MARK: - Tool Bar
            HStack {
                // MARK: - Tool Bar Title
                Text(Constants.CART)
                    .font(.largeTitle)
                    .modifier(PrimaryTextStyle())
                
                Spacer()
                
                // MARK: - Trailing Button
                HStack(spacing: 20) {
                    SecondaryButton(action: { _ in
                        isEditing.toggle()
                    }, sfSymbol: .constant(isEditing ? "trash.fill" : "trash"),
                       color: Colors.BLUE_GRADIENT,
                       buttonBackground: .cyan)
                    
                    SecondaryButton(action: { _ in
                        dismiss()
                    }, sfSymbol: .constant("xmark"),
                       color: Colors.BLUE_GRADIENT,
                       buttonBackground: .cyan)
                } // HSTACK
            } // HSTACK
            .padding(.horizontal, 20)
            
            // MARK: - Cart Item List
            List {
                Section(Constants.ITEMS_IN_YOUR_CART) {
                    ForEach(viewModel.cartItems.indices, id:\.self) { index in
                        if let product = viewModel.products.first(where: { $0.id == viewModel.cartItems[index].id }) {
                            HStack {
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.gray.opacity(0.5))
                                    } // BACKGROUND
                                
                                Group {
                                    // MARK: - Product Title
                                    Text(product.title)
                                    
                                    Spacer()
                                    
                                    // MARK: - Product Price
                                    Text("\(Constants.currencySymbol + product.price.asPrice)")
                                        .modifier(PriceTag())
                                    
                                    // MARK: - Product Quantity
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
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(.white)
                    .listSectionSeparator(.hidden)
                } // SECTION
            } // LIST
            .listStyle(.plain)
            .background(.clear)
            .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
            
            Divider()
                .background(Colors.WHITE_DIVIDER_GRADIENT)
            
            // MARK: - Cart Total
            HStack {
                Text(Constants.TOTAL)
                    .modifier(PrimaryTextStyle())
                Spacer()
                Text("\(Constants.currencySymbol + viewModel.cartTotal.asPrice)")
                    .modifier(PrimaryTextStyle())
            } // HSTACK
            .font(.title3)
            .padding(.horizontal, 20)
            .padding(.bottom, 23)
            .zIndex(1)
            
            // MARK: - Pay button
            PrimaryButton(title: Constants.PAY.uppercased(),
                          loadingSymbol: "sterlingsign.circle.fill",
                          action: {
                // TODO: Need to implementing buy feature
            }, disabled: viewModel.cartItems.count == 0)
            .padding(.horizontal, 10)
        } // VSTACK
        .foregroundStyle(.white)
        .padding(.vertical, 20)
        .background {
            // MARK: - Gradient Bottom Sheet
            GradientBottomSheet(backgroundColor: Colors.BLUE_GRADIENT,
                                cornerRadius: 10)
        }
        .background(Color.clear)
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
        .environment(ErrorManager())
}
