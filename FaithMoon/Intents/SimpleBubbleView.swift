//
//  SimpleBubbleView.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftUI

struct SimpleBubbleView: View {
  let prayerName: String
  let prayerIcon: String?
  let count: Int

  @State private var displayCount: Int

  init(prayerName: String, prayerIcon: String?, count: Int) {
    self.prayerName = prayerName
    self.prayerIcon = prayerIcon
    self.count = count
    self._displayCount = State(initialValue: count)
  }

  var body: some View {
    BubbleView(count: $displayCount) {
      Label {
        Text(prayerName)
      } icon: {
        if let icon = prayerIcon {
          Image(systemName: icon)
        }
      }
      .font(.system(.title3, design: .rounded, weight: .medium))
    }
    .frame(width: 180, height: BubbleViewConstants.minHeight * BubbleColorPalette.scale(for: count))
    .allowsHitTesting(false)
    .padding(.vertical)
  }
}
