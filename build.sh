#!/bin/zsh
# Builds build/CommandH.app (ad-hoc signed). Pass --install to copy it to /Applications.
set -euo pipefail
cd "${0:A:h}"

APP=build/CommandH.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp Info.plist "$APP/Contents/Info.plist"
mkdir -p "$APP/Contents/Resources"
cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
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
