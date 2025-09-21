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
  var prayerID: String = ""
  var previousCount: Int = 0
  var newCount: Int = 0
  var changeDate = Date.now
  var changeAmount: Int = 0

  init(
    prayerID: String,
    previousCount: Int,
    newCount: Int,
    changeDate: Date = .now
  ) {
    self.prayerID = prayerID
    self.previousCount = previousCount
    self.newCount = newCount
    self.changeDate = changeDate
    self.changeAmount = newCount - previousCount
  }

  init(
    prayerID: String,
    changedAmount: Int,
    changeDate: Date = .now
  ) {
    self.prayerID = prayerID
    self.changeAmount = changedAmount
    self.changeDate = changeDate
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
