//
//  Prayer+SystemImage.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 9/15/25.
//  Copyright © 2025 Saeed Tatweer IT Services Est. All rights reserved.
//

import Foundation

extension Prayer {
  static func systemImage(for prayerName: String) -> String {
    switch prayerName {
    case "Fajr": "sunrise"
    case "Dhuhr": "sun.max"
    case "Asr": "sun.dust"
    case "Maghrib": "sunset"
    case "Isha": "moon"
    case "Ayat": "tropicalstorm"
    case "Ramadan Fast": "sparkles"
    default: "laurel.leading"
    }
  }
}
