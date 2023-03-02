//
// Created by Imthathullah on 04/02/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct InfoButtonStyle: ButtonStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.footnote)
      .underline()
      .foregroundColor(configuration.isPressed ? .secondary.opacity(0.6) : .secondary)
  }
}

public struct CardButtonStyle: ButtonStyle {
  let backgroundColor: Color
  let textColor: Color
  let height: CGFloat

  public init(backgroundColor: Color = .accentColor,
              textColor: Color = .white,
              height: CGFloat = 44) {
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    self.height = height
  }

  public func makeBody(configuration: Configuration) -> some View {
    ZStack {
      bgColor(for: configuration).cornerRadius(8)
      configuration.label
        .foregroundColor(self.fgColor(for: configuration))
    }
    .frame(height: height)
  }

  func fgColor(for configuration: Configuration) -> Color {
    configuration.isPressed ? textColor.opacity(0.6) : textColor
  }

  func bgColor(for configuration: Configuration) -> Color {
    configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor
  }
}

public struct CustomToggleStyle: ToggleStyle {
  let colors: Colors

  public init(colors: Colors) {
    self.colors = colors
  }

  public func makeBody(configuration: Configuration) -> some View {
    GeometryReader { bounds in
      ZStack(alignment: configuration.isOn ? .trailing : .leading) {
        Capsule()
          .fill(configuration.isOn ? colors.onBackground : colors.offBackground)
        Circle()
          .fill(configuration.isOn ? colors.onForeground : colors.offForeground)
          .padding(bounds.size.height * 0.15)
      }
        .onTapGesture {
          configuration.isOn.toggle()
        }
    }
  }
}

extension CustomToggleStyle {
  public struct Colors {
    let onBackground: Color
    let offBackground: Color
    let onForeground: Color
    let offForeground: Color

    public init(
      onBackground: Color,
      offBackground: Color,
      onForeground: Color,
      offForeground: Color
    ) {
      self.onBackground = onBackground
      self.offBackground = offBackground
      self.onForeground = onForeground
      self.offForeground = offForeground
    }
  }
}
