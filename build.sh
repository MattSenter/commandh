#!/bin/zsh
# Builds build/CommandH.app (ad-hoc signed), the direct-download build with Show Desktop.
# Pass --install to copy it to /Applications. The Mac App Store build is project.yml + fastlane.
set -euo pipefail
cd "${0:A:h}"

APP=build/CommandH.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp Info.plist "$APP/Contents/Info.plist"
# Info.plist takes its versions from project.yml, which Xcode fills in; do the same here.
VERSION=$(sed -n 's/^ *MARKETING_VERSION: "\(.*\)"$/\1/p' project.yml)
BUILD=$(sed -n 's/^ *CURRENT_PROJECT_VERSION: "\(.*\)"$/\1/p' project.yml)
plutil -replace CFBundleShortVersionString -string "$VERSION" "$APP/Contents/Info.plist"
plutil -replace CFBundleVersion -string "$BUILD" "$APP/Contents/Info.plist"
mkdir -p "$APP/Contents/Resources"
cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
cp -R Resources/other-projects "$APP/Contents/Resources/other-projects"
swiftc -O -swift-version 5 -o "$APP/Contents/MacOS/CommandH" Sources/*.swift
codesign --force --sign - "$APP"
echo "Built $APP"

if [[ "${1:-}" == "--install" ]]; then
  pkill -x CommandH || true
  rm -rf /Applications/CommandH.app
  cp -R "$APP" /Applications/
  open /Applications/CommandH.app
  echo "Installed and launched /Applications/CommandH.app"
fi
