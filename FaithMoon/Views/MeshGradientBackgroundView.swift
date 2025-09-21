import SwiftUI

struct MeshGradientBackgroundView: View {
  @Environment(\.colorScheme)
  private var colorScheme

  var body: some View {
    TimelineView(.animation) { context in
      let time = context.date.timeIntervalSince1970
      let offsetX = Float(sin(time)) * 0.1
      let offsetY = Float(cos(time)) * 0.1

      MeshGradient(
        width: 4,
        height: 4,
        points: [
          [0.0, 0.0],
          [0.3, 0.0],
          [0.7, 0.0],
          [1.0, 0.0],
          [0.0, 0.3],
          [0.2 + offsetX, 0.4 + offsetY],
          [0.7 + offsetX, 0.2 + offsetY],
          [1.0, 0.3],
          [0.0, 0.7],
          [0.3 + offsetX, 0.8],
          [0.7 + offsetX, 0.6],
          [1.0, 0.7],
          [0.0, 1.0],
          [0.3, 1.0],
          [0.7, 1.0],
          [1.0, 1.0]
        ],
        colors: animatedColors(for: colorScheme)
      )
    }
  }

  private func animatedColors(for colorScheme: ColorScheme) -> [Color] {
    if colorScheme == .dark {
      return [
        .gray.opacity(0.117), .gray.opacity(0.09), .gray.opacity(0.117), .gray.opacity(0.076),
        .gray.opacity(0.09), .gray.opacity(0.135), .gray.opacity(0.09), .gray.opacity(0.076),
        .gray.opacity(0.117), .gray.opacity(0.09), .gray.opacity(0.076), .gray.opacity(0.117),
        .gray.opacity(0.076), .gray.opacity(0.117), .gray.opacity(0.09), .gray.opacity(0.117)
      ]
    } else {
      return [
        .purple.opacity(0.09), .indigo.opacity(0.076), .purple.opacity(0.09), .yellow.opacity(0.063),
        .pink.opacity(0.076), .purple.opacity(0.09), .pink.opacity(0.076), .yellow.opacity(0.063),
        .orange.opacity(0.063), .pink.opacity(0.076), .yellow.opacity(0.063), .orange.opacity(0.063),
        .yellow.opacity(0.063), .orange.opacity(0.063), .pink.opacity(0.076), .purple.opacity(0.09)
      ]
    }
  }
}

#Preview("Light Mode") {
  MeshGradientBackgroundView()
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
  MeshGradientBackgroundView()
    .preferredColorScheme(.dark)
}
