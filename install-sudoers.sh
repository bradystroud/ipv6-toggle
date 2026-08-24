#!/usr/bin/env bash
# Grant the current user password-free sudo for the two IPv6 toggle commands only,
# so IPv6Toggle.app stops prompting on every flip.
# Run this normally (not with sudo) — it asks for your password once, here.
set -euo pipefail

SUDOERS_FILE="/etc/sudoers.d/ipv6-toggle"
USER_NAME="$(id -un)"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat > "$TMP" <<EOF
# Installed by ipv6-toggle/install-sudoers.sh
# Scoped to two exact command lines with no wildcards: sudo matches the whole
# argument vector, so this grants nothing beyond flipping IPv6 on the Wi-Fi
# service. Remove with: sudo rm $SUDOERS_FILE
$USER_NAME ALL=(root) NOPASSWD: /usr/sbin/networksetup -setv6off Wi-Fi, /usr/sbin/networksetup -setv6automatic Wi-Fi
EOF
chmod 0440 "$TMP"

echo "Validating sudoers syntax (you may be asked for your password)..."
if ! sudo visudo -c -f "$TMP" >/dev/null; then
    echo "Refusing to install: generated sudoers file failed validation." >&2
    exit 1
fi

sudo install -m 0440 -o root -g wheel "$TMP" "$SUDOERS_FILE"

# Re-check the whole sudoers set, not just our fragment, before trusting it.
sudo visudo -c >/dev/null

echo "Installed $SUDOERS_FILE for user '$USER_NAME'."
echo "IPv6Toggle will now switch without prompting."
