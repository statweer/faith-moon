import Foundation

enum SortType: String, Equatable, Identifiable {
  case ascending
  case descending
  case `default`

  var id: Self {
    self
  }
}
