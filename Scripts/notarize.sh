#!/bin/bash
set -e

# MeetSnap Notarization Script
# Prerequisites:
#   1. Apple Developer Program membership
#   2. Developer ID Application certificate installed
#   3. Store credentials first:
#      xcrun notarytool store-credentials "MeetSnap" \
#        --apple-id "your@email.com" \
#        --team-id "YOUR_TEAM_ID" \
#        --password "app-specific-password"

APP_PATH="${1:-build/export/MeetSnap.app}"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: $APP_PATH not found"
    echo "Usage: ./notarize.sh [path/to/MeetSnap.app]"
    exit 1
fi

echo "==> Verifying code signature..."
codesign --verify --deep --strict "$APP_PATH"
echo "    Signature valid."

echo "==> Creating ZIP for notarization..."
ZIP_PATH="build/MeetSnap-notarize.zip"
mkdir -p build
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

echo "==> Submitting for notarization (this may take a few minutes)..."
xcrun notarytool submit "$ZIP_PATH" \
    --keychain-profile "MeetSnap" \
    --wait

echo "==> Stapling notarization ticket..."
xcrun stapler staple "$APP_PATH"

echo "==> Verifying notarization..."
xcrun stapler validate "$APP_PATH"
spctl --assess --type execute --verbose "$APP_PATH"

rm "$ZIP_PATH"
echo "==> Done. $APP_PATH is signed and notarized."
