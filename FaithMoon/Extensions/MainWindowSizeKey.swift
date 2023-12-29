//
//  MainWindowSizeKey.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 8/6/23.
//  Copyright © 2023 Saeed Tatweer IT Services Est. All rights reserved.
//

import SwiftUI

private struct MainWindowSizeKey: EnvironmentKey {
  static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
  var mainWindowSize: CGSize {
    get { self[MainWindowSizeKey.self] }
    set { self[MainWindowSizeKey.self] = newValue }
  }
}
