//
//  Prayer+SystemImage.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 9/15/25.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import Foundation

extension Prayer {
  static func systemImage(for prayerID: String) -> String {
    switch prayerID.lowercased() {
    case "fajr": "sunrise"
    case "duhr", "dhuhr": "sun.max"
    case "asr": "sun.dust"
    case "maghrib": "sunset"
    case "isha": "moon"
    case "ayat": "tropicalstorm"
    case "ramadan-fast", "ramadan fast": "sparkles"
    default: "laurel.leading"
    }
  }
}
