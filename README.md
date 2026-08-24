# IPv6 Toggle

A simple macOS menu bar app to quickly toggle IPv6 on and off for the Wi-Fi interface. 

Useful for when certain VPNs or networks have issues with IPv6 and you need to quickly disable it without digging through System Settings.

## Usage
The app sits in your menu bar and shows the current status (`IPv6: ON` or `IPv6: OFF`). Clicking the menu item allows you to toggle the state. 

*Note: Toggling the network settings requires administrator privileges, so by default macOS prompts you for your password or Touch ID on every change. See [Skipping the password prompt](#skipping-the-password-prompt) to get rid of that.*

<img width="894" height="531" alt="image" src="https://github.com/user-attachments/assets/53176a4c-04b7-4b83-9eb0-3bb7162a450c" />

## Install (with auto-start at login)
This builds the app, installs it to `~/Applications`, and registers a LaunchAgent so it
launches automatically every time you log in (and starts it right away):
```bash
./install.sh
```
To remove it (LaunchAgent + app), run:
```bash
./uninstall.sh
```
Uninstalling does not change your current IPv6 setting.

## Skipping the password prompt
By default every toggle asks for authentication. To make it instant, install a sudoers rule
that whitelists just the two commands this app runs:
```bash
./install-sudoers.sh
```
You'll be asked for your password once, during install. After that the app calls
`sudo -n` and switches silently.

The rule is deliberately narrow — sudo matches the entire command line, so it covers
exactly `networksetup -setv6off Wi-Fi` and `networksetup -setv6automatic Wi-Fi` and nothing
else. No wildcards, no blanket `networksetup` access. If the rule is missing the app falls
back to the normal password prompt, so it still works either way.

To revoke it:
```bash
sudo rm /etc/sudoers.d/ipv6-toggle
```
(`./uninstall.sh` removes it too.)

## Building only
To just build `IPv6Toggle.app` without setting up auto-start:
```bash
./build.sh
```
This produces `IPv6Toggle.app` next to the script, which you can run with `open IPv6Toggle.app`.
