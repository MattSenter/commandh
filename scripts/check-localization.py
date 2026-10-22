#!/usr/bin/env python3
"""Release gate for CommandH's languages: the app, the docs and the App Store listing.

Usage: scripts/check-localization.py [--lang de] [--skip-extract] [--skip-screenshots]

The language list is screenshots.config.json's `languages` (app code -> App Store
locales), so adding a row there is what makes a language ship, and this check then
requires every piece of it:

  App      Every string the code shows is a key in Localization/en.lproj (found by
           compiling Sources/ with -emit-localized-strings, both build flavors), and
           every other .lproj has exactly the same keys, translated: same format
           arguments, protected names kept, no em dash, no "Mac"/"macOS" a source
           string didn't have, and not just the English copied over.
           Info.plist's CFBundleLocalizations lists exactly those languages.
  Docs     README.<lang>.md, PRIVACY.<lang>.md and TERMS.<lang>.md exist and are translated, every
           README carries the full language bar, and every relative link and
           in-page anchor resolves. No em dashes (the docs are user facing).
  Store    fastlane/metadata/<store locale>/ has every listing file within Apple's
           limits, its URLs point at that language's docs, captions.json covers
           every shot, and fastlane/screenshots/<store locale>/ has a full set.

Exits non-zero with every problem listed.
"""

import argparse
import json
import re
import subprocess
import sys
import tempfile
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LOC = ROOT / "Localization"
CONFIG = json.loads((ROOT / "screenshots.config.json").read_text())
LANGUAGES = {row["app"]: row["store"] for row in CONFIG["languages"]}
SHOTS = [shot["id"] for shot in CONFIG["store"]["shots"]]
GITHUB = "https://github.com/MattSenter/commandh"
# The listing's marketing page. mattsenter.com has no ko or zh-Hant pages, so those
# languages link the English one.
SITE = "https://www.mattsenter.com"
SITE_PREFIX = {"de": "/de", "es": "/es", "fr": "/fr", "ja": "/ja", "pt-BR": "/pt", "zh-Hans": "/zh"}

EM_DASH = "—"
# "Mac" or "macOS" as a word. ASCII-letter boundaries, because \b never fires
# between "Mac" and a CJK character ("Macの").
MAC = re.compile(r"(?<![A-Za-z])mac(?:os)?(?![A-Za-z])", re.IGNORECASE)
FORMAT = re.compile(r"%(?:\d+\$)?[@dDuUxXoOfeEgGcCsSpaAF%]")
# Names that must survive translation untouched wherever the English has them.
PROTECTED = ["CommandH", "Matt Senter", "Senternet", "Cmd+H", "Cmd+Tab", "Slack", ":emoji:",
             "Weatherling", "Burly", "Comoji", "Premail", "Highwire", "StockCar", "Orgabot",
             "BeeReady", "SeedMatrix", "Dock"]
# Where Apple's own localization renames one of those: Simplified Chinese macOS
# calls the Dock 程序坞.
PROTECTED_RENAMED = {("Dock", "zh-Hans"): "程序坞"}
# Keys whose translation may legitimately equal the English in some language.
MAY_MATCH_ENGLISH = {"Version", "Version %@", "System", "Copyright © 2026 %@", "Dock",
                     "Enabled", "Privacy", "About"}

# App Store Connect field limits, in characters.
LISTING_LIMITS = {"name.txt": 30, "subtitle.txt": 30, "keywords.txt": 100,
                  "promotional_text.txt": 170, "description.txt": 4000}
LISTING_URLS = ["privacy_url.txt", "support_url.txt", "marketing_url.txt"]
DOCS = ("README", "PRIVACY", "TERMS")

problems = []


def problem(message):
    problems.append(message)


def doc_name(stem, lang):
    return f"{stem}.md" if lang == "en" else f"{stem}.{lang}.md"


def read_strings(path):
    """A .strings file as a dict, parsed by plutil so escapes are handled exactly."""
    out = subprocess.run(["plutil", "-convert", "json", "-o", "-", str(path)],
                         capture_output=True, text=True)
    if out.returncode != 0:
        problem(f"{path.relative_to(ROOT)} does not parse: {out.stderr.strip()}")
        return {}
    return json.loads(out.stdout)


def source_keys():
    """Every localizable string in Sources/, from both build flavors."""
    keys = set()
    sources = sorted(str(p) for p in (ROOT / "Sources").glob("*.swift"))
    for flags in ([], ["-D", "APP_STORE"]):
        with tempfile.TemporaryDirectory() as tmp:
            result = subprocess.run(
                ["swiftc", "-c", "-swift-version", "5", "-module-name", "CommandH", *flags,
                 "-emit-localized-strings", "-emit-localized-strings-path", tmp, *sources],
                cwd=tmp, capture_output=True, text=True)
            if result.returncode != 0:
                sys.exit(f"swiftc failed:\n{result.stderr}")
            for data in Path(tmp).glob("*.stringsdata"):
                for entries in json.loads(data.read_text()).get("tables", {}).values():
                    keys.update(entry["key"] for entry in entries)
    return keys


def normalized(text):
    return re.sub(r"\s+", " ", text).strip().lower()


# MARK: App

def check_app(langs, extract):
    english = read_strings(LOC / "en.lproj" / "Localizable.strings")
    if extract:
        used = source_keys()
        for key in sorted(used - english.keys()):
            problem(f"en.lproj is missing a string the app shows: {key!r}")
        for key in sorted(english.keys() - used):
            problem(f"en.lproj has a key the app no longer uses: {key!r}")

    on_disk = {p.name.removesuffix(".lproj") for p in LOC.glob("*.lproj")}
    for lang in sorted(on_disk - LANGUAGES.keys()):
        problem(f"Localization/{lang}.lproj exists but {lang} is not in screenshots.config.json")

    info = subprocess.run(["plutil", "-extract", "CFBundleLocalizations", "json", "-o", "-",
                           str(ROOT / "Info.plist")], capture_output=True, text=True)
    declared = set(json.loads(info.stdout)) if info.returncode == 0 else set()
    if declared != set(LANGUAGES):
        problem(f"Info.plist CFBundleLocalizations {sorted(declared)} != languages {sorted(LANGUAGES)}")

    for lang in langs:
        if lang == "en":
            continue
        path = LOC / f"{lang}.lproj" / "Localizable.strings"
        if not path.exists():
            problem(f"Missing {path.relative_to(ROOT)}")
            continue
        strings = read_strings(path)
        for key in sorted(english.keys() - strings.keys()):
            problem(f"{lang}: missing {key!r}")
        for key in sorted(strings.keys() - english.keys()):
            problem(f"{lang}: stale key {key!r}")
        for key, value in strings.items():
            if key not in english:
                continue
            where = f"{lang}: {key!r}"
            if not value.strip():
                problem(f"{where} is empty")
            if sorted(FORMAT.findall(value)) != sorted(FORMAT.findall(key)):
                problem(f"{where} has format arguments {FORMAT.findall(value)}, expected {FORMAT.findall(key)}")
            if EM_DASH in value:
                problem(f"{where} contains an em dash")
            if MAC.search(value) and not MAC.search(key):
                problem(f"{where} adds Mac/macOS wording: {value!r}")
            for name in PROTECTED:
                if name in key and PROTECTED_RENAMED.get((name, lang), name) not in value:
                    problem(f"{where} drops {name!r}: {value!r}")
            if value == key and key not in MAY_MATCH_ENGLISH:
                problem(f"{where} is untranslated")


# MARK: Docs

def github_slug(heading):
    """GitHub's anchor for a Markdown heading."""
    text = re.sub(r"<[^>]+>", "", heading)
    text = re.sub(r"[`*_]|\[([^\]]*)\]\([^)]*\)", lambda m: m.group(1) or "", text).strip().lower()
    kept = []
    for ch in text:
        cat = unicodedata.category(ch)
        if ch in "-_" or ch == " " or cat[0] in "LNM":
            kept.append("-" if ch == " " else ch)
    return "".join(kept)


def check_markdown(path):
    text = path.read_text()
    name = path.relative_to(ROOT)
    if EM_DASH in text:
        problem(f"{name} contains an em dash")
    prose = re.sub(r"```.*?```", "", text, flags=re.S)
    anchors, counts = set(), {}
    for heading in re.findall(r"^#{1,6}\s+(.+?)\s*$", prose, re.M):
        slug = github_slug(heading)
        n = counts.get(slug, 0)
        counts[slug] = n + 1
        anchors.add(slug if n == 0 else f"{slug}-{n}")
    targets = re.findall(r"\]\(([^)\s]+)\)", prose) + re.findall(r'(?:href|src)="([^"]+)"', prose)
    for target in targets:
        if re.match(r"[a-z]+:", target):
            continue
        file, _, anchor = target.partition("#")
        if file and not (ROOT / file).exists():
            problem(f"{name}: broken link {target}")
        if not file and anchor and anchor not in anchors:
            problem(f"{name}: no heading for #{anchor}")
    return text


def check_docs(langs):
    english = {stem: (ROOT / doc_name(stem, "en")).read_text() for stem in DOCS}
    bar = [doc_name("README", lang) for lang in LANGUAGES]
    for lang in langs:
        for stem in DOCS:
            path = ROOT / doc_name(stem, lang)
            if not path.exists():
                problem(f"Missing {path.name}")
                continue
            text = check_markdown(path)
            if lang != "en" and normalized(text) == normalized(english[stem]):
                problem(f"{path.name} is the English text")
            if stem == "README":
                head = text[:2500]
                for other in bar:
                    if other != path.name and f"({other})" not in head and f'"{other}"' not in head:
                        problem(f"{path.name}: language bar does not link {other}")


# MARK: Store

def check_store(langs, screenshots):
    english = ROOT / "fastlane/metadata/en-US"
    captions = json.loads((ROOT / "fastlane/screenshots/captions.json").read_text())
    for lang in langs:
        for store in LANGUAGES[lang]:
            folder = ROOT / "fastlane/metadata" / store
            for file, limit in LISTING_LIMITS.items():
                path = folder / file
                if not path.exists():
                    problem(f"Missing fastlane/metadata/{store}/{file}")
                    continue
                text = path.read_text().strip()
                if not text:
                    problem(f"fastlane/metadata/{store}/{file} is empty")
                if len(text) > limit:
                    problem(f"fastlane/metadata/{store}/{file} is {len(text)} characters, limit {limit}")
                if MAC.search(text):
                    problem(f"fastlane/metadata/{store}/{file} says Mac or macOS (fastlane/AGENTS.md)")
                if EM_DASH in text:
                    problem(f"fastlane/metadata/{store}/{file} contains an em dash")
                if lang != "en" and file != "keywords.txt" and text == (english / file).read_text().strip():
                    problem(f"fastlane/metadata/{store}/{file} is the English text")
                # Apple wants a Terms of Use link; the description's last line carries it.
                terms = f"{GITHUB}/blob/main/{doc_name('TERMS', lang)}"
                if file == "description.txt" and not (text.splitlines() or [""])[-1].endswith(terms):
                    problem(f"fastlane/metadata/{store}/{file} must end with a Terms of Use link to {terms}")
            expected = {"privacy_url.txt": f"{GITHUB}/blob/main/{doc_name('PRIVACY', lang)}",
                        "marketing_url.txt": f"{SITE}{SITE_PREFIX.get(lang, '')}/projects/commandh",
                        "support_url.txt": f"{GITHUB}/issues"}
            for file in LISTING_URLS:
                path = folder / file
                actual = path.read_text().strip() if path.exists() else None
                if actual != expected[file]:
                    problem(f"fastlane/metadata/{store}/{file} is {actual!r}, expected {expected[file]!r}")

            for shot in SHOTS:
                fields = captions.get(shot, {})
                for field, by_locale in fields.items():
                    if field.startswith("_"):
                        continue
                    value = by_locale.get(store)
                    if value is None:
                        problem(f"captions.json: no {shot}.{field} for {store}")
                    elif field == "labels" and len(value) != len(by_locale["en-US"]):
                        problem(f"captions.json: {shot}.labels for {store} has {len(value)} items, en-US has {len(by_locale['en-US'])}")
                    elif lang != "en" and value == by_locale["en-US"] and not (field == "eyebrow" and value == "CommandH"):
                        problem(f"captions.json: {shot}.{field} for {store} is the English text")

            if screenshots:
                pngs = sorted((ROOT / "fastlane/screenshots" / store).glob("*.png"))
                if len(pngs) != len(SHOTS):
                    problem(f"fastlane/screenshots/{store} has {len(pngs)} screenshots, expected {len(SHOTS)} (scripts/screenshots.sh)")


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--lang", action="append", help="check only these app languages (repeatable)")
    parser.add_argument("--skip-extract", action="store_true", help="don't compile Sources/ to find the app's strings")
    parser.add_argument("--skip-screenshots", action="store_true", help="don't require rendered screenshots")
    args = parser.parse_args()
    langs = args.lang or list(LANGUAGES)
    for lang in langs:
        if lang not in LANGUAGES:
            sys.exit(f"{lang} is not in screenshots.config.json")

    check_app(langs, extract=not args.skip_extract)
    check_docs(langs)
    check_store(langs, screenshots=not args.skip_screenshots)

    if problems:
        print("\n".join(problems))
        print(f"\n{len(problems)} localization problem(s).")
        sys.exit(1)
    print(f"Localization OK: {', '.join(langs)}")


if __name__ == "__main__":
    main()
