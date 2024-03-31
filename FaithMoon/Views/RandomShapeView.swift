import SwiftUI
import Combine

struct RandomShapeView: View {
  @Environment(\.mainWindowSize)
  private var windowSize

  @State private var size: CGSize?
  private let sizePublisher = PassthroughSubject<CGSize, Never>()

  @State private var shapeViews: [(AnyView, UUID)] = []

  @Environment(\.colorScheme)
  private var colorScheme

  var body: some View {
    ZStack {
      ForEach(shapeViews, id: \.1) { shapeView in
        shapeView.0
          .blur(radius: 5.0)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .readSize {
      size = $0
    }
    .overlay {
      Color.clear
        .background(blurredBackground())
    }
    .edgesIgnoringSafeArea(.all)
    .onAppear {
      if shapeViews.isEmpty {
        withAnimation {
          calculateShapes(using: size ?? windowSize)
        }
      }
    }
    .onChange(of: size) { oldValue, newValue in
      if oldValue != newValue {
        sizePublisher.send(newValue ?? windowSize)
      }
    }
    .onReceive(
      sizePublisher
        .debounce(
          for: .milliseconds(300),
          scheduler: DispatchQueue.main
        )
    ) { newValue in
      withAnimation {
        calculateShapes(using: newValue)
      }
    }
  }

  private func blurredBackground() -> some ShapeStyle {
    #if os(watchOS)
    .thinMaterial
    #else
    if isiOSAppRunningOnMac {
      return .ultraThickMaterial
    } else {
      return colorScheme == .light ? .regularMaterial : .thickMaterial
    }
    #endif
  }

  private func calculateShapes(using size: CGSize) {
    if size.width == 0.0 || size.height == 0.0 {
      return
    }

    let shapes = [
      Self.createRandomCircle
      //            Self.createRandomRectangle,
      //            Self.createRandomTriangle
    ]
    let colors = RandomShapeView.createRandomColors(count: 5)

    let numberOfShapes = Int(max(size.width, size.height)) / 45

    shapeViews = (0..<numberOfShapes).map { _ in
      let shapeIndex = Int.random(in: 0..<shapes.count)
      let colorIndex = Int.random(in: 0..<colors.count)
      let color = colors[colorIndex]

      let shape = shapes[shapeIndex](size, color)

      return (shape, UUID())
    }
  }

  private static func createRandomCircle(in canvas: CGSize, color: Color) -> AnyView {
    let minDimen = min(canvas.width, canvas.height)
    let size = CGFloat.random(in: (minDimen / 2.0)...minDimen)
    let xValue = CGFloat.random(in: 0...(canvas.width + size / 2.0))
    let yValue = CGFloat.random(in: 0...(canvas.height + size / 2.0))

    return Circle()
      .size(CGSize(width: size, height: size))
      .fill(color)
      .position(x: xValue, y: yValue)
      .erasedToAnyView()
  }

  private static func createRandomRectangle(in canvas: CGSize, color: Color) -> AnyView {
    let size = CGSize(
      width: CGFloat.random(in: (canvas.width / 4.0)...(canvas.width / 2.0)),
      height: CGFloat.random(in: (canvas.height / 4.0)...(canvas.height / 2.0))
    )
    let xValue = CGFloat.random(in: 0...canvas.width)
    let yValue = CGFloat.random(in: 0...canvas.height)
    let angle = Angle(degrees: CGFloat.random(in: 0...360))

    return Rectangle()
      .size(size)
      .fill(color)
      .position(x: xValue, y: yValue)
      .rotationEffect(angle, anchor: .center)
      .erasedToAnyView()
  }

  private static func createRandomTriangle(in canvas: CGSize, color: Color) -> AnyView {
    let size = CGFloat.random(in: (canvas.width / 4.0)...(canvas.width / 2.0))
    let xValue = CGFloat.random(in: 0...canvas.width)
    let yValue = CGFloat.random(in: 0...canvas.height)
    let angle = Angle(degrees: CGFloat.random(in: 0...360))

    let path = Path { path in
      path.move(to: CGPoint(x: xValue, y: yValue))
      path.addLine(to: CGPoint(x: xValue + size, y: yValue))
      path.addLine(to: CGPoint(x: xValue + size / 2, y: yValue + size))
      path.closeSubpath()
    }
    return path
      .fill(color)
      .rotationEffect(angle, anchor: .center)
      .erasedToAnyView()
  }

  private static func createRandomColors(count: Int) -> [Color] {
    var colors: [Color] = []
    for _ in 1...count {
      let red = Double.random(in: 0...1)
      let green = Double.random(in: 0...1)
      let blue = Double.random(in: 0...1)
      let alpha = Double.random(in: 0.6...1)
      let color = Color(red: red, green: green, blue: blue, opacity: alpha)
      colors.append(color)
    }
    return colors
  }
}

#Preview {
  RandomShapeView()
}

private extension View {
  func erasedToAnyView() -> AnyView {
    AnyView(self)
  }
}
