#!/usr/bin/env bash
# What a Linux cloud agent can check. The iOS target needs macOS and Xcode.
set -euo pipefail

cd "$(dirname "$0")/.."

bash scripts/verify-xcframework.sh
swiftc -parse Sources/Canvist/*.swift
bash scripts/lint.sh

if [ -f Checks/Package.swift ]; then
  swift test --package-path Checks
else
  echo "No Checks package in this revision; the UIKit XCTest suite needs macOS."
fi
