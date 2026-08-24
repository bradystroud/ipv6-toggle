import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    var timer: Timer!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        menu = NSMenu()
        
        statusItem.menu = menu
        
        updateStatus()
        
        // Periodically check status just in case it changes externally
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateStatus), userInfo: nil, repeats: true)
    }
    
    @objc func updateStatus() {
        let task = Process()
        task.launchPath = "/usr/sbin/networksetup"
        task.arguments = ["-getinfo", "Wi-Fi"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            let isOff = output.contains("IPv6: Off")
            
            DispatchQueue.main.async {
                if let button = self.statusItem.button {
                    button.title = isOff ? "IPv6: OFF" : "IPv6: ON"
                }
                
                self.menu.removeAllItems()
                let toggleItem = NSMenuItem(title: isOff ? "Turn IPv6 On (Automatic)" : "Turn IPv6 Off", action: #selector(self.toggleIPv6), keyEquivalent: "")
                toggleItem.target = self
                self.menu.addItem(toggleItem)
                self.menu.addItem(NSMenuItem.separator())
                
                let quitItem = NSMenuItem(title: "Quit", action: #selector(self.quit), keyEquivalent: "q")
                quitItem.target = self
                self.menu.addItem(quitItem)
            }
        }
    }
    
    @objc func toggleIPv6() {
        let task = Process()
        task.launchPath = "/usr/sbin/networksetup"
        task.arguments = ["-getinfo", "Wi-Fi"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return }

        let isOff = output.contains("IPv6: Off")
        // These two argument vectors must stay byte-for-byte identical to the entries in
        // /etc/sudoers.d/ipv6-toggle. sudo matches the full command line, so any change
        // here (a different interface name, an extra flag) silently stops matching and
        // the app falls back to prompting for a password.
        let command = ["/usr/sbin/networksetup", isOff ? "-setv6automatic" : "-setv6off", "Wi-Fi"]

        if !runWithSudoNoPrompt(command) {
            runWithAdminPrompt(command)
        }

        // Update UI immediately after toggling
        updateStatus()
    }

    /// Runs the command via `sudo -n`, which never prompts: it succeeds only if a sudoers
    /// rule grants this exact command NOPASSWD. Returns false when no such rule exists,
    /// so the caller can fall back to the interactive prompt.
    private func runWithSudoNoPrompt(_ command: [String]) -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
        task.arguments = ["-n"] + command
        task.standardOutput = FileHandle.nullDevice
        task.standardError = FileHandle.nullDevice
        do {
            try task.run()
            task.waitUntilExit()
            return task.terminationStatus == 0
        } catch {
            return false
        }
    }

    private func runWithAdminPrompt(_ command: [String]) {
        let scriptSource = "do shell script \"\(command.joined(separator: " "))\" with administrator privileges"
        if let script = NSAppleScript(source: scriptSource) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
            if let err = error {
                print("Error: \(err)")
            }
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()