import Cocoa

enum PermissionChecker {
    static func showPermissionDeniedAlert() {
        let alert = NSAlert()
        alert.messageText = "MeetSnap Needs Automation Permission"
        alert.informativeText = "MeetSnap needs permission to communicate with Google Chrome to find your Meet tabs.\n\nPlease go to System Settings > Privacy & Security > Automation, find MeetSnap, and enable Google Chrome."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Settings")
        alert.addButton(withTitle: "Later")

        NSApp.activate(ignoringOtherApps: true)
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
