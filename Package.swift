// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "Canvist",
  platforms: [.iOS(.v17)],
  products: [.library(name: "Canvist", targets: ["Canvist"])],
  targets: [
    .binaryTarget(
      name: "CanvistFFI",
      url: "https://github.com/canvist/canvist/releases/download/apple%2Fv0.2.0/CanvistFFI.xcframework.zip",
      checksum: "e4d0c178d67ec0d61b1ab1995a0336034f14df0f158b1d77246ec6325e234428"
    ),
    .target(name: "Canvist", dependencies: ["CanvistFFI"]),
  ]
)
