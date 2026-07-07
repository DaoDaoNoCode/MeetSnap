<p align="center">
  <img src="icon_256.png" width="128" height="128" alt="MeetSnap icon">
</p>

<h1 align="center">MeetSnap</h1>

<p align="center">
  <strong>One-click access to your active Google Meet tab.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13%2B-blue" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9-orange" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

---

You're multitasking during a Google Meet call. Someone says your name. It takes you 10 seconds to find the right Chrome tab.

MeetSnap sits in your menu bar and brings your meeting back to the front with a single click — from any app, any desktop.

## Features

- **At-a-glance status** — faint icon means no meeting, solid icon means you're in one
- **Click to switch** — click the solid icon to instantly focus your active Meet tab
- **Near-instant detection** — updates immediately when you switch to or from Chrome, with a 15s background poll as backup
- **Lightweight** — ~5MB memory, zero CPU when Chrome isn't running
- **Launch at Login** — enable from the dropdown menu

## Install

### Build from Source (Recommended)

```bash
git clone https://github.com/DaoDaoNoCode/MeetSnap.git
cd MeetSnap
bash build.sh
cp -R MeetSnap.app /Applications/
```

Requires Xcode Command Line Tools (`xcode-select --install`). Works with any recent Swift version.

### Homebrew

```
brew tap daodaonocode/tap
brew trust daodaonocode/tap
brew install meetsnap
```

Then copy to Applications (shown in post-install caveats):

```
cp -R $(brew --prefix)/Cellar/meetsnap/1.0/MeetSnap.app /Applications/
```

> **Note:** Homebrew requires your Xcode version to match your macOS version. If you see an "Xcode is too outdated" error, use the Build from Source method above instead — it's more forgiving.

## Usage

| State | Icon | Click |
|---|---|---|
| **No meeting** | Faint outlined camera+G | Opens menu: "No active Google Meet" |
| **Meeting active** | Solid filled camera+G with return arrow | Switches to your Meet tab |

Right-click always opens the menu (Launch at Login, About, Quit).

## Permissions

On first launch, macOS will ask you to grant Automation permission for Google Chrome. This allows MeetSnap to find and switch to your Meet tab.

If you accidentally deny it, go to **System Settings > Privacy & Security > Automation** and enable Google Chrome under MeetSnap.

## How It Works

MeetSnap uses macOS [NSWorkspace](https://developer.apple.com/documentation/appkit/nsworkspace) notifications to detect when Chrome launches, quits, or gains/loses focus. When Chrome is involved in an app switch, MeetSnap immediately checks for tabs matching `meet.google.com` with an active meeting code. A 15-second background poll serves as a backup. All AppleScript execution runs on a background thread.

~500 lines of Swift, zero dependencies.

## Requirements

- macOS 13 (Ventura) or later
- Google Chrome

## License

[MIT](LICENSE)
