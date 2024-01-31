//
//  CustomStyles.swift
//  StyleSheet
//
//  Created by Heshantha Don on 02/01/2024.
//

import SwiftUI

// MARK: - PRIMARY BUTTON STYLE
struct PrimaryButtonStyle: ViewModifier {
    let disabled: Bool
    
    func body(content: Content) -> some View {
        let roundedRectangle = RoundedRectangle(cornerRadius: 8, style: .continuous)
        
        content
            .frame(maxWidth: .infinity)
            .font(.title)
            .modifier(PrimaryTextStyle())
            .foregroundStyle(.white)
            .padding(10)
            .background {
                ZStack {
                    Color(.gray.opacity(0.1))
                    
                    roundedRectangle
                        .foregroundStyle(Colors.GREEN_YELLOW_GRADIENT)
                        .blur(radius: 2)
                        .offset(x: -2, y: -2)
                    
                    roundedRectangle
                        .foregroundStyle(.gray.opacity(0.1))
                        .padding(5)
                }
            }
            .clipShape(roundedRectangle)
            .background(
                roundedRectangle
                    .foregroundStyle(Colors.GREEN_YELLOW_GRADIENT.opacity(0.5))
                    .blur(radius: 25)
                    .offset(y: -20)
            )
            .shadow(color: .black.opacity(0.2), radius: 20, x: 20, y: 20)
            .frame(maxWidth: .infinity)
            .opacity(disabled ? 0.3 : 1)
    } // BODY
} // STRUCT

// MARK: - PRIMARY TEXT STYLE
struct PrimaryTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    content
                        .foregroundStyle(.gray.opacity(0.5))
                        .blur(radius: 2)
                    
                    content
                        .foregroundStyle(.gray.opacity(0.2))
                        .scaleEffect(0.98)
                        .blur(radius: 1)
                    
                    content
                        .foregroundStyle(.white.opacity(0.9))
                        .offset(y: -1)
                }
            }
            .fontWeight(.heavy)
    } // BODY
} // STRUCT

// MARK: - PRICE TAG
struct PriceTag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .fontWeight(.bold)
            .foregroundStyle(Colors.BLUE_GRADIENT)
            .background {
                Capsule()
                    .fill()
            }
    }
}

// MARK: - SECONDARY BUTTON SHADOWS
struct SecondaryButtonShadows: ViewModifier {
    var buttonBackground: SecondaryButtonBackground
    
    func body(content: Content) -> some View {
        content
            .shadow(color: buttonBackground == .cyan ? .cyan : .white, radius: 1, x: -1, y: -1)
            .shadow(color: .gray.opacity(0.2), radius: 2, x: 2, y: 2)
    }
}

// MARK: - APP LOGO STYLE
struct AppLogoStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.clear)
            .background(.clear)
            .overlay {
                ZStack {
                    content
                        .foregroundStyle(.gray.opacity(0.2))
                        .blur(radius: 1)
                    
                    content
                        .foregroundStyle(.white)
                        .offset(x: -0.5)
                    
                    content
                        .foregroundStyle(.gray.opacity(0.3))
                        .offset(x: 3, y: 1)
                        .blur(radius: 2)
                    
                    content
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            .modifier(SecondaryButtonShadows(buttonBackground: .white))
    }
}

// MARK: - Inner Shadow
struct InnerShadow<S: Shape>: ViewModifier {
    var shape: S
    var shadowColor: Color
    var depth: CGFloat
    var offset: (x: CGFloat, y: CGFloat)
    var blurRadius: CGFloat
    var strokeColor: Color
    var strokelineWidth: CGFloat
    
    init(shape: S,
         shadowColor: Color = .gray.opacity(0.3),
         depth: CGFloat,
         offset: (x: CGFloat, y: CGFloat) = (x: 0, y: 0),
         blurRadius: CGFloat = 1,
         strokeColor: Color = .black.opacity(0.5),
         strokelineWidth: CGFloat = 1) {
        self.shape = shape
        self.shadowColor = shadowColor
        self.depth = depth
        self.offset = offset
        self.blurRadius = blurRadius
        self.strokeColor = strokeColor
        self.strokelineWidth = strokelineWidth
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                shape
                    .stroke(shadowColor, lineWidth: depth)
                    .offset(x: offset.x, y: offset.y)
                    .blur(radius: blurRadius)
                    .mask(shape)
                
                shape
                    .stroke(strokeColor, lineWidth: strokelineWidth)
                    .blendMode(.overlay)
            }
    }
}

// MARK: - Flexible Text Wrapper
struct FlexibleTextWrapper<S: Shape>: ViewModifier {
    var shape: S
    var fillColor: Color
    var strokeColor: Color
    var strokeLineWidth: CGFloat
    var foregroundGradient: LinearGradient
    
    init(shape: S,
         fillColor: Color,
         strokeColor: Color = .black.opacity(0.5),
         strokeLineWidth: CGFloat = 1,
         foregroundGradient: LinearGradient) {
        self.shape = shape
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeLineWidth = strokeLineWidth
        self.foregroundGradient = foregroundGradient
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.clear)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                ZStack {
                    shape
                        .fill(fillColor)
                        .overlay {
                            shape
                                .stroke(strokeColor, lineWidth: strokeLineWidth)
                                .blendMode(.overlay)
                        } // OVERLAY
                    
                    Group {
                        content
                            .foregroundStyle(.gray.opacity(0.2))
                            .blur(radius: 1)
                        
                        content
                            .foregroundStyle(.white)
                            .offset(x: -0.5)
                        
                        content
                            .foregroundStyle(.gray.opacity(0.6))
                            .offset(x: 3, y: 1)
                            .blur(radius: 2)
                        
                        content
                            .foregroundStyle(foregroundGradient)
                    } // GROUP
                    .shadow(color: fillColor, radius: 1, x: -1, y: -1)
                    .shadow(color: .gray.opacity(0.1), radius: 2, x: 2, y: 2)
                } // ZSTACK
            } // BACKGROUND
    }
}

// MARK: - Hide Tool Bar
struct HideToolBar: ViewModifier {
    @AppStorage("isTabBarHidden") var isTabBarHidden = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                withAnimation {
                    isTabBarHidden = true
                }
            }
            .onDisappear {
                withAnimation {
                    isTabBarHidden = false
                }
            }
    }
}
