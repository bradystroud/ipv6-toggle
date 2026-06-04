#!/usr/bin/env bash
# Build IPv6Toggle.app from main.swift.
# Usage: ./build.sh [output-app-path]
#   Default output: ./IPv6Toggle.app (next to this script)
set -euo pipefail

APP_NAME="IPv6Toggle"
BUNDLE_ID="com.bradystroud.IPv6Toggle"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_PATH="${1:-$SCRIPT_DIR/$APP_NAME.app}"

MACOS_DIR="$APP_PATH/Contents/MacOS"
mkdir -p "$MACOS_DIR"

echo "Compiling $APP_NAME..."
swiftc "$SCRIPT_DIR/main.swift" -o "$MACOS_DIR/$APP_NAME"

cat > "$APP_PATH/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

echo "Built $APP_PATH"
