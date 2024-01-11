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
            Button {
                if product.isFavorite == nil {
                    product.isFavorite = true
                } else {
                    product.isFavorite?.toggle()
                }
            } label: {
                Image(systemName: (product.isFavorite ?? false) ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 18, height: 16)
                    .scaledToFit()
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)
            } // BUTTON
            .frame(maxWidth: .infinity, alignment: .trailing)
            .frame(height: 40)
            
            Spacer()
            
            HStack {
                Text(product.title)
                
                Spacer()
                
                Text("£\(product.price.asPrice)")
                    .padding(5)
                    .padding(.horizontal, 5)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.black)
                    } // BACKGROUND
            } // HSTACK
            .frame(maxWidth: .infinity)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(5)
            .background {
                Rectangle()
                    .fill(.gray.opacity(0.5))
                    .clipShape(.rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 10,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 0
                    ))
            } // BACKGROUND
        } // VSTACK
        .frame(height: 150)
        .frame(minWidth: 30, maxWidth: .infinity)
        .background {
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    Rectangle()
                        .fill(.white)
                        .overlay {
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                        } // OVERLAY
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 3)
                case .failure(let error):
                    VStack(spacing: 10) {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                        Text(error.localizedDescription.uppercased())
                    } // VSTACK
                    .foregroundStyle(.red.gradient)
                    .padding()
                default:
                    ProgressView()
                }
            } // IMAGE
        } // BACKGROUND
    } // BODY
} // STRUCT

// MARK: - PREVIEW
#Preview {
    ProductGridCellView(product: StoreService.mocProducts[0], 
                     size: 400)
        .padding(.horizontal)
}
