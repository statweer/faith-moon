import SwiftUI

struct PrayerCountEditorView<Content: View>: View {
	@Environment(\.dismiss) private var dismiss
	@FocusState private var isFocused

	@Binding var value: Int
	var title: () -> Content

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				title()
				Spacer()
				Button {
					dismiss()
				} label: {
					Image(systemName: "xmark.circle.fill")
						.imageScale(.large)
						.font(.system(.title3, design: .rounded, weight: .medium))
						.tint(.primary.opacity(0.5))
						.frame(minWidth: 44, minHeight: 44)
						.buttonBorderShape(.automatic)
						.containerShape(Rectangle())
				}
				.contentShape(.hoverEffect, Circle())
				.hoverEffect()
			}
			.padding(.trailing, -8.0)

			Stepper(value: $value.animation(), in: 0...Int.max, step: 1) {
				TextField(
					value: $value,
					format: .ranged(0...Int.max),
					prompt: Text("How many Qadha?")
				) {
					EmptyView()
				}
				.focused($isFocused)
				.keyboardType(.asciiCapableNumberPad)
				.font(.title3.monospaced().bold())
				.textFieldStyle(.roundedBorder)
				.onSubmit {
					isFocused = false
				}
			} onEditingChanged: { success in
				if success {
					UIImpactFeedbackGenerator(style: .light).impactOccurred()
				}
			}
		}
	}
}

struct PrayerCountEditor_Previews: PreviewProvider {
	static var previews: some View {
		PrayerCountEditorView(
			value: .constant(10)
		) {
			Label("Maghrib", systemImage: "sunset")
		}
		.background(Color.teal)
	}
}

struct RangeIntegerStrategy: ParseStrategy {
	func parse(_ value: String) throws -> Int {
		return Int(value) ?? 0
	}
}

struct RangeIntegerStyle: ParseableFormatStyle {
	var parseStrategy: RangeIntegerStrategy = .init()
	let range: ClosedRange<Int>

	func format(_ value: Int) -> String {
		let constrainedValue = min(max(value, range.lowerBound), range.upperBound)
		return "\(constrainedValue)"
	}
}

extension FormatStyle where Self == RangeIntegerStyle {
	static func ranged(_ range: ClosedRange<Int>) -> RangeIntegerStyle {
		return RangeIntegerStyle(range: range)
	}
}
