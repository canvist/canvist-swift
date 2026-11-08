// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "Canvist",
  platforms: [.iOS(.v17)],
  products: [.library(name: "Canvist", targets: ["Canvist"])],
  targets: [
    .binaryTarget(
      name: "CanvistFFI",
      url: "https://github.com/canvist/canvist/releases/download/apple%2Fv0.2.1/CanvistFFI.xcframework.zip",
      checksum: "dfb6555a1c30e22b48ab87cf50dfcdd39d615692a22d6582de65b98a1f29a417"
    ),
    .target(name: "Canvist", dependencies: ["CanvistFFI"]),
  ]
)
