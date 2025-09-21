import SwiftUI

enum BubbleViewConstants {
  static let minHeight: CGFloat = isRunningOnWatch ? 90 : 120
  static let maxHeight: CGFloat = isRunningOnWatch ? 180 : 320

  static var ratio: CGFloat {
    maxHeight / minHeight
  }
}

struct BubbleView<Content: View>: View {
  @Binding var count: Int
  var scale: CGFloat?
  var label: () -> Content

  @State private var isShowingStepper = false

  private var effectiveScale: CGFloat {
    scale ?? BubbleColorPalette.scale(for: count)
  }

  private var bubbleColor: Color {
    BubbleColorPalette.color(for: count)
  }

  var body: some View {
    Button {
      isShowingStepper = true
    } label: {
      RoundedRectangle(
        cornerRadius: 16.0,
        style: .continuous
      )
      .fill(bubbleColor.gradient)
      .shadow(color: .black.opacity(0.3), radius: 2)
      .frame(height: BubbleViewConstants.minHeight * effectiveScale)
      .overlay(alignment: .topTrailing) {
        RoundedRectangle(cornerRadius: 16.0, style: .continuous)
          .strokeBorder(.white, lineWidth: 3)
          .frame(width: 46, height: 46)
          .overlay {
            Text(count, format: .number)
              .frame(width: 30, height: 30)
              .font(.system(size: 22, weight: .bold, design: .monospaced))
              .foregroundStyle(.white)
              .minimumScaleFactor(0.5)
              .environment(\.locale, Locale(identifier: "en_US"))
          }
          .shadow(color: .black.opacity(0.4), radius: 0.6)
          .compositingGroup()
          .shadow(color: .black, radius: 16)
      }
      .overlay(alignment: .bottomLeading) {
        label()
          .padding(8)
          .foregroundStyle(.white)
          .shadow(color: .black.opacity(0.5), radius: 8)
      }
      .compositingGroup()
    }
    .preferredSelectionSensoryFeedback(trigger: isShowingStepper)
    .buttonStyle(.plain)
    .buttonBorderShape(.roundedRectangle(radius: 16))
    .preferredContentShape()
    .preferredPopover(isPresented: $isShowingStepper) {
      PrayerCountEditorView(value: $count) {
        label()
          .foregroundStyle(.primary)
      }
      .padding()
      .frame(maxHeight: .infinity, alignment: .top)
    }
  }
}

private struct BubblePreview: View {
  @State private var count = 0

  var body: some View {
    BubbleView(
      count: $count
    ) {
      Label("Maghrib", systemImage: "sunrise")
        .padding(12)
        .font(.system(.title3, design: .rounded, weight: .medium))
        .shadow(color: .black.opacity(0.5), radius: 8)
        .foregroundStyle(.white)
    }
  }
}

#Preview {
  BubblePreview()
}


private extension View {
  @ViewBuilder
  func preferredContentShape() -> some View {
    let shape = RoundedRectangle(
      cornerRadius: 16.0,
      style: .continuous
    )

    #if os(iOS) || os(visionOS)
    self
      .contentShape(.interaction, shape)
      .contentShape(.hoverEffect, shape)
      .hoverEffect(.lift)
    #else
    self
      .contentShape(.interaction, shape)
    #endif
  }

  func preferredPopover<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content: View {
    #if os(iOS) || os(visionOS)
    self.popover(isPresented: isPresented) {
      content()
        .presentationCompactAdaptation(.popover)
    }
    #else
    self.sheet(isPresented: isPresented, content: content)
    #endif
  }
}
