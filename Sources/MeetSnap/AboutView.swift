import SwiftUI

struct AboutView: View {
    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        VStack(spacing: 14) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 80, height: 80)

            Text("MeetSnap")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Version \(version) (\(build))")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("One-click access to your active Google Meet tab, right from the menu bar.")
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            HStack(spacing: 16) {
                Link("GitHub", destination: URL(string: "https://github.com/DaoDaoNoCode/MeetSnap")!)
                Text("·").foregroundColor(.secondary)
                Text("Made by Juntao Wang")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
        }
        .padding(28)
        .frame(width: 320)
    }
}
