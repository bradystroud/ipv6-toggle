# IPv6 Toggle

A simple macOS menu bar app to quickly toggle IPv6 on and off for the Wi-Fi interface. 

Useful for when certain VPNs or networks have issues with IPv6 and you need to quickly disable it without digging through System Settings.

## Usage
The app sits in your menu bar and shows the current status (`IPv6: ON` or `IPv6: OFF`). Clicking the menu item allows you to toggle the state. 

*Note: Toggling the network settings requires administrator privileges, so macOS will prompt you for your password or Touch ID when changing the state.*

## Building
You can run or build the Swift script using the Swift compiler:
```bash
swiftc main.swift -o IPv6Toggle
```

<img width="894" height="531" alt="image" src="https://github.com/user-attachments/assets/53176a4c-04b7-4b83-9eb0-3bb7162a450c" />

