# Canvist for Apple platforms

This repository distributes Canvist through Swift Package Manager. Source development lives in [canvist/canvist](https://github.com/canvist/canvist).

The first SDK release has not shipped yet. Its protected publish workflow will commit the complete Swift bindings and a checksum-pinned binary target here, then tag the package with the SDK version. No release package is available from this repository until that happens.

After publication, add this repository's URL in Xcode and choose the SDK version:

```swift
.package(url: "https://github.com/canvist/canvist-swift.git", exact: "0.2.0")
```

Requires iOS 17 or later. The binary includes iOS devices and arm64 simulators.
