// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "TinyTree",
  platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
  products: [
    .library(name: "TinyTreeCore", targets: ["TinyTreeCore"]),
    .library(name: "TinyTreeUI", targets: ["TinyTreeUI"]),
  ],
  targets: [
    .target(name: "TinyTreeCore"),
    .target(name: "TinyTreeUI", dependencies: ["TinyTreeCore"]),
    .testTarget(name: "TinyTreeUITests", dependencies: ["TinyTreeUI"]),
  ]
)
