// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "CanvistChecks",
  targets: [
    .target(name: "GraphemeSpan"),
    .testTarget(name: "GraphemeSpanTests", dependencies: ["GraphemeSpan"]),
  ]
)
