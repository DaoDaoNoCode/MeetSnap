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

- **Click to switch** — click the menu bar icon to instantly focus your active Meet tab in Chrome
- **At-a-glance status** — outlined icon means no meeting, filled icon means you're in one
- **Smart polling** — only checks Chrome when it's running, zero CPU otherwise
- **Launch at Login** — right-click the icon to enable
- **First-run onboarding** — guides you through the one-time Automation permission setup

## Install

### Homebrew (Recommended)

```
brew tap daodaonocode/tap
brew trust daodaonocode/tap
brew install meetsnap
```

Then copy to Applications (shown in post-install caveats):

```
cp -R $(brew --prefix)/Cellar/meetsnap/1.0/MeetSnap.app /Applications/
```

### Build from Source

```bash
git clone https://github.com/DaoDaoNoCode/MeetSnap.git
cd MeetSnap
bash build.sh
cp -R MeetSnap.app /Applications/
```

Requires Xcode Command Line Tools (`xcode-select --install`).

## Usage

| Action | Result |
|---|---|
| **Left-click** the menu bar icon | Switches to your active Google Meet tab |
| **Right-click** the menu bar icon | Shows menu: Launch at Login, About, Quit |
| Icon is **outlined** | No active meeting detected |
| Icon is **filled** | You have a meeting running — click to go back |

## Permissions

On first launch, macOS will ask you to grant Automation permission for Google Chrome. This allows MeetSnap to find and switch to your Meet tab.

If you accidentally deny it, go to **System Settings > Privacy & Security > Automation** and enable Google Chrome under MeetSnap.

## How It Works

MeetSnap uses macOS [NSWorkspace](https://developer.apple.com/documentation/appkit/nsworkspace) notifications to detect when Chrome launches or quits. While Chrome is running, it checks every 15 seconds (via AppleScript on a background thread) for tabs matching `meet.google.com` with an active meeting code. When you click the icon, it tells Chrome to activate that tab and bring the window to the front.

The entire app is ~450 lines of Swift with zero dependencies.

## Requirements

- macOS 13 (Ventura) or later
- Google Chrome

## License

[MIT](LICENSE)
