//
//  FaithMoonMigrationPlan.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftData
import Foundation

// MARK: - V1 Schema (Original with prayerName)
enum FaithMoonSchemaV1: VersionedSchema {
  static let versionIdentifier = Schema.Version(1, 0, 0)

  static var models: [any PersistentModel.Type] {
    [PrayerLog.self, Prayer.self]
  }

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

// MARK: - V2 Schema (Current with prayerID instead of prayerName)
enum FaithMoonSchemaV2: VersionedSchema {
  static let versionIdentifier = Schema.Version(2, 0, 0)

  static var models: [any PersistentModel.Type] {
    [PrayerLog.self, Prayer.self]
  }

  @Model
  final class PrayerLog {
    var id = UUID()
    @Attribute(originalName: "prayerName")
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

    func updateCount(to newCount: Int) {
      count = newCount
      lastModified = .now
    }

    var isEmpty: Bool {
      count == 0 // swiftlint:disable:this empty_count
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

  // Lightweight migration - just renames the property
  static let migrateV1toV2 = MigrationStage.lightweight(
    fromVersion: FaithMoonSchemaV1.self,
    toVersion: FaithMoonSchemaV2.self
  )
}
