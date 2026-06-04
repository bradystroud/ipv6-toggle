# IPv6 Toggle

A simple macOS menu bar app to quickly toggle IPv6 on and off for the Wi-Fi interface. 

Useful for when certain VPNs or networks have issues with IPv6 and you need to quickly disable it without digging through System Settings.

## Usage
The app sits in your menu bar and shows the current status (`IPv6: ON` or `IPv6: OFF`). Clicking the menu item allows you to toggle the state. 

*Note: Toggling the network settings requires administrator privileges, so macOS will prompt you for your password or Touch ID when changing the state.*

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

## Building only
To just build `IPv6Toggle.app` without setting up auto-start:
```bash
./build.sh
```
This produces `IPv6Toggle.app` next to the script, which you can run with `open IPv6Toggle.app`.
