import Foundation

extension String {
	var reverseDNSFormat: String {
		guard let identifier = Bundle.main.bundleIdentifier else {
			return self
		}
		return "\(identifier).\(self)"
	}
}
