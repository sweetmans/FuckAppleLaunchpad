import SwiftUI
import AppKit
@main

struct FuckAppleLaunchpadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LaunchpadView()
                .frame(minWidth: NSScreen.main?.visibleFrame.width ?? 1280, minHeight: NSScreen.main?.visibleFrame.height ?? 800) // Minimum size for readability
        }
        .defaultSize(width: NSScreen.main?.visibleFrame.width ?? 1280, height: NSScreen.main?.visibleFrame.height ?? 800)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.presentationOptions = [.autoHideMenuBar]
    }
}
