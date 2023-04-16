import Foundation
import Combine
import SwiftUI

final class DataStore: ObservableObject {
	private enum Defaults {
		static let springAnimation = Animation.spring(
			response: 0.4,
			dampingFraction: 0.6,
			blendDuration: 0.2
		)
	}

	private let userDefaults = UserDefaults.standard

	@Published var data: [PrayerModel]
	@Published var scales: [PrayerModel.ID: CGFloat] = [:]
	@Published var sortType: SortType {
		didSet {
			if sortType != oldValue {
				UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
			}
		}
	}

	@Published private(set) var sortedData: [PrayerModel] = []

	private var cancellables: Set<AnyCancellable> = []

	init() {
		if let sortStr = userDefaults.string(forKey: UserDefaultsKey.sortType.value) {
			sortType = SortType(rawValue: sortStr) ?? .default
		} else {
			sortType = .default
		}

		if let dataStr = userDefaults.string(forKey: UserDefaultsKey.data.value) {
			data = [PrayerModel].decode(using: dataStr) ?? PrayerModel.defaultValues
		} else {
			data = PrayerModel.defaultValues
		}

		sortedData = sort(data, basedOn: sortType)

		scales = calculateScales(basedOn: data)

		$data.sink { [weak self] newValue in
			guard let self else { return }

			userDefaults.set(
				newValue.toJSONString(),
				forKey: UserDefaultsKey.data.value
			)

			withAnimation(Defaults.springAnimation) { [unowned self] in
				self.sortedData = self.sort(self.data, basedOn: self.sortType)
				self.scales = self.calculateScales(basedOn: newValue)
			}
		}
		.store(in: &cancellables)

		$sortType.sink { [weak self] newValue in
			guard let self else { return }

			userDefaults.set(
				newValue.rawValue,
				forKey: UserDefaultsKey.sortType.value
			)

			withAnimation(Defaults.springAnimation) { [unowned self] in
				self.sortedData = self.sort(self.data, basedOn: newValue)
			}
		}
		.store(in: &cancellables)
	}

	private func sort(
		_ models: [PrayerModel],
		basedOn sortType: SortType
	) -> [PrayerModel] {
		return models.sorted {
			switch sortType {
			case .ascending:
				return $0.count < $1.count
			case .descending:
				return $0.count > $1.count
			case .default:
				return $0.intrinsicOrder < $1.intrinsicOrder
			}
		}
	}

	private func calculateScales(basedOn models: [PrayerModel]) -> [PrayerModel.ID: CGFloat] {
		var result: [PrayerModel.ID: CGFloat] = [:]

		models.forEach {
			result[$0.id] = max(1.0, min(CGFloat($0.count) * 0.1 + 1.0, BubbleViewConstants.ratio))
		}

		return result
	}

	func columnsCount(basedOn width: CGFloat) -> Int {
		let totalScales = Int(scales.values.reduce(0, +).rounded(.down))

		switch width {
		case 0..<375: return 2
		case 375..<750: return min(2, max(9 - totalScales, 2))
		case 750..<1024: return min(3, max(10 - totalScales, 3))
		case 1024..<1500: return min(4, max(11 - totalScales, 4))
		case 1500...: return min(5, max(12 - totalScales, 5))
		default: return 2
		}
	}

	func scale(for id: PrayerModel.ID) -> Binding<CGFloat> {
		Binding { [weak self] in
			self?.scales[id] ?? 1.0
		} set: { [weak self] newValue in
			self?.scales[id] = newValue
		}
	}

	func count(for id: PrayerModel.ID) -> Binding<Int> {
		Binding { [weak self] in
			self?.data.first {
				$0.id == id
			}?.count ?? 0
		} set: { [weak self] newValue in
			if let index = self?.data.firstIndex(where: { $0.id == id }) {
				self?.data[index].count = newValue
			}
		}
	}
}
