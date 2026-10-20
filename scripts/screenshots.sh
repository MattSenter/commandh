#!/bin/zsh
# Renders the Mac App Store screenshots into fastlane/screenshots/<store locale>/.
# Usage: scripts/screenshots.sh [store]
#
# Compiles Tools/StoreScreenshots.swift with the app's own SettingsView.swift and
# MenuBarIcon.swift, with APP_STORE defined like the App Store build, and runs it.
# Shots and languages: screenshots.config.json. Words: fastlane/screenshots/captions.json.
# Rendering is offscreen, so no Screen Recording permission is needed.
set -euo pipefail
cd "${0:A:h}/.."

case "${1:-store}" in
  store|all) ;;
  help) echo "CommandH has no site, so there are no help screenshots." >&2; exit 2 ;;
  *) echo "usage: scripts/screenshots.sh [store]" >&2; exit 2 ;;
esac

mkdir -p build
swiftc -O -swift-version 5 -parse-as-library -D APP_STORE -o build/StoreScreenshots \
  Tools/StoreScreenshots.swift Sources/SettingsView.swift Sources/MenuBarIcon.swift
build/StoreScreenshots "$PWD"

# Apple accepts 2880x1800 for the desktop set; refuse anything else.
for f in fastlane/screenshots/*/*.png; do
  size=$(sips -g pixelWidth -g pixelHeight "$f" | awk '/pixel/ {print $2}' | paste -sd x -)
  [[ "$size" == "2880x1800" ]] || { echo "$f is $size, expected 2880x1800" >&2; exit 1; }
done
echo "Screenshots OK: $(ls fastlane/screenshots/*/*.png | wc -l | tr -d ' ') files at 2880x1800"
