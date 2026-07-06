// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MeetSnap",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "MeetSnap",
            path: "Sources/MeetSnap"
        )
    ]
)
