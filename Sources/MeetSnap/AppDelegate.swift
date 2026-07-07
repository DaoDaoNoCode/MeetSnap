import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var pollTimer: Timer?
    private var meetingActive = false
    private var onboarding = OnboardingWindowController()
    private var aboutWindow = AboutWindowController()
    private var permissionAlertShown = false

    private static let chromeBundleID = "com.google.Chrome"

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let button = statusItem.button else { return }
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        button.action = #selector(handleClick)

        Icon.setup(button: button)

        let wsnc = NSWorkspace.shared.notificationCenter
        wsnc.addObserver(
            self, selector: #selector(appLaunched(_:)),
            name: NSWorkspace.didLaunchApplicationNotification, object: nil
        )
        wsnc.addObserver(
            self, selector: #selector(appTerminated(_:)),
            name: NSWorkspace.didTerminateApplicationNotification, object: nil
        )

        if OnboardingWindowController.hasSeenOnboarding {
            if isChromeRunning() {
                silentCheck()
                startPolling()
            }
        } else {
            onboarding.show { [weak self] in
                if self?.isChromeRunning() == true {
                    self?.silentCheck()
                    self?.startPolling()
                }
            }
        }
    }

    private func isChromeRunning() -> Bool {
        !NSRunningApplication
            .runningApplications(withBundleIdentifier: Self.chromeBundleID)
            .isEmpty
    }

    @objc private func appLaunched(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              app.bundleIdentifier == Self.chromeBundleID else { return }
        startPolling()
    }

    @objc private func appTerminated(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              app.bundleIdentifier == Self.chromeBundleID else { return }
        stopPolling()
        setMeetingState(false)
    }

    private func silentCheck() {
        MeetSwitcher.hasMeeting { [weak self] result in
            self?.setMeetingState(result == .found)
        }
    }

    private func startPolling() {
        guard pollTimer == nil else { return }
        pollTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.silentCheck()
        }
    }

    private func stopPolling() {
        pollTimer?.invalidate()
        pollTimer = nil
    }

    private func setMeetingState(_ active: Bool) {
        meetingActive = active
        guard let button = statusItem.button else { return }
        if active {
            Icon.setActive(button: button)
        } else {
            Icon.setInactive(button: button)
        }
    }

    private func handlePermissionDenied() {
        guard !permissionAlertShown else { return }
        permissionAlertShown = true
        PermissionChecker.showPermissionDeniedAlert()
    }

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp || !meetingActive {
            showMenu()
        } else {
            MeetSwitcher.bringMeetToFront { [weak self] result in
                if case .permissionDenied = result {
                    self?.handlePermissionDenied()
                }
            }
        }
    }

    private func showMenu() {
        let menu = NSMenu()

        if !meetingActive {
            let noMeeting = NSMenuItem(title: "No active Google Meet", action: nil, keyEquivalent: "")
            noMeeting.isEnabled = false
            menu.addItem(noMeeting)
            menu.addItem(.separator())
        }

        let launchItem = NSMenuItem(
            title: "Launch at Login",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchItem.state = LaunchAtLogin.isEnabled ? .on : .off
        launchItem.target = self
        menu.addItem(launchItem)

        menu.addItem(.separator())
        menu.addItem(
            withTitle: "About MeetSnap",
            action: #selector(showAbout),
            keyEquivalent: ""
        )
        menu.addItem(.separator())
        menu.addItem(
            withTitle: "Quit MeetSnap",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    @objc private func toggleLaunchAtLogin() {
        LaunchAtLogin.toggle()
    }

    @objc private func showAbout() {
        aboutWindow.show()
    }
}
