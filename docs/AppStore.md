# Mac App Store release

CommandH ships two builds from one source tree:

| | Direct download | Mac App Store |
|---|---|---|
| Built by | `build.sh` / `scripts/release.sh` (swiftc, Developer ID, notarized) | `project.yml` (XcodeGen) + `fastlane` |
| Show Desktop mode | Yes | No. It calls `CoreDockSendNotification`, a private API App Review rejects (guideline 2.5.1). `APP_STORE` compiles it out. |
| App Sandbox | No | Yes, and no other entitlement |

Everything else (Hide the app, menu, settings, open at login) is identical. CI fails if
the App Store binary ever mentions `CoreDock` or gains an entitlement.

The fastlane setup is copied from Weatherling (`../weatherling/fastlane`), the native
macOS track of `/senternet-private-github-action-ios-release`.

## Pipeline

| Trigger | Workflow | Lane | Result |
|---|---|---|---|
| PR or push to `main` | `ci.yml` | none | Both builds, entitlement and private-API checks, listing copy rules |
| Manual | `macos-release.yml` | `mac beta` | TestFlight, internal testers |
| Manual | `beta-review.yml` | `mac beta_review` | A build (default: newest) to the external `VIPs` group and Beta App Review. Apple allows two submissions a day |
| Push tag `v1.0` | `macos-release.yml` | `mac release` | Listing + screenshots uploaded, submitted with automatic release, then `main` bumped to 1.1 |
| Manual | `prepare-app-store-drafts.yml` | `mac prepare_drafts` | Editable version staged with automatic release, never submitted |

## One-time setup (before the first run)

1. **App ID.** Developer portal > Identifiers > register `com.mattsenter.CommandH` (macOS). No
   capabilities needed.
2. **Mac App Store profile.** Profiles > + > Mac App Store Connect > `com.mattsenter.CommandH` >
   the team's Apple Distribution certificate. The lane only fetches it (`readonly: true`);
   the API key cannot create it.
3. **App record.** App Store Connect > Apps > + > New App: platform macOS, name
   `CommandH: Hide the Last App`, primary language English (U.S.), bundle id
   `com.mattsenter.CommandH`, SKU `commandh`.
4. **Price: Free.** Pricing and Availability > Free, all territories. There is no price lane
   (deliver's price-tier API no longer exists).
5. **App Privacy.** `bundle exec fastlane mac set_privacy` (Apple ID login with 2FA; publishes
   "Data Not Collected"). Age rating, category and content rights are set by the release lane.
6. **Secrets.** The same seven Weatherling and StockCar use. The certificates are per team,
   so reuse the same `.p12` files:
   ```sh
   REPO=MattSenter/commandh
   gh secret set APP_STORE_CONNECT_API_KEY_P8 --repo $REPO < ~/path/AuthKey_<KEY_ID>.p8
   gh secret set APP_STORE_CONNECT_API_KEY_ID --repo $REPO --body <KEY_ID>
   gh secret set APP_STORE_CONNECT_API_ISSUER_ID --repo $REPO --body <ISSUER_ID>
   gh secret set APPLE_CERTIFICATE --repo $REPO --body "$(base64 -i apple_distribution.p12)"
   gh secret set APPLE_CERTIFICATE_PASSWORD --repo $REPO      # prompts
   gh secret set APPLE_INSTALLER_CERTIFICATE --repo $REPO --body "$(base64 -i mac_installer_distribution.p12)"
   gh secret set APPLE_INSTALLER_CERTIFICATE_PASSWORD --repo $REPO   # prompts
   ```
   To run the lanes locally, export `APP_STORE_CONNECT_API_KEY_ID` and
   `APP_STORE_CONNECT_API_ISSUER_ID` in your shell; the lanes read the `.p8` from
   `APP_STORE_CONNECT_API_KEY_PATH` (default `~/Downloads/AuthKey_<KEY_ID>.p8`). Keep the real
   values out of this repo: it is public.

## Shipping 1.0

1. Run **macOS Release** on `main` (`gh workflow run macos-release.yml --ref main`); wait for the TestFlight build and try it.
   Optional: run **Submit for Beta Review** to send it to external testers.
2. Optional: run **Prepare App Store Drafts** with version `1.0` to review the listing in App
   Store Connect first.
3. `git tag v1.0 && git push origin v1.0`.

1.0 went live on 2026-11-20: https://apps.apple.com/app/id6825789142.

## Shipping an update

1. Rewrite `fastlane/metadata/<store locale>/release_notes.txt` in every locale, and update
   `description.txt` and the READMEs if the version adds or changes a feature.
2. Rerun `scripts/screenshots.sh` if the settings window, the menu or any string changed.
3. `python3 scripts/check-localization.py`.
4. `git tag v1.1 && git push origin v1.1` (same lane as 1.0: listing, screenshots, submit).

Name, subtitle and keywords can only change with a new version, so listing fixes ride along
with the next release. Promotional text is the one field that can change at any time.

## The listing

- Text: `fastlane/metadata/<store locale>/`, one folder per App Store locale in
  `screenshots.config.json` (en-US, de-DE, es-ES, es-MX, fr-FR, fr-CA, ja, ko, pt-BR, zh-Hans,
  zh-Hant). `release_notes.txt` is What's New: rewrite it for each version, in every locale
  (1.0 had none, because Apple does not accept What's New on a first version).
- Search fields: the subtitle carries the phrase people search for ("show desktop"), and
  `keywords.txt` never repeats a word from the name or subtitle, because Apple indexes each word
  once. Details in `fastlane/AGENTS.md`.
- URLs: support is the GitHub issues page, privacy is that language's `PRIVACY.<lang>.md`, and
  marketing is that language's CommandH page on mattsenter.com (English where the site has no
  translation). `scripts/check-localization.py` pins all three.
- Finding the app: App Store search treats "CommandH" as a misspelling and rewrites it, so a
  search for the name does not find the app. Always link `https://apps.apple.com/app/id6825789142`
  and never tell anyone to search for it.
- `python3 scripts/check-localization.py` (also in CI) fails if any language is missing a
  listing file, goes over Apple's limits, or still has English text.
- Never "Mac" or "macOS", no em dashes: `fastlane/AGENTS.md`. Enforced by CI and the lanes.

## Screenshots

`scripts/screenshots.sh` renders `fastlane/screenshots/<store locale>/` (six 2880x1800 PNGs per
locale) offscreen from `Tools/StoreScreenshots.swift`, which compiles in the app's real
`SettingsView` and menu bar icon. Shots and languages: `screenshots.config.json`. Captions:
`fastlane/screenshots/captions.json`. The words inside the settings window and the menu come from
`Localization/<lang>.lproj`, the same strings the app ships, so each language renders in its own
child process. Rerun after any settings UI or translation change. The menu slide draws the App
Store menu's items in the system style, because NSMenu cannot render offscreen; keep its item
list in sync with `buildStatusMenu()`.

Order (the `store.shots` list): before-after, hero, bring-back, privacy, settings, menu-bar.
Search results show the first shot, so the before/after slide leads: it is the only one that
explains the problem and the fix at a glance. The bring-back slide's Dock is drawn from
placeholder squares; never put a real app's icon in a screenshot.

Upload just the screenshots to an editable version: `bundle exec fastlane mac upload_screenshots version:1.1`.

## Private review contact

The App Review contact (`fastlane/metadata/review_information/{first_name,last_name,email_address,phone_number}.txt`)
is gitignored because this repo is public. Keep those files locally; App Store Connect keeps the
contact across versions, so CI runs (which don't have the files) leave it unchanged. For the
`set_privacy` lane, export `FASTLANE_USER` with your Apple ID instead of putting it in the Appfile.
