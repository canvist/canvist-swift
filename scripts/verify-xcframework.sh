#!/usr/bin/env bash
# Download the XCFramework pinned in Package.swift and check its sha256.
# Linux cannot link this iOS binary; the check proves the URL and checksum
# still match.
set -euo pipefail

cd "$(dirname "$0")/.."

url="$(sed -n 's/^[[:space:]]*url: "\(.*\)".*/\1/p' Package.swift)"
checksum="$(sed -n 's/^[[:space:]]*checksum: "\(.*\)".*/\1/p' Package.swift)"

if [ -z "$url" ] || [ -z "$checksum" ]; then
  echo "Package.swift is missing the XCFramework url or checksum" >&2
  exit 1
fi

cache="${TMPDIR:-/tmp}/canvist-ffi-${checksum}.zip"

if [ ! -f "$cache" ]; then
  tmp="$(mktemp)"
  curl -fsSL "$url" -o "$tmp"
  echo "${checksum}  ${tmp}" | sha256sum -c -
  mv "$tmp" "$cache"
fi

echo "${checksum}  ${cache}" | sha256sum -c -
echo "XCFramework checksum matches Package.swift"
