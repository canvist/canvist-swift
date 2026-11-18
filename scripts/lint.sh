#!/usr/bin/env bash
# swift-format over the hand-written sources. The generated bindings
# (Canvist.swift, Extensions.generated.swift) are produced by uniffi and
# the extension-metadata generator; the parent repo excludes them from lint.
set -euo pipefail

cd "$(dirname "$0")/.."

mapfile -d '' files < <(
  find Sources/Canvist -name '*.swift' \
    ! -name 'Canvist.swift' \
    ! -name 'Extensions.generated.swift' \
    -print0
)

# GitHub-hosted Ubuntu has Swift, but not always `swift-format` on PATH.
# `swift format` is the same tool.
if command -v swift-format >/dev/null 2>&1; then
  swift-format lint --strict "${files[@]}"
else
  swift format lint --strict "${files[@]}"
fi
