#!/usr/bin/env bash
# Build IPv6Toggle, install it to ~/Applications, and set it to launch at login.
set -euo pipefail

APP_NAME="IPv6Toggle"
BUNDLE_ID="com.bradystroud.IPv6Toggle"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/Applications"
APP_PATH="$INSTALL_DIR/$APP_NAME.app"
PLIST="$HOME/Library/LaunchAgents/$BUNDLE_ID.plist"

mkdir -p "$INSTALL_DIR"
"$SCRIPT_DIR/build.sh" "$APP_PATH"

echo "Installing LaunchAgent..."
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$BUNDLE_ID</string>
    <key>ProgramArguments</key>
    <array>
        <string>$APP_PATH/Contents/MacOS/$APP_NAME</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

# Reload cleanly (ignore error if it wasn't loaded yet), then start it now.
launchctl bootout "gui/$(id -u)/$BUNDLE_ID" 2>/dev/null || true

# bootout returns before launchd has finished tearing the service down, and bootstrapping
# a label that is still unloading fails with "Input/output error". Wait for it to go.
for _ in $(seq 1 50); do
    launchctl print "gui/$(id -u)/$BUNDLE_ID" >/dev/null 2>&1 || break
    sleep 0.1
done

launchctl bootstrap "gui/$(id -u)" "$PLIST"

echo "Done. $APP_NAME is running now and will start automatically at login."
echo "Look for \"IPv6: ON/OFF\" in your menu bar."
