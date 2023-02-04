//
// Created by Imthathullah on 04/02/23.
//

import SwiftUI

#if canImport(UIKit)
public extension UIApplication {
  func openSettings() async {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    await open(url, options: [:])
  }
}
#endif

public extension AnyTransition {
  /// View slides in the opposite direction to system slide transition
  /// Slides in from the trailing side and slides out to the leading side
  static var slideFromTrailing: AnyTransition {
    .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
  }
}

public extension View {
  /// Preferable for instant tasks wrapped in Async API.
  /// Do not use this for long running tasks which need to be cancelled on disappear.
  func taskOnAppear(_ task: @escaping () async -> Void) -> some View {
    onAppear {
      Task {
        await task()
      }
    }
  }
}

extension Text: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(verbatim: value)
  }
}

extension Color: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value)
  }
}

extension String: View {
  public var body: some View {
    Text(verbatim: self)
  }
}
