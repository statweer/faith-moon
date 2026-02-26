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

  func format(_ value: Date) -> String {
    let calendar = Calendar.current
    let sameYear = calendar.component(.year, from: value) == calendar.component(.year, from: Date.now)

    if sameYear {
      return value.formatted(
        .dateTime.weekday(.abbreviated).day().month(.abbreviated).hour().minute()
      )
    } else {
      return value.formatted(
        .dateTime.weekday(.abbreviated).day().month(.abbreviated).year().hour().minute()
      )
    }
  }
}

extension FormatStyle where Self == IntelligentDateFormatStyle {
  static var intelligent: IntelligentDateFormatStyle { IntelligentDateFormatStyle() }
}
