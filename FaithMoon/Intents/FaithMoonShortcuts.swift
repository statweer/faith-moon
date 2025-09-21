//
//  FaithMoonShortcuts.swift
//  FaithMoon
//
//  Created by Saeed Taheri.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import AppIntents
import Foundation

struct FaithMoonShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: GetAllPrayerCountsIntent(),
      phrases: [
        "Check my prayers in \(.applicationName)",
        "Show prayer counts in \(.applicationName)",
        "What are my qadha prayers in \(.applicationName)"
      ],
      shortTitle: "Check All Prayers",
      systemImageName: "list.bullet"
    )

    AppShortcut(
      intent: IncreasePrayerCountIntent(),
      phrases: [
        "Log missed \(\.$prayer) in \(.applicationName)",
        "I missed \(\.$prayer) in \(.applicationName)",
        "Add \(\.$prayer) qadha in \(.applicationName)"
      ],
      shortTitle: "Log Missed Prayer",
      systemImageName: "plus"
    )

    AppShortcut(
      intent: DecreasePrayerCountIntent(),
      phrases: [
        "I prayed \(\.$prayer) qadha in \(.applicationName)",
        "Mark \(\.$prayer) complete in \(.applicationName)",
        "Completed \(\.$prayer) in \(.applicationName)"
      ],
      shortTitle: "Mark Prayer Complete",
      systemImageName: "minus"
    )
  }

  static let shortcutTileColor: ShortcutTileColor = .lime
}
