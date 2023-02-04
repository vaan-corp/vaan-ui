//
// Created by Imthathullah on 04/02/23.
//

import SwiftUI

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
