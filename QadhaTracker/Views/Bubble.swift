import SwiftUI

enum BubbleViewConstants {
	static let minHeight: CGFloat = 120
	static let maxHeight: CGFloat = 360

	static var ratio: CGFloat {
		maxHeight / minHeight
	}
}

struct BubbleView<Content: View>: View {
	private let colorPalette: [Color] = [
		.green,
		.green.interpolate(to: .yellow, at: 0.2),
		.green.interpolate(to: .yellow, at: 0.4),
		.green.interpolate(to: .yellow, at: 0.6),
		.green.interpolate(to: .yellow, at: 0.8),
		.yellow,
		.yellow.interpolate(to: .orange, at: 0.2),
		.yellow.interpolate(to: .orange, at: 0.4),
		.yellow.interpolate(to: .orange, at: 0.6),
		.yellow.interpolate(to: .orange, at: 0.8),
		.orange,
		.orange.interpolate(to: .red, at: 0.2),
		.orange.interpolate(to: .red, at: 0.4),
		.orange.interpolate(to: .red, at: 0.6),
		.orange.interpolate(to: .red, at: 0.8),
		.red
	]

	@Binding var scale: CGFloat
	@Binding var count: Int
	var label: () -> Content

	@State private var isShowingStepper = false

	var body: some View {
		Button {
			UIImpactFeedbackGenerator(style: .medium).impactOccurred()
			isShowingStepper = true
		} label: {
			RoundedRectangle(
				cornerRadius: 16.0,
				style: .continuous
			)
			.fill(colorForScale().gradient)
			.shadow(color: colorForScale(), radius: 2 * scale)
			.frame(height: BubbleViewConstants.minHeight * scale)
			.overlay(alignment: .topTrailing) {
				RoundedRectangle(cornerRadius: 16.0, style: .continuous)
					.strokeBorder(.white, lineWidth: 3)
					.frame(width: 46, height: 46)
					.overlay {
						Text(count, format: .number)
							.frame(width: 30, height: 30)
							.font(.system(size: 22, weight: .bold, design: .monospaced))
							.foregroundColor(.white)
							.minimumScaleFactor(0.5)
							.environment(\.locale, Locale(identifier: "en_US"))
					}
					.shadow(color: .black.opacity(0.5), radius: 10)
			}
			.overlay(alignment: .bottomLeading) {
				label()
					.padding(8)
					.foregroundColor(.white)
					.shadow(color: .black.opacity(0.5), radius: 8)
			}
		}
		.buttonStyle(.borderless)
		.contentShape(
			.hoverEffect,
			RoundedRectangle(
				cornerRadius: 16.0,
				style: .continuous
			)
		)
		.hoverEffect(.lift)
		.popover(isPresented: $isShowingStepper) {
			VStack {
				PrayerCountEditorView(value: $count) {
					label()
						.foregroundColor(.primary)
				}
				Spacer()
			}
			.padding()
			.presentationDetents([.fraction(0.2)])
			.presentationCornerRadius(20)
			.presentationDragIndicator(.visible)
			.presentationBackgroundInteraction(.enabled)
			.presentationBackground(.thickMaterial)
			.presentationCompactAdaptation(.sheet)
		}
	}

	private func colorForScale() -> Color {
		let fraction = (scale - 1.0) / (BubbleViewConstants.ratio - 1.0)
		let index = min(Int(fraction * CGFloat(colorPalette.count)), colorPalette.count - 1)
		return colorPalette[index]
	}
}

private struct BubblePreview: View {
	@State private var scale: CGFloat = 1.0
	@State private var count = 0

	var body: some View {
		BubbleView(
			scale: $scale,
			count: $count
		) {
			Label("مغرب", systemImage: "sunrise")
				.padding(12)
				.font(.system(.title3, design: .rounded, weight: .medium))
				.shadow(color: .black.opacity(0.5), radius: 8)
				.foregroundColor(.white)
		}
	}
}

struct Bubble_Previews: PreviewProvider {
	static var previews: some View {
		BubblePreview()
	}
}

extension Color {
	func interpolate(to color: Color, at fraction: Double) -> Color {
		var fromHue: CGFloat = 0
		var fromSaturation: CGFloat = 0
		var fromBrightness: CGFloat = 0
		var fromOpacity: CGFloat = 0
		var toHue: CGFloat = 0
		var toSaturation: CGFloat = 0
		var toBrightness: CGFloat = 0
		var toOpacity: CGFloat = 0

		UIColor(self).getHue(&fromHue, saturation: &fromSaturation, brightness: &fromBrightness, alpha: &fromOpacity)
		UIColor(color).getHue(&toHue, saturation: &toSaturation, brightness: &toBrightness, alpha: &toOpacity)

		let hue = fromHue + CGFloat(fraction) * (toHue - fromHue)
		let saturation = fromSaturation + CGFloat(fraction) * (toSaturation - fromSaturation)
		let brightness = fromBrightness + CGFloat(fraction) * (toBrightness - fromBrightness)
		let opacity = fromOpacity + CGFloat(fraction) * (toOpacity - fromOpacity)

		return Color(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity))
	}
}
