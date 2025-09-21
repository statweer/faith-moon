//
//  LogView.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 9/15/25.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftData
import SwiftUI

struct LogView: View {
  @Query(sort: \PrayerLog.changeDate, order: .reverse)
  private var logs: [PrayerLog]

  @Environment(\.modelContext)
  private var context

  @State private var showingClearConfirmation = false

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
          ForEach(logs) { log in
            LogRowView(log: log)
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  deleteLog(log)
                } label: {
                  Label("Delete", systemImage: "trash")
                }
                .tint(.red)
              }
              #if os(iOS) || os(visionOS)
              .contextMenu {
                Button(role: .destructive) {
                  deleteLog(log)
                } label: {
                  Label("Delete Entry", systemImage: "trash")
                }
              }
              #endif
          }
        }
      }
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

  private func deleteLog(_ log: PrayerLog) {
    context.delete(log)
  }

  private func deleteLogs(at offsets: IndexSet) {
    for index in offsets {
      context.delete(logs[index])
    }
  }

  private func clearAllLogs() {
    for log in logs {
      context.delete(log)
    }
  }
}

struct LogRowView: View {
  let log: PrayerLog

  @ScaledMetric(relativeTo: .headline)
  private var imageSize: CGFloat = 24

  private var prayer: Prayer? {
    DataController.shared.fetchPrayer(withID: log.prayerID)
  }

  private var prayerLocalizationKey: String {
    prayer?.localizationKey ?? ""
  }

  private var prayerID: String {
    log.prayerID
  }

  var body: some View {
    TimelineView(.animation(minimumInterval: 10)) { timeline in
      VStack(alignment: .leading) {
        HStack {
          HStack(spacing: imageSize / 3.0) {
            Image(systemName: Prayer.systemImage(for: prayerID))
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


          Text(log.formattedChangeAmount)
            .font(.system(.body, design: .monospaced, weight: .semibold))
            .foregroundStyle(log.isIncrease ? .red : (log.isDecrease ? .green : .secondary))
        }

        HStack {
          Text("\(log.previousCount) → \(log.newCount)")
            .font(.system(.subheadline, design: .monospaced))
            .foregroundStyle(.secondary)
            .padding(.leading, imageSize * 4.0 / 3.0)

          Spacer()

          Text(
            log.changeDate.formatted(
              .intelligent(relativeTo: timeline.date)
            )
          )
          .font(.caption)
          .foregroundStyle(.tertiary)
          .contentTransition(.numericText())
        }
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
