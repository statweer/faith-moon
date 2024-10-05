import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static let defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
  }
}
