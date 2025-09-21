//
//  PrayerGridView.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftUI

struct PrayerGridView: View {
  // swiftlint:disable:next large_tuple
  let items: [(name: String, icon: String?, count: Int)]

  private let columns: [GridItem] = [
    GridItem(.adaptive(minimum: 150))
  ]

  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(items, id: \.name) { prayer in
        GridBubbleItem(
          name: prayer.name,
          icon: prayer.icon,
          count: prayer.count
        )
      }
    }
    .padding()
  }
}

private struct GridBubbleItem: View {
  let name: String
  let icon: String?
  let count: Int

  @State private var displayCount: Int

  init(name: String, icon: String?, count: Int) {
    self.name = name
    self.icon = icon
    self.count = count
    self._displayCount = State(initialValue: count)
  }

  var body: some View {
    BubbleView(
      count: $displayCount,
      scale: 1.0
    ) {
      Label {
        Text(name)
          .lineLimit(1)
      } icon: {
        if let icon = icon {
          Image(systemName: icon)
        }
      }
      .font(.system(.caption, design: .rounded, weight: .medium))
    }
    .frame(minHeight: 100)
    .allowsHitTesting(false)
  }
}
