#!/usr/bin/env bash
# Repository bootstrap for a Cursor cloud agent. Installs Swift when the
# image does not already have it, then checks the pinned XCFramework.
set -euo pipefail

cd "$(dirname "$0")/.."

bash scripts/install-swift.sh
bash scripts/verify-xcframework.sh
