import Foundation

enum UserDefaultsKey: String {
	case data
	case timestamp
	case sortType

	var value: String {
		rawValue.reverseDNSFormat
	}
}
