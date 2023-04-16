import Foundation

struct PrayerModel {
	let id: UUID
	let localizationKey: String
	let systemImage: String
	let intrinsicOrder: Int
	var count: Int

	init(
		id: UUID = UUID(),
		localizationKey: String,
		systemImage: String,
		intrinsicOrder: Int
	) {
		self.id = id
		self.localizationKey = localizationKey
		self.systemImage = systemImage
		self.intrinsicOrder = intrinsicOrder
		self.count = 0
	}
}

extension PrayerModel: Identifiable, Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(localizationKey)
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
				systemImage: "sunrise",
				intrinsicOrder: 0
			),
			.init(
				localizationKey: "Dhuhr",
				systemImage: "sun.max",
				intrinsicOrder: 1
			),
			.init(
				localizationKey: "Asr",
				systemImage: "sun.dust",
				intrinsicOrder: 2
			),
			.init(
				localizationKey: "Maghrib",
				systemImage: "sunset",
				intrinsicOrder: 3
			),
			.init(
				localizationKey: "Isha",
				systemImage: "moon",
				intrinsicOrder: 4
			),
			.init(
				localizationKey: "Fast",
				systemImage: "sparkles",
				intrinsicOrder: 5
			)
		]
	}
}

extension UUID: Identifiable {
	public var id: Self {
		self
	}
}
