//
// Created by Imthathullah on 14/02/23.
//

import SwiftUI

public protocol ImageRepresentable {
  var value: Image { get }
  var data: Data? { get }
}

#if canImport(UIKit)
extension UIImage: ImageRepresentable {
  public var data: Data? { pngData() }
  public var value: Image { Image(uiImage: self) }
}
#elseif canImport(AppKit)
extension NSImage: ImageRepresentable {
  public var value: Image { Image(nsImage: self) }
  public var data: Data? { tiffRepresentation }
}
#endif

public extension Data {
  var imageRepresentation: ImageRepresentable? {
    #if canImport(UIKit)
    return UIImage(data: self)
    #elseif canImport(AppKit)
    return NSImage(data: self)
    #endif
  }
}

public extension String {
  var imageRepresentation: ImageRepresentable {
    #if canImport(UIKit)
    return UIImage(named: self)!
    #elseif canImport(AppKit)
    return NSImage(named: self)!
    #endif
  }
}