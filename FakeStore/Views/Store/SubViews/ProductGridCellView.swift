//
//  ProductGridCellView.swift
//  FakeStore
//
//  Created by Heshantha Don on 28/12/2023.
//

import SwiftUI

struct ProductGridCellView: View {
    // MARK: - PROPERTIES
    @Bindable var product: Product
    @State var size: Double
    
    // MARK: - BODY
    var body: some View {
        VStack {
            // MARK: - Favorite Button
            ZStack {
                Circle()
                    .fill(.white)
                    .overlay {
                        Circle()
                            .stroke(.black, lineWidth: 2)
                            .blur(radius: 4)
                            .mask(Circle())
                            .opacity(0.2)
                    } // OVERLAY
                
                FavoriteImage(isFavorite: .constant(product.isFavorite ?? false))
                    .frame(width: 17, height: 17)
                    .padding(.top, 2)
                    .padding(.leading, 1)
                    .padding(.horizontal, 8)
            } // ZSTACK
            .frame(maxWidth: .infinity, alignment: .trailing)
            .frame(height: 30)
            .padding(10)
            .padding(.top, 2)
            .animation(.easeInOut(duration: 0.3), value: product.isFavorite)
            .gesture(
                TapGesture().onEnded {
                    if product.isFavorite == nil {
                        product.isFavorite = true
                    } else {
                        product.isFavorite?.toggle()
                    }
                }
            ) // GESTURE
            
            Spacer()
            
            HStack {
                // MARK: - Product Title
                Text(product.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.leading, 5)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // MARK: - Product Price
                Text("\(Constants.currencySymbol + product.price.asPrice)")
                    .modifier(PrimaryTextStyle())
                    .foregroundStyle(Colors.GREEN_GRADIENT)
                    .padding(5)
                    .padding(.horizontal, 5)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                    .background {
                        let capsule = Capsule()
                        
                        capsule
                            .fill(Colors.GREEN_GRADIENT)
                            .overlay {
                                capsule
                                    .stroke(.black, lineWidth: 5)
                                    .blur(radius: 2)
                                    .mask(capsule)
                                    .opacity(0.2)
                                
                                capsule
                                    .strokeBorder(.black)
                                    .blendMode(.overlay)
                                    .opacity(0.3)
                            }
                    } // BACKGROUND
            } // HSTACK
            .frame(maxWidth: .infinity)
            .font(.caption)
            .foregroundStyle(.white)
            .padding(5)
            .padding(.bottom, 3)
            .background {
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .clipShape(.rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 10,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 0
                    ))
                    .shadow(color: .gray.opacity(0.5), radius: 15, x: 0, y: 3)
            } // BACKGROUND
        } // VSTACK
        .frame(height: 150)
        .frame(minWidth: 30, maxWidth: .infinity)
        .background {
            // MARK: - Background Card
            let roundedRectangle = RoundedRectangle(cornerRadius: 15, style: .continuous)
            
            ZStack {
                Color.gray.opacity(0.1)
                
                roundedRectangle
                    .fill(.white)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                
                roundedRectangle
                    .fill(.white)
                    .padding(2)
                    .blur(radius: 2)
                
                roundedRectangle
                    .stroke(.gray.opacity(0.2), lineWidth: 1)
                    .blendMode(.overlay)
                    .blur(radius: 1)
                
                // MARK: - Product Image
                AsyncImage(url: URL(string: product.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    case .failure(_):
                        EmptyView()
                    default:
                        // MARK: - Loading View
                        LoadingView()
                    }
                } // IMAGE
            } // ZSTACK
            .clipShape(roundedRectangle)
            .shadow(color: .white.opacity(0.02), radius: 4, x: -4, y: -4) //opacity(0.02)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 4, y: 4)
        } // BACKGROUND
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ProductGridCellView(product: StoreService.mocProducts[0], 
                     size: 400)
        .padding(.horizontal)
}
