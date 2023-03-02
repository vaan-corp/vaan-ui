//
// Created by Imthathullah on 25/02/23.
//

import SwiftUI

public struct ProgressBar: View {
  @Binding var value: Float
  let background: Color
  let tint: Color

  public init(value: Binding<Float>, background: Color = .accentColor.opacity(0.5), tint: Color = .accentColor) {
    self._value = value
    self.background = background
    self.tint = tint
  }

  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Capsule().frame(width: geometry.size.width , height: geometry.size.height)
          .opacity(0.3)
          .foregroundColor(background)

        Capsule().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
          .foregroundColor(tint)
          .animation(.linear, value: value)
      }
    }
  }
}

public struct LineLoadingIndicator: View {
  let height: CGFloat
  let color: Color
  let background: Color

  public init(
    height: CGFloat = 2,
    color: Color = .accentColor,
    background: Color = .accentColor.opacity(0.3)
  ) {
    self.height = height
    self.color = color
    self.background = background
  }

  @State var xPosition: CGFloat = .zero

  public var body: some View {
    GeometryReader { proxy in
      ZStack {
        Rectangle()
          .fill(background)
        LinearGradient(stops: [
          .init(color: .clear, location: 0),
          .init(color: color, location: 0.48),
          .init(color: color, location: 0.52),
          .init(color: .clear, location: 1),
        ], startPoint: .init(x: 0, y: 0), endPoint: .trailing)
          .position(x: xPosition, y: height * 0.5)
      }
        .frame(height: height)
        .onAppear {
          xPosition = -(proxy.size.width * 0.25)
          withAnimation(.easeIn(duration: 1.5).repeatForever(autoreverses: true)) {
            xPosition = proxy.size.width * 1.25
          }
        }
    }
      .frame(height: height)
  }
}
