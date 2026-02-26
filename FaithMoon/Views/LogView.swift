//
//  LogView.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 9/15/25.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftData
import SwiftUI

// MARK: - Aggregation

struct AggregatedLog: Identifiable {
  let id: UUID
  let logs: [PrayerLog]
  var prayerID: String
  var totalChangeAmount: Int
  var previousCount: Int
  var newCount: Int
  var displayDate: Date

  var formattedChangeAmount: String {
    if totalChangeAmount > 0 {
      return "+\(totalChangeAmount)"
    } else {
      return "\(totalChangeAmount)"
    }
  }

  var isIncrease: Bool {
    totalChangeAmount > 0
  }

  var isDecrease: Bool {
    totalChangeAmount < 0
  }
}

private func groupingWindow(for date: Date) -> TimeInterval {
  let age = Date.now.timeIntervalSince(date)
  if age < 86_400 { return 60 }
  if age < 604_800 { return 3_600 }
  return 86_400
}

func aggregateLogs(_ logs: [PrayerLog]) -> [AggregatedLog] {
  guard let first = logs.first else { return [] }

  var result: [AggregatedLog] = []
  var currentGroup: [PrayerLog] = [first]

  for log in logs.dropFirst() {
    guard let prev = currentGroup.last else { continue }
    let window = groupingWindow(for: log.changeDate)
    let timeDelta = abs(prev.changeDate.timeIntervalSince(log.changeDate))

    if log.prayerID == prev.prayerID && timeDelta <= window {
      currentGroup.append(log)
    } else {
      result.append(makeAggregated(from: currentGroup))
      currentGroup = [log]
    }
  }

  result.append(makeAggregated(from: currentGroup))
  return result
}

private func makeAggregated(from group: [PrayerLog]) -> AggregatedLog {
  let chronological = Array(group.reversed())
  let mostRecent = group[0]

  return AggregatedLog(
    id: mostRecent.id,
    logs: group,
    prayerID: mostRecent.prayerID,
    totalChangeAmount: group.reduce(0) { $0 + $1.changeAmount },
    previousCount: chronological[0].previousCount,
    newCount: chronological[chronological.count - 1].newCount,
    displayDate: mostRecent.changeDate
  )
}

// MARK: - LogView

struct LogView: View {
  @Query(sort: \PrayerLog.changeDate, order: .reverse)
  private var logs: [PrayerLog]

  @Environment(\.modelContext)
  private var context

  @State private var showingClearConfirmation = false
  @State private var aggregatedLogs: [AggregatedLog] = []

  var body: some View {
    Group {
      if logs.isEmpty {
        ContentUnavailableView(
          "No History",
          systemImage: "clock",
          description: Text("Prayer changes will appear here")
        )
      } else {
        List {
          ForEach(aggregatedLogs) { entry in
            LogRowView(entry: entry)
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  deleteLogs(entry.logs)
                } label: {
                  Label("Delete", systemImage: "trash")
                }
                .tint(.red)
              }
              #if os(iOS) || os(visionOS)
              .contextMenu {
                Button(role: .destructive) {
                  deleteLogs(entry.logs)
                } label: {
                  Label("Delete Entry", systemImage: "trash")
                }
              }
              #endif
          }
        }
      }
    }
    .onAppear {
      aggregatedLogs = aggregateLogs(logs)
    }
    .onChange(of: logs) {
      aggregatedLogs = aggregateLogs(logs)
    }
    .navigationTitle("History")
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      if !logs.isEmpty {
        ToolbarItem(placement: .primaryAction) {
          Button("Clear All") {
            showingClearConfirmation = true
          }
          .confirmationDialog(
            "Clear History",
            isPresented: $showingClearConfirmation,
            titleVisibility: .visible
          ) {
            Button("Clear All", role: .destructive) {
              clearAllLogs()
            }
            Button("Cancel", role: .cancel) {}
          } message: {
            Text("This will permanently delete all history entries. This action cannot be undone.")
          }
        }
      }
    }
  }

  private func deleteLogs(_ logsToDelete: [PrayerLog]) {
    for log in logsToDelete {
      context.delete(log)
    }
  }

  private func clearAllLogs() {
    for log in logs {
      context.delete(log)
    }
  }
}

struct LogRowView: View {
  let entry: AggregatedLog

  @Environment(\.locale) private var locale
  @Environment(\.calendar) private var calendar

  @ScaledMetric(relativeTo: .headline)
  private var imageSize: CGFloat = 24

  private var prayer: Prayer? {
    DataController.shared.fetchPrayer(withID: entry.prayerID)
  }

  private var prayerLocalizationKey: String {
    prayer?.localizationKey ?? ""
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        HStack(spacing: imageSize / 3.0) {
          Image(systemName: Prayer.systemImage(for: entry.prayerID))
            .resizable()
            .scaledToFit()
            .frame(width: imageSize, height: imageSize)

          Text(LocalizedStringKey(prayerLocalizationKey))
            #if os(iOS) || os(visionOS)
            .alignmentGuide(.listRowSeparatorLeading) { dimen in
              dimen[.leading]
            }
            #endif
        }
        .font(.system(.headline, design: .rounded, weight: .medium))

        Spacer()

        Text(entry.formattedChangeAmount)
          .font(.system(.body, design: .monospaced, weight: .semibold))
          .foregroundStyle(entry.isIncrease ? .red : (entry.isDecrease ? .green : .secondary))
      }

      HStack {
        Text("\(entry.previousCount) → \(entry.newCount)")
          .environment(\.locale, Locale(identifier: "en_US"))
          .font(.system(.subheadline, design: .monospaced))
          .foregroundStyle(.secondary)
          .padding(.leading, imageSize * 4.0 / 3.0)

        Spacer()

        Text(entry.displayDate.formatted(.intelligent(locale: locale, calendar: calendar)))
          .font(.caption)
          .foregroundStyle(.tertiary)
      }
    }
  }
}

#Preview {
  NavigationStack {
    LogView()
      .modelContainer(DataController().previewContainer)
  }
}
