//
//  Prayer.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 3/30/24.
//  Copyright © 2024 Saeed Tatweer IT Services Est. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Prayer: Identifiable {
  let id = ""
  let localizationKey = ""
  let intrinsicOrder = -1
  private(set) var count = 0
  private(set) var lastModified: Date?

  init(
    slug: String,
    localizationKey: String,
    intrinsicOrder: Int
  ) {
    self.id = slug
    self.localizationKey = localizationKey
    self.intrinsicOrder = intrinsicOrder
  }

  func update<T>(
    keyPath: ReferenceWritableKeyPath<Prayer, T>,
    to value: T
  ) {
    self[keyPath: keyPath] = value
    lastModified = .now
  }

  func update<T>(
    _ keyPath: KeyPath<Prayer, T>,
    to value: T
  ) {
    guard let referenced = keyPath as? ReferenceWritableKeyPath<Prayer, T> else {
      return
    }

    update(keyPath: referenced, to: value)
  }
}

extension Prayer: Equatable {
  static func == (lhs: Prayer, rhs: Prayer) -> Bool {
    lhs.id == rhs.id &&
    lhs.localizationKey == rhs.localizationKey &&
    lhs.intrinsicOrder == rhs.intrinsicOrder &&
    lhs.count == rhs.count
  }
}

extension Prayer: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
}

extension Prayer {
  var systemImage: String {
    switch localizationKey {
    case "Fajr": "sunrise"
    case "Dhuhr": "sun.max"
    case "Asr": "sun.dust"
    case "Maghrib": "sunset"
    case "Isha": "moon"
    case "Ayat": "tropicalstorm"
    case "Ramadan Fast": "sparkles"
    default: "laurel.leading"
    }
  }
}

// MARK: - App Data

extension Prayer {
  static let defaultValues: [Prayer] = {
    [
      .init(
        slug: "fajr",
        localizationKey: "Fajr",
        intrinsicOrder: 10
      ),
      .init(
        slug: "duhr",
        localizationKey: "Dhuhr",
        intrinsicOrder: 20
      ),
      .init(
        slug: "asr",
        localizationKey: "Asr",
        intrinsicOrder: 30
      ),
      .init(
        slug: "maghrib",
        localizationKey: "Maghrib",
        intrinsicOrder: 40
      ),
      .init(
        slug: "isha",
        localizationKey: "Isha",
        intrinsicOrder: 50
      ),
      .init(
        slug: "ayat",
        localizationKey: "Ayat",
        intrinsicOrder: 60
      ),
      .init(
        slug: "ramadan-fast",
        localizationKey: "Ramadan Fast",
        intrinsicOrder: 70
      )
    ]
  }()
}
