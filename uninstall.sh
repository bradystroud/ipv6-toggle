#!/usr/bin/env bash
# Stop IPv6Toggle, remove the LaunchAgent, and delete the installed app.
set -euo pipefail

APP_NAME="IPv6Toggle"
BUNDLE_ID="com.bradystroud.IPv6Toggle"
APP_PATH="$HOME/Applications/$APP_NAME.app"
PLIST="$HOME/Library/LaunchAgents/$BUNDLE_ID.plist"

launchctl bootout "gui/$(id -u)/$BUNDLE_ID" 2>/dev/null || true
rm -f "$PLIST"
rm -rf "$APP_PATH"
# Kill any lingering instance launched outside launchd.
pkill -f "$APP_NAME" 2>/dev/null || true

echo "Uninstalled $APP_NAME (LaunchAgent removed, app deleted)."
echo "Note: this does not change your current IPv6 setting."
