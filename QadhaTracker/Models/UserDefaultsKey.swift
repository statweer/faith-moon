import Foundation

enum UserDefaultsKey {
	case data
	case sortType

	var value: String {
		switch self {
		case .data:
			return "data".reverseDNSFormat
		case .sortType:
			return "sorttype".reverseDNSFormat
		}
	}
}
