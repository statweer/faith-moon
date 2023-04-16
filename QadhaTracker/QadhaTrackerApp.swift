//
//  QadhaTrackerApp.swift
//  QadhaTracker
//
//  Created by Saeed Taheri on 4/16/23.
//

import SwiftUI

@main
struct QadhaTrackerApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.tint(Color("AccentColor"))
				.dynamicTypeSize(...DynamicTypeSize.accessibility1)
			#if targetEnvironment(macCatalyst)
				.withHostingWindow { window in
					if let titlebar = window?.windowScene?.titlebar {
						titlebar.titleVisibility = .hidden
						titlebar.toolbar = nil
					}
				}
			#endif
		}
	}

	init() {
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
	}
}
