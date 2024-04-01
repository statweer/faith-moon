//
//  DataController.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 3/31/24.
//  Copyright © 2024 Saeed Tatweer IT Services Est. All rights reserved.
//

import CoreData
import Foundation
import SwiftData

@MainActor
final class DataController {
  private(set) lazy var modelContainer: ModelContainer = {
    let schema = Schema([Prayer.self])
    let modelConfiguration = ModelConfiguration(
      "qadha-prayers",
      schema: schema,
      isStoredInMemoryOnly: false
    )

    do {
      try createApplicationSupportDirectory()

      let container = try ModelContainer(
        for: schema,
        configurations: modelConfiguration
      )

      container.insertAppDefaultData()

      return container
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  private(set) lazy var previewContainer: ModelContainer = {
    do {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try ModelContainer(for: Prayer.self, configurations: config)

      container.insertAppDefaultData()

      return container
    } catch {
      fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
  }()

  private func createApplicationSupportDirectory() throws {
    if let url = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: appGroupIdentifier
    ) {
      let appSupport = url.appending(path: "Library/Application Support")

      if !FileManager.default.fileExists(atPath: appSupport.path) {
        try FileManager.default.createDirectory(
          at: appSupport,
          withIntermediateDirectories: true
        )
      }
    }
  }
}

extension ModelContainer {
  @MainActor
  func insertAppDefaultData() {
    let fetchDescriptor = FetchDescriptor<Prayer>()

    do {
      guard try mainContext.fetchCount(fetchDescriptor) == 0 else {
        return
      }

      for value in Prayer.defaultValues {
        mainContext.insert(value)
      }
    } catch {
      debugPrint("Failed to insert default data.")
    }
  }
}

extension ModelContext {
  func cleanUpDuplicates(in prayers: [Prayer]) throws {
    if prayers.count == Prayer.defaultValues.count {
      return
    }

    var uniqueItems: [Prayer.ID: Prayer] = [:]

    for item in prayers {
      if let existingItem = uniqueItems[item.id] {
        if let itemLastModified = item.lastModified {
          let existingLastModified = existingItem.lastModified ?? .distantPast

          if itemLastModified > existingLastModified {
            uniqueItems[item.id] = item
          }
        }
      } else {
        uniqueItems[item.id] = item
      }
    }

    let prayersToRemove = Set(prayers).subtracting(uniqueItems.values)

    for prayer in prayersToRemove {
      delete(prayer)
    }

    if hasChanges {
      try save()
    }
  }
}
