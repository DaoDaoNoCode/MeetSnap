#!/bin/bash
set -e

# MeetSnap DMG Creation Script
# Run after notarize.sh

VERSION="${1:-1.0}"
APP_PATH="${2:-build/export/MeetSnap.app}"
DMG_NAME="MeetSnap-${VERSION}.dmg"
VOLUME_NAME="MeetSnap"
TMP_DMG="build/tmp-meetsnap.dmg"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: $APP_PATH not found"
    echo "Usage: ./create-dmg.sh [version] [path/to/MeetSnap.app]"
    exit 1
fi

mkdir -p build

echo "==> Creating DMG..."
rm -f "$TMP_DMG" "build/$DMG_NAME"

hdiutil create -size 20m -fs HFS+ -volname "$VOLUME_NAME" "$TMP_DMG"
MOUNT_DIR=$(hdiutil attach "$TMP_DMG" | grep "/Volumes/" | sed 's/.*\/Volumes/\/Volumes/')

cp -R "$APP_PATH" "$MOUNT_DIR/"
ln -s /Applications "$MOUNT_DIR/Applications"

hdiutil detach "$MOUNT_DIR"
hdiutil convert "$TMP_DMG" -format UDZO -o "build/$DMG_NAME"
rm "$TMP_DMG"

echo "==> Created build/$DMG_NAME"
echo ""
echo "To sign and notarize the DMG:"
echo "  codesign --sign 'Developer ID Application: Your Name (TEAM_ID)' build/$DMG_NAME"
echo "  xcrun notarytool submit build/$DMG_NAME --keychain-profile MeetSnap --wait"
echo "  xcrun stapler staple build/$DMG_NAME"
