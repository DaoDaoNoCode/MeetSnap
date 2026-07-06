import Cocoa
import SwiftUI

class OnboardingWindowController {
    private var window: NSWindow?

    private static let hasSeenKey = "hasSeenOnboarding"

    static var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: hasSeenKey)
    }

    func show(onDismiss: @escaping () -> Void) {
        let view = OnboardingView { [weak self] in
            UserDefaults.standard.set(true, forKey: OnboardingWindowController.hasSeenKey)
            self?.window?.close()
            self?.window = nil
            onDismiss()
        }

        let hostingView = NSHostingView(rootView: view)
        let window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentView = hostingView
        window.title = "MeetSnap"
        window.isReleasedWhenClosed = false
        window.level = .floating
        window.center()

        self.window = window
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }
}
