#!/usr/bin/env bash
# Install the Swift 6.2.4 toolchain when `swift` is not already on PATH.
# Idempotent. Safe to run as root (image build) or as ubuntu with sudo.
set -euo pipefail

if command -v swift >/dev/null 2>&1; then
  swift --version
  exit 0
fi

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

export DEBIAN_FRONTEND=noninteractive
$SUDO apt-get update
$SUDO apt-get install -y --no-install-recommends \
  binutils \
  ca-certificates \
  curl \
  gnupg2 \
  libc6-dev \
  libcurl4-openssl-dev \
  libedit2 \
  libgcc-13-dev \
  libncurses-dev \
  libpython3-dev \
  libsqlite3-0 \
  libstdc++-13-dev \
  libxml2-dev \
  libz3-dev \
  pkg-config \
  tzdata \
  unzip \
  zlib1g-dev

SWIFT_VERSION="swift-6.2.4-RELEASE"
SWIFT_BRANCH="swift-6.2.4-release"
SWIFT_PLATFORM="ubuntu24.04"
SWIFT_WEBROOT="https://download.swift.org"
# Swift 6.x Release Signing Key <swift-infrastructure@forums.swift.org>
SWIFT_SIGNING_KEY="52BB7E3DE28A71BE22EC05FFEF80A866B47A981F"

arch="$(dpkg --print-architecture)"
case "$arch" in
  amd64) suffix="" ;;
  arm64) suffix="-aarch64" ;;
  *)
    echo "unsupported architecture: $arch" >&2
    exit 1
    ;;
esac

platform_dir="${SWIFT_PLATFORM//./}$suffix"
tarball="$SWIFT_VERSION-$SWIFT_PLATFORM$suffix.tar.gz"
url="$SWIFT_WEBROOT/$SWIFT_BRANCH/$platform_dir/$SWIFT_VERSION/$tarball"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

curl -fsSL "$url" -o "$workdir/swift.tar.gz"
curl -fsSL "$url.sig" -o "$workdir/swift.tar.gz.sig"

GNUPGHOME="$(mktemp -d)"
export GNUPGHOME
gpg --batch --quiet --keyserver keyserver.ubuntu.com --recv-keys "$SWIFT_SIGNING_KEY"
gpg --batch --verify "$workdir/swift.tar.gz.sig" "$workdir/swift.tar.gz"
rm -rf "$GNUPGHOME"

$SUDO tar -xzf "$workdir/swift.tar.gz" --directory / --strip-components=1
$SUDO chmod -R o+r /usr/lib/swift

hash -r
swift --version
