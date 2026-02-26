//
//  FaithMoonApp.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 4/16/23.
//

import AppIntents
import SwiftData
import SwiftUI

@main
struct FaithMoonApp: App {
  private let keyValueStore = KeyValueStore()
  private let modelContainer: ModelContainer

  /// Returns the appropriate locale based on app language.
  /// If Persian (fa), uses fa_IR with Persian calendar and numerals. Otherwise uses device locale.
  private var appLocale: Locale {
    let languageCode = Locale.current.language.languageCode?.identifier
    return languageCode == "fa"
      ? Locale(identifier: "fa_IR@calendar=persian;numbers=arabext")
      : .current
  }

  private var appCalendar: Calendar {
    appLocale.calendar
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(keyValueStore)
        .modelContainer(modelContainer)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
      .if(isRunningOnVision) {
        $0.frame(
          minWidth: 400,
          maxWidth: .infinity,
          minHeight: 400,
          maxHeight: .infinity
        )
      }
    }
    .environment(\.locale, appLocale)
    .environment(\.calendar, appCalendar)
    #if os(visionOS)
    .windowResizability(.contentSize)
    #endif
  }

  init() {
    modelContainer = DataController.shared.modelContainer
    setUpNavigationBarAppearance()
    FaithMoonShortcuts.updateAppShortcutParameters()
  }
}

private extension FaithMoonApp {
  func setUpNavigationBarAppearance() {
    #if os(iOS) || os(visionOS)

    let design = UIFontDescriptor.SystemDesign.rounded

    guard let titleDesc = UIFontDescriptor
      .preferredFontDescriptor(withTextStyle: .headline)
      .withDesign(design)?
      .addingAttributes(
        [.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]]
      ) else {
      return
    }

    guard let largeTitle = UIFontDescriptor
      .preferredFontDescriptor(withTextStyle: .largeTitle)
      .withDesign(design)?
      .addingAttributes(
        [.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]]
      ) else {
      return
    }

    let largeFont = UIFont(descriptor: largeTitle, size: 34)
    let smallFont = UIFont(descriptor: titleDesc, size: 17)

    let appearance = UINavigationBarAppearance()
    appearance.configureWithDefaultBackground()
    appearance.largeTitleTextAttributes = [.font: largeFont]
    appearance.titleTextAttributes = [.font: smallFont]

    let clearAppearance = UINavigationBarAppearance()
    clearAppearance.configureWithTransparentBackground()
    clearAppearance.largeTitleTextAttributes = [.font: largeFont]
    clearAppearance.titleTextAttributes = [.font: smallFont]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = clearAppearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().compactScrollEdgeAppearance = appearance

    #endif
  }
}
