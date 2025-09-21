//
//  GetAllPrayerCountsIntent.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import AppIntents
import SwiftData
import SwiftUI

struct GetAllPrayerCountsIntent: AppIntent {
  static let title: LocalizedStringResource = "Get All Prayer Counts"
  static let description = IntentDescription("Get the current count of all qadha prayers")
  static let openAppWhenRun: Bool = false

  static var parameterSummary: some ParameterSummary {
    Summary("Get all qadha prayer counts")
  }

  @MainActor
  func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
    let prayers = DataController.shared.fetchPrayers()

    if prayers.isEmpty {
      return .result(dialog: IntentDialog("No prayers found"))
    }

    let nonZeroPrayers = prayers.filter { !$0.isEmpty }

    if nonZeroPrayers.isEmpty {
      return .result(dialog: IntentDialog("You have no qadha prayers to make up"))
    }

    let prayerData = nonZeroPrayers.map { prayer in
      let name = String(localized: String.LocalizationValue(prayer.localizationKey))
      return (name: name, icon: prayer.systemImage, count: prayer.count)
    }

    let summaryLines = nonZeroPrayers.map { prayer in
      let name = String(localized: String.LocalizationValue(prayer.localizationKey))
      return String(localized: "\(name): \(prayer.count)")
    }

    let totalCount = nonZeroPrayers.reduce(0) { $0 + $1.count }

    let formatter = ListFormatter()
    formatter.locale = Locale.current
    let summary = formatter.string(from: summaryLines) ?? summaryLines.joined(separator: ", ")

    return .result(
      dialog: IntentDialog(stringLiteral: String(localized: "\(summary). Total: \(totalCount) prayers")),
      view: PrayerGridView(items: prayerData)
    )
  }
}
