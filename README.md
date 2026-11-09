# Canvist for Apple platforms

Generated from canvist/canvist at 90e609903a349bb3b4247f0f8762d645b5fae1ba. Requires iOS 17 and Swift 6.

```swift
.package(url: "https://github.com/canvist/canvist-swift.git", exact: "0.2.1")
```

Add the `Canvist` product to your app target. This package includes the Swift
bindings and downloads a checksum-verified XCFramework (iOS and arm64 simulator).

## Linux and cloud agents

The package targets iOS 17. `swift build` and the UIKit XCTest suite need
macOS and Xcode; a Linux machine cannot link the XCFramework.

```sh
bash scripts/cloud-agent-install.sh    # Swift 6.2.4 if needed, then the XCFramework checksum
swiftc -parse Sources/Canvist/*.swift  # syntax check
bash scripts/lint.sh                   # swift-format on the hand-written sources
bash scripts/linux-check.sh            # checksum, parse, lint, and Linux tests when Checks/ exists
```

`linux-check.sh` runs `swift test` in `Checks/` when that package is present.
Those tests cover logic that does not need UIKit. The view and editor tests
stay on macOS, in the canvist repository.
