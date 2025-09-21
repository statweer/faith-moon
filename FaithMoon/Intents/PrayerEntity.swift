//
//  PrayerEntity.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import AppIntents
import Foundation
import SwiftData

struct PrayerEntity: AppEntity {
  static let typeDisplayRepresentation: TypeDisplayRepresentation = "Prayer"
  static let defaultQuery = PrayerQuery()

  var id: String
  var displayName: String

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(title: "\(displayName)")
  }
}

struct PrayerQuery: EntityQuery {
  func entities(for identifiers: [String]) async throws -> [PrayerEntity] {
    await MainActor.run {
      let prayers = DataController.shared.fetchPrayers()
      return prayers
        .filter { identifiers.contains($0.id) }
        .map { PrayerEntity(id: $0.id, displayName: String(localized: String.LocalizationValue($0.localizationKey))) }
    }
  }

  func suggestedEntities() async throws -> [PrayerEntity] {
    await MainActor.run {
      let prayers = DataController.shared.fetchPrayers()
      return prayers.map {
        PrayerEntity(id: $0.id, displayName: String(localized: String.LocalizationValue($0.localizationKey)))
      }
    }
  }

  func defaultResult() async -> PrayerEntity? {
    try? await suggestedEntities().first
  }
}
