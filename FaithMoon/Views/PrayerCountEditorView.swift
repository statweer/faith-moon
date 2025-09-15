import SwiftUI

struct PrayerCountEditorView<Content: View>: View {
  @Environment(\.dismiss)
  private var dismiss

  @FocusState private var isFocused

  @Binding var value: Int
  var title: () -> Content

  var body: some View {
    VStack(
      alignment: .leading,
      spacing: isRunningOnWatch ? 16 : nil
    ) {
      HStack {
        title()

        Spacer()

        #if os(visionOS)
        Button {
          dismiss()
        } label: {
          Image(
            systemName: isRunningOnVision ? "xmark" : "xmark.circle.fill"
          )
          .imageScale(isRunningOnVision ? .medium : .large)
          .font(.system(.title3, design: .rounded, weight: .medium))
          .tint(.primary.opacity(0.3))
          .frame(
            minWidth: isRunningOnVision ? nil : 44,
            minHeight: isRunningOnVision ? nil : 44
          )
        }
        .buttonBorderShape(.circle)
        .contentShape(.interaction, .rect)
        .contentShape(.hoverEffect, .circle)
        .hoverEffect()
        #endif
      }
      .padding(.trailing, isRunningOnWatch ? nil : -8.0)

      Stepper(
        value: $value.animation(.bouncySpring),
        in: 0...Int.max,
        step: 1
      ) {
        if isRunningOnWatch {
          Text(value, format: .ranged(0...Int.max))
        } else {
          TextField(
            value: $value,
            format: .ranged(0...Int.max),
            prompt: Text("How many Qadha?")
          ) {
            EmptyView()
          }
          .font(.title3.monospaced().bold())
          .preferredTextFieldCharacteristics()
          .onSubmit {
            isFocused = false
          }
        }
      } onEditingChanged: { success in
        if success {
          #if os(iOS)
          UIImpactFeedbackGenerator(style: .light).impactOccurred()
          #endif
        }
      }
      .focused($isFocused)
    }
  }
}

#Preview {
  PrayerCountEditorView(
    value: .constant(10)
  ) {
    Label("Maghrib", systemImage: "sunset")
  }
  .background(Color.teal)
}

struct RangeIntegerStrategy: ParseStrategy {
  private static let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .none
    return formatter
  }()

  func parse(_ value: String) throws -> Int {
    return Self.numberFormatter.number(from: value)?.intValue ?? 0
  }
}

struct RangeIntegerStyle: ParseableFormatStyle {
  var parseStrategy: RangeIntegerStrategy = .init()
  let range: ClosedRange<Int>

  func format(_ value: Int) -> String {
    let constrainedValue = min(max(value, range.lowerBound), range.upperBound)
    return constrainedValue.formatted(.number.locale(Locale(identifier: "en_US")))
  }
}

extension FormatStyle where Self == RangeIntegerStyle {
  static func ranged(_ range: ClosedRange<Int>) -> RangeIntegerStyle {
    return RangeIntegerStyle(range: range)
  }
}

private extension View {
  func preferredTextFieldCharacteristics() -> some View {
    #if os(iOS) || os(visionOS)
    self
      .keyboardType(.asciiCapableNumberPad)
      .textFieldStyle(.roundedBorder)
    #else
    self
    #endif
  }
}
