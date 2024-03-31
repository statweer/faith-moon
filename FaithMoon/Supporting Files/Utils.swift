//
//  Utils.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 3/30/24.
//  Copyright © 2024 Saeed Tatweer IT Services Est. All rights reserved.
//

import Foundation

var isRunningOnWatch: Bool {
#if os(watchOS)
  return true
#else
  return false
#endif
}

var isRunningOnVision: Bool {
#if os(visionOS)
  return true
#else
  return false
#endif
}

var isiOS: Bool {
#if os(iOS)
  return true
#else
  return false
#endif
}

var isiOSAppRunningOnMac: Bool {
  ProcessInfo.processInfo.isiOSAppOnMac
}

let mainBundleID = "com.statweer.faithmoon"

var appGroupIdentifier: String {
  "group.\(mainBundleID)"
}

var cloudKitContainer: String {
  "iCloud.\(mainBundleID)"
}
