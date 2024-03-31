import Foundation

extension String {
  var reverseDNSFormat: String {
    "\(mainBundleID).\(self)"
  }
}
