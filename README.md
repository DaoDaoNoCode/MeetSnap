<p align="center">
  <img src="icon_256.png" width="128" height="128" alt="MeetSnap icon">
</p>

<h1 align="center">MeetSnap</h1>

<p align="center">
  <strong>One-click access to your active Google Meet tab.</strong>
  <br>
  A tiny macOS menu bar app that brings your meeting back to the front — from any app.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13%2B-blue" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9-orange" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

---

## Why

You're multitasking during a Google Meet call. Someone says your name. It takes you 10 seconds to find the right Chrome tab.

MeetSnap fixes that. Click the menu bar icon and you're back in your meeting instantly.

## How It Works

- **Outline icon** — no active meeting
- **Filled icon** — you have a meeting running, click to switch to it
- **Right-click** — Launch at Login, About, Quit

The app watches for Chrome tabs with an active Google Meet URL. When you click the icon, it brings that tab to the front — from any app, any desktop.

## Install

### Homebrew

```
brew tap DaoDaoNoCode/tap
brew install --cask meetsnap
```

### Download

1. Grab the latest zip from [Releases](https://github.com/DaoDaoNoCode/MeetSnap/releases)
2. Unzip and move `MeetSnap.app` to `/Applications`
3. Remove the quarantine flag (unsigned app):
   ```
   xattr -cr /Applications/MeetSnap.app
   ```
4. Open MeetSnap from Applications

### Build from Source

```bash
git clone https://github.com/DaoDaoNoCode/MeetSnap.git
cd MeetSnap
bash build.sh
open MeetSnap.app
```

Requires Xcode Command Line Tools (`xcode-select --install`).

## Permissions

On first launch, macOS will ask you to grant Automation permission for Google Chrome. This is required so MeetSnap can find and switch to your Meet tab. You can manage this in **System Settings > Privacy & Security > Automation**.

## Requirements

- macOS 13 (Ventura) or later
- Google Chrome

## License

MIT
