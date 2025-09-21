//
//  PrayersListView.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 3/31/24.
//  Copyright © 2024 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftData
import SwiftUI

struct PrayersListView: View {
  @Query(animation: .bouncySpring)
  private var prayers: [Prayer]

  @Environment(\.modelContext)
  private var context

  private var sort: [SortDescriptor<Prayer>]

  @State private var viewWidth: CGFloat = 0
  @State private var scales: [Prayer.ID: CGFloat] = [:]
  @State private var setNeedsScaleUpdate = UUID()

  var body: some View {
    ScrollView {
      MasonryLayout(
        columns: columnsCount(basedOn: viewWidth),
        spacing: 12.0
      ) {
        ForEach(prayers) { item in
          BubbleView(
            count: count(for: item.id),
            scale: scales[item.id] ?? 1.0
          ) {
            Label(
              LocalizedStringKey(item.localizationKey),
              systemImage: item.systemImage
            )
            .font(.system(.title3, design: .rounded, weight: .medium))
          }
        }
      }
      .padding()
    }
    .onGeometryChange(for: CGFloat.self, of: \.size.width) { newValue in
      viewWidth = newValue
    }
    .onChange(of: prayers, initial: true) { _, newValue in
      calculateScales(basedOn: newValue)

      do {
        try context.cleanUpDuplicates(in: prayers)
      } catch {
        debugPrint(error)
      }
    }
    .onChange(of: setNeedsScaleUpdate, initial: false) {
      withAnimation(.bouncySpring) {
        calculateScales(basedOn: prayers)
      }
    }
    .onReceive(
      NotificationCenter
        .default
        .publisher(for: .NSPersistentStoreRemoteChange)
        .receive(on: RunLoop.main)
    ) { _ in
      withAnimation(.bouncySpring) {
        calculateScales(basedOn: prayers)
      }
    }
  }

  init(sort: [SortDescriptor<Prayer>]) {
    self.sort = sort
    self._prayers = Query(
      sort: sort,
      animation: .bouncySpring
    )
  }
}

private extension PrayersListView {
  func columnsCount(basedOn width: CGFloat) -> Int {
    let totalScales = Int(scales.values.reduce(0, +).rounded(.down))

    switch width {
    case 0..<250: return 1
    case 250..<375: return 2
    case 375..<750: return min(2, max(9 - totalScales, 2))
    case 750..<1024: return min(3, max(10 - totalScales, 3))
    case 1024..<1500: return min(4, max(11 - totalScales, 4))
    case 1500...: return min(5, max(12 - totalScales, 5))
    default: return 2
    }
  }

  func count(for id: Prayer.ID) -> Binding<Int> {
    Binding {
      prayers.first {
        $0.id == id
      }?.count ?? 0
    } set: { newValue in
      if let index = prayers.firstIndex(where: { $0.id == id }) {
        let prayer = prayers[index]
        let previousCount = prayer.count

        if previousCount != newValue {
          let log = PrayerLog(
            prayerID: prayer.id,
            previousCount: previousCount,
            newCount: newValue
          )
          context.insert(log)
        }

        prayers[index].update(\.count, to: newValue)
        setNeedsScaleUpdate = UUID()
      }
    }
  }

  func calculateScales(basedOn models: [Prayer]) {
    var result: [Prayer.ID: CGFloat] = [:]

    models.forEach {
      result[$0.id] = BubbleColorPalette.scale(for: $0.count)
    }

    if result != scales {
      scales = result
    }
  }
}
