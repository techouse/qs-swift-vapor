// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "QsSwiftVapor",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "QsSwiftVapor",
      targets: ["QsSwiftVapor"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/techouse/qs-swift.git", from: "1.4.0"),
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.6"),
    .package(url: "https://github.com/vapor/vapor.git", from: "4.121.2")
  ],
  targets: [
    .target(
      name: "QsSwiftVapor",
      dependencies: [
        .product(name: "QsSwift", package: "qs-swift"),
        .product(name: "Vapor", package: "vapor")
      ],
      path: "Sources/QsSwiftVapor"
    ),
    .testTarget(
      name: "QsSwiftVaporTests",
      dependencies: [
        "QsSwiftVapor",
        .product(name: "QsSwift", package: "qs-swift"),
        .product(name: "XCTVapor", package: "vapor")
      ],
      path: "Tests/QsSwiftVaporTests"
    )
  ]
)
