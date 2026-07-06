import SwiftUI

struct OnboardingView: View {
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 80, height: 80)

            Text("Welcome to MeetSnap")
                .font(.title2)
                .fontWeight(.semibold)

            Text("One-click access to your active Google Meet tab, right from the menu bar.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Label("Click the icon to switch to your Meet tab", systemImage: "cursorarrow.click")
                Label("Filled icon means you have an active meeting", systemImage: "video.fill")
                Label("Right-click for options", systemImage: "ellipsis.circle")
            }
            .font(.callout)

            Divider()

            Text("macOS will ask you to grant Automation permission for Google Chrome. Please allow it so MeetSnap can find your meeting tabs.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Button("Get Started") {
                onDismiss()
            }
            .keyboardShortcut(.defaultAction)
            .controlSize(.large)
        }
        .padding(30)
        .frame(width: 380)
    }
}
