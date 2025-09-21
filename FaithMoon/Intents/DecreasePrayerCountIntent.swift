//
//  DecreasePrayerCountIntent.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import AppIntents
import SwiftData
import SwiftUI

struct DecreasePrayerCountIntent: AppIntent {
  static let title: LocalizedStringResource = "Decrease Qadha"
  static let description = IntentDescription("Mark qadha prayers as completed")
  static let openAppWhenRun: Bool = false

  @Parameter(title: "Prayer", description: "The prayer to decrease")
  var prayer: PrayerEntity

  @Parameter(
    title: "Decrease By",
    description: "The amount to decrease by",
    default: 1,
    inclusiveRange: (1, 100)
  )
  var decreaseBy: Int

  static var parameterSummary: some ParameterSummary {
    Summary("Decrease \(\.$prayer) by \(\.$decreaseBy)")
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
    let newCount = max(0, previousCount - decreaseBy)
    let actualDecrease = previousCount - newCount

    if actualDecrease == 0 {
      return .result(
        value: previousCount,
        dialog: IntentDialog(stringLiteral: String(localized: "\(String(localized: String.LocalizationValue(prayerModel.localizationKey))) is already at 0"))
      )
    }

    prayerModel.updateCount(to: newCount)

    do {
      let context = DataController.shared.modelContainer.mainContext
      if context.hasChanges {
        try context.save()

        let log = PrayerLog(
          prayerID: prayerModel.id,
          changedAmount: -actualDecrease,
          changeDate: .now
        )
        context.insert(log)
        try context.save()
      }

      let prayerName = String(localized: String.LocalizationValue(prayerModel.localizationKey))
      let message = String(localized: "\(prayerName) decreased by \(actualDecrease). Total: \(newCount)")

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
        dialog: IntentDialog("Failed to decrease prayer count")
      )
    }
  }
}
