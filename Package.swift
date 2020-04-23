// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "TreeUI",
  platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
  products: [
    .library(name: "TreeCore", targets: ["TreeCore"]),
    .library(name: "TreeUI", targets: ["TreeUI"]),
  ],
  targets: [
    .target(name: "TreeCore"),
    .target(name: "TreeUI", dependencies: ["TreeCore"]),
    .testTarget(name: "TreeUITests", dependencies: ["TreeUI"]),
  ]
)
