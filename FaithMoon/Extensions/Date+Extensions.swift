//
//  Date+Extensions.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 9/21/25.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import Foundation

struct IntelligentDateFormatStyle: FormatStyle {
  typealias FormatInput = Date
  typealias FormatOutput = String

  var referenceDate: Date = .now

  func format(_ value: Date) -> String {
    let calendar = Calendar.current
    let daysBetween = calendar.dateComponents([.day], from: value, to: referenceDate).day ?? 0

    // Today and yesterday: use relative
    if daysBetween <= 1 && daysBetween >= 0 {
      let timeSinceNow = referenceDate.timeIntervalSince(value)
      // If less than a minute, manually return "just now" to avoid showing seconds
      if timeSinceNow < 60 {
        // Use localized string for "just now" if available in the app
        return NSLocalizedString("just_now", value: "Just now", comment: "Date shown for very recent changes")
      }
      return value.formatted(.relative(presentation: .named, unitsStyle: .wide))
    }

    // Between yesterday and a week earlier: show weekday
    if daysBetween > 1 && daysBetween <= 7 {
      return value.formatted(.dateTime.weekday(.wide))
    }

    // Within a year: show day and month
    if calendar.component(.year, from: value) == calendar.component(.year, from: referenceDate) {
      return value.formatted(.dateTime.day().month())
    } else {
      // Older than a year: show day, month, and year
      return value.formatted(.dateTime.day().month().year())
    }
  }
}

extension FormatStyle where Self == IntelligentDateFormatStyle {
  static var intelligent: IntelligentDateFormatStyle { IntelligentDateFormatStyle() }

  static func intelligent(relativeTo referenceDate: Date) -> IntelligentDateFormatStyle {
    IntelligentDateFormatStyle(referenceDate: referenceDate)
  }
}

extension Date {
  var intelligentFormat: String {
    self.formatted(.intelligent)
  }

  func intelligentFormat(relativeTo referenceDate: Date) -> String {
    self.formatted(.intelligent(relativeTo: referenceDate))
  }
}
