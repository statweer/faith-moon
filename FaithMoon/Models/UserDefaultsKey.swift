import Foundation

enum UserDefaultsKey: String {
  case keyValueStoreTimestamp
  case sortType

  var value: String {
    rawValue.reverseDNSFormat
  }
}
