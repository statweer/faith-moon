//
//  FaithMoonMigrationPlan.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftData
import Foundation

// MARK: - V1 Schema (Original App Store version - Prayer only, no PrayerLog)
enum FaithMoonSchemaV1: VersionedSchema {
  static let versionIdentifier = Schema.Version(1, 0, 0)

  static var models: [any PersistentModel.Type] {
    [Prayer.self]
  }

  @Model
  final class Prayer {
    var id = ""
    var localizationKey = ""
    var intrinsicOrder = -1
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
  }
}

// MARK: - V2 Schema (Current - Added PrayerLog)
enum FaithMoonSchemaV2: VersionedSchema {
  static let versionIdentifier = Schema.Version(2, 0, 0)

  static var models: [any PersistentModel.Type] {
    [Prayer.self, PrayerLog.self]
  }

  @Model
  final class Prayer {
    var id = ""
    var localizationKey = ""
    var intrinsicOrder = -1
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
  }

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
  }
}

// MARK: - Migration Plan
enum FaithMoonMigrationPlan: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [FaithMoonSchemaV1.self, FaithMoonSchemaV2.self]
  }

  static var stages: [MigrationStage] {
    [migrateV1toV2]
  }

  // V1 → V2: Add PrayerLog model (lightweight - adding new model)
  static let migrateV1toV2 = MigrationStage.lightweight(
    fromVersion: FaithMoonSchemaV1.self,
    toVersion: FaithMoonSchemaV2.self
  )
}
