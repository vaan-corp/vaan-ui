// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "VaanUI",
  platforms: [
    .iOS(.v15),
    .macOS(.v11),
    .watchOS(.v7),
    .tvOS(.v14)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "VaanUI",
      targets: ["VaanUI"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/vaan-corp/vaan-kit", exact: ("1.0.0")),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "VaanUI",
      dependencies: [
        .product(name: "VaanKit", package: "vaan-kit"),
      ]),
    .testTarget(
      name: "VaanUITests",
      dependencies: ["VaanUI"]),
  ]
)
