//
//  PrayerLog.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 9/15/25.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class PrayerLog {
  var id = UUID()
  var prayerName: String = ""
  var previousCount: Int = 0
  var newCount: Int = 0
  var changeDate = Date.now
  var changeAmount: Int = 0

  init(
    prayerName: String,
    previousCount: Int,
    newCount: Int,
    changeDate: Date = .now
  ) {
    self.prayerName = prayerName
    self.previousCount = previousCount
    self.newCount = newCount
    self.changeDate = changeDate
    self.changeAmount = newCount - previousCount
  }
}

extension PrayerLog {
  var formattedChangeAmount: String {
    if changeAmount > 0 {
      return "+\(changeAmount)"
    } else {
      return "\(changeAmount)"
    }
  }

  var isIncrease: Bool {
    changeAmount > 0
  }

  var isDecrease: Bool {
    changeAmount < 0
  }
}
