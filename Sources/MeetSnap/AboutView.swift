import SwiftUI

struct AboutView: View {
    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 64, height: 64)

            Text("MeetSnap")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Version \(version) (\(build))")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("One-click access to your Google Meet tab.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .frame(width: 280)
    }
}
