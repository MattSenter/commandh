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

The rule holds in every language: a translation never says "Mac" or "macOS" either
(including CJK copy such as "Macの", which a plain `\b` regex misses).
`scripts/check-localization.py` checks each locale's listing and captions.

No pricing references in screenshot captions or promotional text, including "free",
discounts, subscriptions, or "nothing to buy", in any language. App Review rejected
the privacy screenshot for this. Keep pricing claims in description.txt only.
Do not mention open source in the listing or screenshots either (user preference).

# Search fields

Apple indexes the name, the subtitle and `keywords.txt`, each word once. The description and
promotional text are not indexed, so write those for people, not for search.

- `keywords.txt` never repeats a word from `name.txt` or `subtitle.txt`, in any locale, and
  never repeats a word within itself. Commas, no spaces after them.
- The subtitle states the result people search for ("show desktop"), not how the app works.
- "command" stays in the keyword field: "CommandH" is one token, so the word is not indexed
  from the name.
- These three fields only change with a new version.

# Release notes

`release_notes.txt` is required in every locale (`scripts/check-localization.py`). Rewrite it
for each version, and name panes and buttons exactly as that language's
`Localization/<lang>.lproj` does.
Every release notes file ends with a blank line and then the sign-off, in English in every locale:

    Love,
    -Matt
