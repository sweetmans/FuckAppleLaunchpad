import SwiftUI
import AppKit
import ServiceManagement
@main

struct FuckAppleLaunchpadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LaunchpadView()
                .ignoresSafeArea()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private let launchAtLoginKey = "launchAtLogin"
    private var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusBar()
        
        // Register for launch at login on first run
        if !UserDefaults.standard.bool(forKey: launchAtLoginKey) {
            setLaunchAtLogin(enabled: true)
            UserDefaults.standard.set(true, forKey: launchAtLoginKey)
        }
        
        // Show menu bar and make window fullscreen
        NSApplication.shared.presentationOptions = []
        
        // Make window fullscreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let window = NSApplication.shared.windows.first {
                window.toggleFullScreen(nil)
            }
        }
    }
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "square.grid.3x3", accessibilityDescription: "Launchpad")
        }
        
        let menu = NSMenu()
        menu.addItem(withTitle: "Open Launchpad", action: #selector(openLaunchpad), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        
        let launchItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchItem.state = UserDefaults.standard.bool(forKey: launchAtLoginKey) ? .on : .off
        menu.addItem(launchItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        statusItem?.menu = menu
    }
    
    @objc private func openLaunchpad() {
        if let window = NSApplication.shared.windows.first {
            window.makeKeyAndOrderFront(nil)
            if !window.styleMask.contains(.fullScreen) {
                window.toggleFullScreen(nil)
            }
        }
    }
    
    @objc private func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        let enabled = sender.state == .off
        setLaunchAtLogin(enabled: enabled)
        sender.state = enabled ? .on : .off
        UserDefaults.standard.set(enabled, forKey: launchAtLoginKey)
    }
    
    private func setLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
                print("Enabled launch at login")
            } else {
                try SMAppService.mainApp.unregister()
                print("Disabled launch at login")
            }
        } catch {
            print("Failed to update launch at login setting: \(error.localizedDescription)")
        }
    }
}
