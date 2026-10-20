# App Store copy: mandatory wording rules

Never use "Mac" or "macOS" in any App Store copy. Apple rejected Weatherling for
this wording; it is a standing requirement for every Senternet App Store app.
Use "computer", "desktop", or similar instead. This covers every file under
`metadata/` (name, subtitle, description, keywords, promotional text, release
notes, review notes) and the captions and UI shown in `screenshots/`
(`captions.json`, and the settings window, whose App Store text avoids the word).

No em dashes in any of that copy either.

The `prepare_drafts` lane and CI refuse to run when either appears in `metadata/`.
Technical identifiers required by fastlane, build tools, or APIs (`platform: "osx"`,
`MAC_OS`, `APP_DESKTOP`) are configuration, not listing copy; keep them valid.
