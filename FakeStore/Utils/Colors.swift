//
//  AppColors.swift
//  FakeStore
//
//  Created by Heshantha Don on 29/01/2024.
//

import SwiftUI

struct Colors {
    static let ORAGNE_GRADIENT = LinearGradient(colors: [Color(hex: "#F54160"), Color(hex: "#F9B553")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let RED_GRADIENT = LinearGradient(colors: [Color(hex: "#F54160"), Color(hex: "#F54160"), Color(hex: "#F9B553")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let BLUE_GRADIENT = LinearGradient(colors: [.cyan, .green], startPoint: .topTrailing, endPoint: .bottomLeading)
    static let GREEN_YELLOW_GRADIENT = LinearGradient(colors: [Color(hex: "#F9B553"), .yellow, .green], startPoint: .topTrailing, endPoint: .bottomLeading)
    static let GOLD_GRADIENT = LinearGradient(colors: [.yellow, Color(hex: "#F9B553")], startPoint: .topTrailing, endPoint: .bottomLeading)
    static let BACKGROUND = Color.white
    static let WHITE_DIVIDER_GRADIENT = LinearGradient(stops: [.init(color: .clear, location: -0.3), .init(color: .white, location: 0.5), .init(color: .clear, location: 1.3)], startPoint: .leading, endPoint: .trailing)
    static let WHITE_BACKGROUND_GRADIENT = LinearGradient(colors: [.gray.opacity(0.05), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let GREEN_GRADIENT = LinearGradient(colors: [.green, Color(hex: "#2AB57E")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let DARK_GREEN = Color(hex: "#2CC095")
    static let GREEN_SET = [.green, DARK_GREEN]
}
