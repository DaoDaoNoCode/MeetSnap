import Cocoa

enum MeetCheckResult {
    case found
    case notFound
    case permissionDenied
    case chromeNotRunning
}

enum MeetSwitcher {
    private static let queue = DispatchQueue(label: "com.meetsnap.applescript", qos: .userInitiated)

    private static let checkScript = """
    tell application "Google Chrome"
        repeat with w in windows
            repeat with t in tabs of w
                set tabURL to URL of t
                if tabURL contains "meet.google.com/" then
                    set oldDelims to AppleScript's text item delimiters
                    set AppleScript's text item delimiters to "meet.google.com/"
                    set pathPart to text item 2 of tabURL
                    set AppleScript's text item delimiters to oldDelims
                    if pathPart contains "-" then
                        return "found"
                    end if
                end if
            end repeat
        end repeat
        return "not_found"
    end tell
    """

    private static let switchScript = """
    tell application "Google Chrome"
        repeat with w in windows
            set tabIndex to 0
            repeat with t in tabs of w
                set tabIndex to tabIndex + 1
                set tabURL to URL of t
                if tabURL contains "meet.google.com/" then
                    set oldDelims to AppleScript's text item delimiters
                    set AppleScript's text item delimiters to "meet.google.com/"
                    set pathPart to text item 2 of tabURL
                    set AppleScript's text item delimiters to oldDelims
                    if pathPart contains "-" then
                        set active tab index of w to tabIndex
                        set index of w to 1
                        activate
                        return "found"
                    end if
                end if
            end repeat
        end repeat
        return "not_found"
    end tell
    """

    static func hasMeeting(completion: @escaping (MeetCheckResult) -> Void) {
        queue.async {
            let result = execute(script: checkScript)
            DispatchQueue.main.async { completion(result) }
        }
    }

    static func bringMeetToFront(completion: @escaping (MeetCheckResult) -> Void) {
        queue.async {
            let result = execute(script: switchScript)
            DispatchQueue.main.async { completion(result) }
        }
    }

    private static func execute(script: String) -> MeetCheckResult {
        let isRunning = !NSRunningApplication
            .runningApplications(withBundleIdentifier: "com.google.Chrome")
            .isEmpty
        guard isRunning else { return .chromeNotRunning }

        var error: NSDictionary?
        let result = NSAppleScript(source: script)?.executeAndReturnError(&error)

        if let error = error,
           let errorNumber = error[NSAppleScript.errorNumber] as? Int,
           errorNumber == -1743 {
            return .permissionDenied
        }

        return result?.stringValue == "found" ? .found : .notFound
    }
}
