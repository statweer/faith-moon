//
//  FaithMoonApp.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 4/16/23.
//

import SwiftData
import SwiftUI

@main
struct FaithMoonApp: App {
  private let keyValueStore = KeyValueStore()
  private let modelContainer: ModelContainer

  var body: some Scene {
    WindowGroup {
      GeometryReader { proxy in
        ContentView()
          .environment(keyValueStore)
          .modelContainer(modelContainer)
          .environment(\.mainWindowSize, proxy.size)
      }
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
    #if os(visionOS)
    .windowResizability(.contentSize)
    #endif
  }

  init() {
    modelContainer = DataController().modelContainer
    setUpNavigationBarAppearance()
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
