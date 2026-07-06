#!/bin/bash
set -e

echo "Building MeetSnap..."
swift build -c release

APP="MeetSnap.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
mkdir -p "$APP/Contents/Resources"

cp .build/release/MeetSnap "$APP/Contents/MacOS/"
cp Resources/Info.plist "$APP/Contents/"

# Generate app icon
echo "Generating app icon..."
swift generate_icon.swift .

ICONSET="MeetSnap.iconset"
rm -rf "$ICONSET"
mkdir "$ICONSET"

sips -z 16 16     icon_1024.png --out "$ICONSET/icon_16x16.png"      > /dev/null
sips -z 32 32     icon_1024.png --out "$ICONSET/icon_16x16@2x.png"   > /dev/null
sips -z 32 32     icon_1024.png --out "$ICONSET/icon_32x32.png"      > /dev/null
sips -z 64 64     icon_1024.png --out "$ICONSET/icon_32x32@2x.png"   > /dev/null
sips -z 128 128   icon_1024.png --out "$ICONSET/icon_128x128.png"    > /dev/null
sips -z 256 256   icon_1024.png --out "$ICONSET/icon_128x128@2x.png" > /dev/null
sips -z 256 256   icon_1024.png --out "$ICONSET/icon_256x256.png"    > /dev/null
sips -z 512 512   icon_1024.png --out "$ICONSET/icon_256x256@2x.png" > /dev/null
sips -z 512 512   icon_1024.png --out "$ICONSET/icon_512x512.png"    > /dev/null
cp icon_1024.png "$ICONSET/icon_512x512@2x.png"

iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"

# Add icon reference to Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string AppIcon" "$APP/Contents/Info.plist" 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :CFBundleIconFile AppIcon" "$APP/Contents/Info.plist"

# Clean up
rm -rf "$ICONSET" icon_1024.png

echo "Done. Run with: open MeetSnap.app"
