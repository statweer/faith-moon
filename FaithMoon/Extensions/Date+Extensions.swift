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

  var locale: Locale
  var calendar: Calendar

  func format(_ value: Date) -> String {
    let sameYear = calendar.component(.year, from: value) == calendar.component(.year, from: Date.now)

    if sameYear {
      return value.formatted(
        Date.FormatStyle(locale: locale, calendar: calendar)
          .weekday(.abbreviated).day().month(.abbreviated).hour().minute()
      )
    } else {
      return value.formatted(
        Date.FormatStyle(locale: locale, calendar: calendar)
          .weekday(.abbreviated).day().month(.abbreviated).year().hour().minute()
      )
    }
  }
}

extension FormatStyle where Self == IntelligentDateFormatStyle {
  static func intelligent(locale: Locale, calendar: Calendar) -> IntelligentDateFormatStyle {
    IntelligentDateFormatStyle(locale: locale, calendar: calendar)
  }
}
