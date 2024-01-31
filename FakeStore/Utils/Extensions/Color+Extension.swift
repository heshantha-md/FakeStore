//
//  Color+Extension.swift
//  FakeStore
//
//  Created by Heshantha Don on 30/01/2024.
//

import SwiftUI

extension Color {
  // MARK: - Convert String Hex value to Color
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
    let rgbValue = UInt32(hex, radix: 16)
    let r = Double((rgbValue! & 0xFF0000) >> 16) / 255
    let g = Double((rgbValue! & 0x00FF00) >> 8) / 255
    let b = Double(rgbValue! & 0x0000FF) / 255
    self.init(red: r, green: g, blue: b)
  }
}
