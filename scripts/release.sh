#!/bin/zsh
# Builds, Developer ID signs, notarizes and staples CommandH, then zips it for a
# GitHub release at build/CommandH-<version>.zip.
#
# One-time setup (stores notary credentials in your keychain):
#   xcrun notarytool store-credentials commandh-notary \
#     --key <AuthKey_XXXX.p8> --key-id <KEY_ID> --issuer <ISSUER_ID>
#
# Usage:
#   scripts/release.sh                 # uses the "commandh-notary" keychain profile
#   NOTARY_PROFILE=other scripts/release.sh
set -euo pipefail
cd "${0:A:h}/.."

TEAM_ID="SD44498F6T"
PROFILE="${NOTARY_PROFILE:-commandh-notary}"
APP=build/CommandH.app
VERSION=$(sed -n 's/^ *MARKETING_VERSION: "\(.*\)"$/\1/p' project.yml)
ZIP="build/CommandH-$VERSION.zip"

./build.sh

SIGN_ID="${APP_SIGN_ID:-$(security find-identity -v -p codesigning | grep -Eo '"Developer ID Application[^"]*\('$TEAM_ID'\)"' | head -1 | tr -d '"')}"
if [[ -z "$SIGN_ID" ]]; then
  echo "No Developer ID Application identity for team $TEAM_ID found." >&2
  exit 1
fi

echo "Signing with $SIGN_ID"
codesign --force --options runtime --timestamp --sign "$SIGN_ID" "$APP"
codesign --verify --strict --verbose=2 "$APP"

echo "Notarizing (profile: $PROFILE)"
rm -f "$ZIP"
ditto -c -k --keepParent "$APP" "$ZIP"
xcrun notarytool submit "$ZIP" --keychain-profile "$PROFILE" --wait
xcrun stapler staple "$APP"

# Re-zip so the shipped archive contains the stapled ticket.
rm -f "$ZIP"
ditto -c -k --keepParent "$APP" "$ZIP"
spctl --assess --type execute --verbose "$APP"
echo "Release ready: $ZIP"
