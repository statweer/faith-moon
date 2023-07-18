import Foundation

struct PrayerModel {
  let id: UUID
  let localizationKey: String
  let intrinsicOrder: Int
  var count: Int

  init(
    id: UUID = UUID(),
    localizationKey: String,
    intrinsicOrder: Int
  ) {
    self.id = id
    self.localizationKey = localizationKey
    self.intrinsicOrder = intrinsicOrder
    self.count = 0
  }
}

extension PrayerModel {
  var systemImage: String {
    switch localizationKey {
    case "Fajr": return "sunrise"
    case "Dhuhr": return "sun.max"
    case "Asr": return "sun.dust"
    case "Maghrib": return "sunset"
    case "Isha": return "moon"
    case "Ayat": return "tropicalstorm"
    case "Ramadan Fast": return "sparkles"
    default: return "laurel.leading"
    }
  }
}

extension PrayerModel: Identifiable, Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(localizationKey)
    hasher.combine(intrinsicOrder)
  }
}

extension PrayerModel: Codable {
}

// MARK: - App Data
extension PrayerModel {
  static var defaultValues: [PrayerModel] {
    [
      .init(
        localizationKey: "Fajr",
        intrinsicOrder: 0
      ),
      .init(
        localizationKey: "Dhuhr",
        intrinsicOrder: 1
      ),
      .init(
        localizationKey: "Asr",
        intrinsicOrder: 3
      ),
      .init(
        localizationKey: "Maghrib",
        intrinsicOrder: 4
      ),
      .init(
        localizationKey: "Isha",
        intrinsicOrder: 5
      ),
      .init(
        localizationKey: "Ayat",
        intrinsicOrder: 6
      ),
      .init(
        localizationKey: "Ramadan Fast",
        intrinsicOrder: 7
      )
    ]
  }
}

extension UUID: Identifiable {
  public var id: Self {
    self
  }
}
