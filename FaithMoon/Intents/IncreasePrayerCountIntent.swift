//
//  IncreasePrayerCountIntent.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import AppIntents
import SwiftData
import SwiftUI

struct IncreasePrayerCountIntent: AppIntent {
  static let title: LocalizedStringResource = "Increase Qadha"
  static let description = IntentDescription("Add missed prayers to your qadha count")
  static let openAppWhenRun: Bool = false

  @Parameter(title: "Prayer", description: "The prayer to increase")
  var prayer: PrayerEntity

  @Parameter(
    title: "Increase By",
    description: "The amount to increase by",
    default: 1,
    inclusiveRange: (1, 100)
  )
  var increaseBy: Int

  static var parameterSummary: some ParameterSummary {
    Summary("Increase \(\.$prayer) by \(\.$increaseBy)")
  }

  @MainActor
  func perform() async throws -> some IntentResult & ReturnsValue<Int> & ProvidesDialog & ShowsSnippetView {
    guard let prayerModel = DataController.shared.fetchPrayer(withID: prayer.id) else {
      return .result(
        value: 0,
        dialog: IntentDialog("Could not find the prayer")
      )
    }

    let previousCount = prayerModel.count
    let newCount = previousCount + increaseBy

    prayerModel.updateCount(to: newCount)

    do {
      let context = DataController.shared.modelContainer.mainContext
      if context.hasChanges {
        try context.save()

        let log = PrayerLog(
          prayerID: prayerModel.id,
          changedAmount: increaseBy,
          changeDate: .now
        )
        context.insert(log)
        try context.save()
      }

      let prayerName = String(localized: String.LocalizationValue(prayerModel.localizationKey))
      let message = String(localized: "\(prayerName) increased by \(increaseBy). Total: \(newCount)")

      let prayerIcon = prayerModel.systemImage

      return .result(
        value: newCount,
        dialog: IntentDialog(stringLiteral: message),
        view: SimpleBubbleView(
          prayerName: prayerName,
          prayerIcon: prayerIcon,
          count: newCount
        )
      )
    } catch {
      return .result(
        value: previousCount,
        dialog: IntentDialog("Failed to increase prayer count")
      )
    }
  }
}
