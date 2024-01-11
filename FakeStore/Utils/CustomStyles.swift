//
//  CustomStyles.swift
//  FakeStore
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    
    let disabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .font(.title)
            .fontWeight(.heavy)
            .foregroundStyle(.white)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(disabled ? .gray : .black)
            }
    }
}

struct PriceTag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .background {
                Capsule()
                    .fill()
            }
    }
}
