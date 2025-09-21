//
//  BubbleColorPalette.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftUI

enum BubbleColorPalette {
  static let colors: [Color] = [
    .green,
    .green.mix(with: .yellow, by: 0.2),
    .green.mix(with: .yellow, by: 0.4),
    .green.mix(with: .yellow, by: 0.6),
    .green.mix(with: .yellow, by: 0.8),
    .yellow,
    .yellow.mix(with: .orange, by: 0.2),
    .yellow.mix(with: .orange, by: 0.4),
    .yellow.mix(with: .orange, by: 0.6),
    .yellow.mix(with: .orange, by: 0.8),
    .orange,
    .orange.mix(with: .red, by: 0.2),
    .orange.mix(with: .red, by: 0.4),
    .orange.mix(with: .red, by: 0.6),
    .orange.mix(with: .red, by: 0.8),
    .red
  ]

  static func scale(for count: Int) -> CGFloat {
    max(1.0, min(CGFloat(count) * 0.1 + 1.0, BubbleViewConstants.ratio))
  }

  static func color(for count: Int) -> Color {
    let scale = self.scale(for: count)
    let fraction = (scale - 1.0) / (BubbleViewConstants.ratio - 1.0)
    let index = min(Int(fraction * CGFloat(colors.count)), colors.count - 1)
    return colors[index]
  }
}
