// Renders the Mac App Store screenshots into fastlane/screenshots/<store locale>/.
// Run through scripts/screenshots.sh, which compiles this file together with the
// app's own SettingsView.swift and MenuBarIcon.swift (with APP_STORE defined, like
// the App Store build), so the settings slide shows the real settings view.
//
// Usage: StoreScreenshots <repo root>
//
// Each slide is drawn offscreen at 1440x900 points and written at 2x, 2880x1800,
// one of Apple's accepted desktop sizes, as an opaque PNG. The shot list and the
// language map come from screenshots.config.json; every word drawn on a slide comes
// from fastlane/screenshots/captions.json. No Screen Recording permission needed.

import AppKit
import SwiftUI

// MARK: - Config and captions

struct Config: Decodable {
    struct Language: Decodable { let app: String; let store: [String] }
    struct Store: Decodable {
        struct Shot: Decodable { let id: String }
        let outDir: String
        let shots: [Shot]
    }
    let languages: [Language]
    let store: Store
}

/// captions.json: shot id -> field -> store locale -> text (or list of texts for "labels").
struct Captions {
    private let json: [String: Any]

    init(url: URL) throws {
        json = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any] ?? [:]
    }

    func text(_ shot: String, _ field: String, _ locale: String) throws -> String {
        guard let value = ((json[shot] as? [String: Any])?[field] as? [String: Any])?[locale] as? String else {
            throw Failure("captions.json has no \(shot).\(field) for \(locale)")
        }
        try Self.check(value)
        return value
    }

    func labels(_ shot: String, _ locale: String) throws -> [String] {
        guard let value = ((json[shot] as? [String: Any])?["labels"] as? [String: Any])?[locale] as? [String] else {
            throw Failure("captions.json has no \(shot).labels for \(locale)")
        }
        try value.forEach(Self.check)
        return value
    }

    /// Store copy rules (fastlane/AGENTS.md): no em dashes, never "Mac" or "macOS".
    private static func check(_ text: String) throws {
        if text.contains("\u{2014}") { throw Failure("Em dash in caption: \(text)") }
        if text.range(of: #"\bmac(os)?\b"#, options: [.regularExpression, .caseInsensitive]) != nil {
            throw Failure("Forbidden platform wording in caption: \(text)")
        }
    }
}

struct Failure: Error, CustomStringConvertible {
    let description: String
    init(_ description: String) { self.description = description }
}

// MARK: - Palette (from the app icon, Tools/make-icon.swift)

enum Palette {
    static let top = Color(.sRGB, red: 0.20, green: 0.22, blue: 0.27)
    static let bottom = Color(.sRGB, red: 0.08, green: 0.09, blue: 0.11)
    static let orange = Color(.sRGB, red: 1.0, green: 0.58, blue: 0.20)
}

// MARK: - Building blocks

/// The caption band every slide shares: a small tracked eyebrow over a large headline.
struct Slide<Content: View>: View {
    let eyebrow: String
    let headline: String
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            LinearGradient(colors: [Palette.top, Palette.bottom], startPoint: .top, endPoint: .bottom)
            RadialGradient(colors: [Palette.orange.opacity(0.16), .clear], center: .init(x: 0.5, y: 1.05),
                           startRadius: 0, endRadius: 700)
            VStack(spacing: 0) {
                Text(eyebrow.uppercased())
                    .font(.system(size: 20, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(Palette.orange)
                    .padding(.top, 64)
                Text(headline)
                    .font(.system(size: 58, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(2)
                    .padding(.horizontal, 120)
                    .padding(.top, 14)
                Spacer(minLength: 0)
                content
                Spacer(minLength: 0)
            }
        }
        .frame(width: 1440, height: 900)
    }
}

/// A keyboard key, drawn like a light keycap.
struct Keycap: View {
    let label: String
    var size: CGFloat = 120

    var body: some View {
        Text(label)
            .font(.system(size: size * 0.42, weight: .medium))
            .foregroundStyle(Color(white: 0.18))
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: size * 0.16)
                    .fill(LinearGradient(colors: [Color(white: 0.99), Color(white: 0.86)], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .black.opacity(0.45), radius: size * 0.06, y: size * 0.05)
            )
    }
}

struct CommandH: View {
    var size: CGFloat = 120
    var body: some View {
        HStack(spacing: size * 0.22) {
            Keycap(label: "⌘", size: size)
            Keycap(label: "H", size: size)
        }
    }
}

/// An illustrative desktop: an abstract wallpaper under a menu bar that carries
/// the real CommandH menu bar icon.
struct Screen<Content: View>: View {
    var width: CGFloat
    var height: CGFloat
    @ViewBuilder let content: Content

    var body: some View {
        ZStack(alignment: .top) {
            Wallpaper()
            content
            MenuBar()
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(.white.opacity(0.14), lineWidth: 1))
        .shadow(color: .black.opacity(0.5), radius: 30, y: 16)
    }
}

struct Wallpaper: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.sRGB, red: 0.16, green: 0.30, blue: 0.62),
                                    Color(.sRGB, red: 0.46, green: 0.32, blue: 0.68),
                                    Color(.sRGB, red: 0.96, green: 0.56, blue: 0.40)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            GeometryReader { g in
                Ellipse().fill(.white.opacity(0.10))
                    .frame(width: g.size.width * 1.4, height: g.size.height * 0.9)
                    .offset(x: -g.size.width * 0.2, y: g.size.height * 0.62)
                Ellipse().fill(.black.opacity(0.10))
                    .frame(width: g.size.width * 1.2, height: g.size.height * 0.8)
                    .offset(x: g.size.width * 0.15, y: g.size.height * 0.78)
            }
        }
    }
}

struct MenuBar: View {
    var body: some View {
        HStack(spacing: 18) {
            Spacer()
            Image(nsImage: makeMenuBarIcon()).renderingMode(.template).foregroundStyle(.white)
            Image(systemName: "wifi").foregroundStyle(.white)
            Image(systemName: "battery.75percent").foregroundStyle(.white)
            Text("9:41").font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
        }
        .font(.system(size: 14))
        .padding(.horizontal, 16)
        .frame(height: 28)
        .background(.black.opacity(0.22))
    }
}

/// A generic app window: traffic lights over placeholder content lines.
struct AppWindow: View {
    var width: CGFloat = 420
    var height: CGFloat = 270

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Circle().fill(Color(.sRGB, red: 1.0, green: 0.37, blue: 0.34))
                Circle().fill(Color(.sRGB, red: 1.0, green: 0.74, blue: 0.18))
                Circle().fill(Color(.sRGB, red: 0.16, green: 0.79, blue: 0.25))
            }
            .frame(height: 12)
            .padding(14)
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<5) { i in
                    RoundedRectangle(cornerRadius: 4).fill(Color(white: 0.86))
                        .frame(width: width * [0.8, 0.6, 0.72, 0.5, 0.66][i], height: 12)
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 8)
            Spacer()
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.97)))
        .shadow(color: .black.opacity(0.35), radius: 18, y: 10)
    }
}

/// Where a window was: a dashed outline.
struct HiddenWindow: View {
    var width: CGFloat = 420
    var height: CGFloat = 270
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(.white.opacity(0.55), style: StrokeStyle(lineWidth: 2.5, dash: [10, 8]))
            .frame(width: width, height: height)
    }
}

struct Pill: View {
    let text: String
    let systemImage: String
    let tint: Color
    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 11)
            .background(Capsule().fill(tint))
    }
}

// MARK: - Slides

struct HeroSlide: View {
    let eyebrow: String, headline: String, labels: [String]
    var body: some View {
        Slide(eyebrow: eyebrow, headline: headline) {
            Screen(width: 1080, height: 560) {
                VStack(spacing: 34) {
                    HiddenWindow(width: 520, height: 300)
                    CommandH(size: 104)
                }
                .padding(.top, 40)
                .frame(maxHeight: .infinity)
            }
            .overlay(alignment: .bottomTrailing) {
                Pill(text: labels[0], systemImage: "checkmark.circle.fill", tint: Palette.orange)
                    .padding(26)
            }
            .padding(.bottom, 36)
        }
    }
}

struct BeforeAfterSlide: View {
    let eyebrow: String, headline: String, labels: [String]
    var body: some View {
        Slide(eyebrow: eyebrow, headline: headline) {
            HStack(spacing: 56) {
                side(title: labels[0], result: labels[1], hidden: false)
                side(title: labels[2], result: labels[3], hidden: true)
            }
            .padding(.bottom, 30)
        }
    }

    private func side(title: String, result: String, hidden: Bool) -> some View {
        VStack(spacing: 22) {
            Text(title)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white.opacity(0.85))
            Screen(width: 560, height: 380) {
                Group {
                    if hidden { HiddenWindow(width: 330, height: 210) } else { AppWindow(width: 330, height: 210) }
                }
                .frame(maxHeight: .infinity)
                .padding(.top, 20)
            }
            .overlay(alignment: .bottom) {
                Pill(text: result,
                     systemImage: hidden ? "checkmark.circle.fill" : "xmark.circle.fill",
                     tint: hidden ? Palette.orange : Color(white: 0.32))
                    .padding(20)
            }
            CommandH(size: 64)
        }
    }
}

/// The system switch as it looks in the active settings window. This tool can never
/// be the active app (macOS won't activate a background process), so AppKit would
/// draw every switch in its gray, inactive-window state.
struct ActiveSwitch: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Capsule()
            .fill(configuration.isOn ? Brand.accent : Color(white: 0.85))
            .overlay(Capsule().strokeBorder(.black.opacity(0.06), lineWidth: 0.5))
            .frame(width: 32, height: 19)
            .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                Circle().fill(.white)
                    .shadow(color: .black.opacity(0.25), radius: 0.8, y: 0.5)
                    .frame(width: 17, height: 17)
                    .padding(1)
            }
    }
}

struct SettingsSlide: View {
    let eyebrow: String, headline: String
    var body: some View {
        Slide(eyebrow: eyebrow, headline: headline) {
            VStack(spacing: 0) {
                // Window chrome around the app's real settings view.
                ZStack {
                    Text("CommandH Preferences").font(.system(size: 13, weight: .semibold)).foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        Circle().fill(Color(.sRGB, red: 1.0, green: 0.37, blue: 0.34))
                        Circle().fill(Color(white: 0.82))
                        Circle().fill(Color(white: 0.82))
                        Spacer()
                    }
                    .frame(height: 12)
                    .padding(.horizontal, 14)
                }
                .frame(height: 30)
                SettingsView(onQuit: {})
                    .toggleStyle(ActiveSwitch())
            }
            .frame(width: SettingsView.minimumSize.width)
            .background(Color(nsColor: .windowBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.black.opacity(0.25), lineWidth: 1))
            .shadow(color: .black.opacity(0.5), radius: 30, y: 16)
            .environment(\.colorScheme, .light)
            .scaleEffect(0.82)
            .padding(.bottom, 30)
        }
    }
}

/// The menu bar menu as the App Store build has it. NSMenu has no offscreen
/// rendering, so this draws the same items in the system menu's style.
struct MenuBarSlide: View {
    let eyebrow: String, headline: String, labels: [String]
    var body: some View {
        Slide(eyebrow: eyebrow, headline: headline) {
            Screen(width: 1080, height: 560) {
                HStack {
                    Spacer()
                    menu.padding(.trailing, 92).padding(.top, 34)
                }
            }
            .padding(.bottom, 36)
        }
    }

    private var menu: some View {
        // labels: Enabled, Show in Menu Bar, Open at Login, Settings…, Quit CommandH
        VStack(alignment: .leading, spacing: 0) {
            item(labels[0], checked: true)
            divider
            item(labels[1], checked: true)
            item(labels[2], checked: true)
            item(labels[3], shortcut: "⌘,")
            divider
            item(labels[4], shortcut: "⌘Q")
        }
        .padding(6)
        .frame(width: 330)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(white: 0.17).opacity(0.97)))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.white.opacity(0.18), lineWidth: 1))
        .shadow(color: .black.opacity(0.45), radius: 20, y: 10)
        .scaleEffect(1.25, anchor: .topTrailing)
    }

    private var divider: some View {
        Rectangle().fill(.white.opacity(0.14)).frame(height: 1).padding(.horizontal, 10).padding(.vertical, 5)
    }

    private func item(_ title: String, checked: Bool = false, shortcut: String? = nil) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark").font(.system(size: 13, weight: .bold)).opacity(checked ? 1 : 0).frame(width: 16)
            Text(title)
            Spacer()
            if let shortcut { Text(shortcut).foregroundStyle(.white.opacity(0.45)) }
        }
        .font(.system(size: 15))
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .frame(height: 26)
    }
}

struct PrivacySlide: View {
    let eyebrow: String, headline: String, labels: [String]
    var body: some View {
        Slide(eyebrow: eyebrow, headline: headline) {
            HStack(spacing: 36) {
                card("hand.raised.fill", labels[0], labels[1])
                card("wifi.slash", labels[2], labels[3])
                card("gift.fill", labels[4], labels[5])
            }
            .padding(.bottom, 40)
        }
    }

    private func card(_ symbol: String, _ title: String, _ detail: String) -> some View {
        VStack(spacing: 22) {
            Image(systemName: symbol)
                .font(.system(size: 64, weight: .semibold))
                .foregroundStyle(Palette.orange)
                .frame(height: 80)
            Text(title)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Text(detail)
                .font(.system(size: 21))
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 36)
        .padding(.top, 56)
        .frame(width: 380, height: 400)
        .background(RoundedRectangle(cornerRadius: 26).fill(.white.opacity(0.07)))
        .overlay(RoundedRectangle(cornerRadius: 26).strokeBorder(.white.opacity(0.12), lineWidth: 1))
    }
}

// MARK: - Rendering


@MainActor
func render<V: View>(_ view: V, to url: URL) throws {
    let size = NSSize(width: 1440, height: 900)
    let host = NSHostingView(rootView: view)
    host.frame = NSRect(origin: .zero, size: size)
    let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
    window.appearance = NSAppearance(named: .aqua)
    window.contentView = host
    window.setFrameOrigin(NSPoint(x: -20_000, y: -20_000))
    window.orderFrontRegardless()
    defer { window.orderOut(nil) }
    // Let SwiftUI lay out and the AppKit-backed controls (toggles) draw.
    RunLoop.main.run(until: Date().addingTimeInterval(0.8))
    host.layoutSubtreeIfNeeded()

    let scale: CGFloat = 2
    guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size.width * scale), pixelsHigh: Int(size.height * scale),
                                     bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                     colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0) else {
        throw Failure("Could not allocate the bitmap")
    }
    rep.size = size
    host.cacheDisplay(in: host.bounds, to: rep)

    // App Store screenshots must be opaque: redraw into an RGB context with no alpha.
    guard let image = rep.cgImage,
          let context = CGContext(data: nil, width: image.width, height: image.height, bitsPerComponent: 8, bytesPerRow: 0,
                                  space: CGColorSpace(name: CGColorSpace.sRGB)!,
                                  bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
        throw Failure("Could not flatten the bitmap")
    }
    context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
    guard let opaque = context.makeImage(),
          let png = NSBitmapImageRep(cgImage: opaque).representation(using: .png, properties: [:]) else {
        throw Failure("Could not encode the PNG")
    }
    try png.write(to: url)
}

@MainActor
func slide(_ id: String, _ captions: Captions, _ locale: String) throws -> AnyView {
    let eyebrow = try captions.text(id, "eyebrow", locale)
    let headline = try captions.text(id, "headline", locale)
    switch id {
    case "hero": return AnyView(HeroSlide(eyebrow: eyebrow, headline: headline, labels: try captions.labels(id, locale)))
    case "before-after": return AnyView(BeforeAfterSlide(eyebrow: eyebrow, headline: headline, labels: try captions.labels(id, locale)))
    case "settings": return AnyView(SettingsSlide(eyebrow: eyebrow, headline: headline))
    case "menu-bar": return AnyView(MenuBarSlide(eyebrow: eyebrow, headline: headline, labels: try captions.labels(id, locale)))
    case "privacy": return AnyView(PrivacySlide(eyebrow: eyebrow, headline: headline, labels: try captions.labels(id, locale)))
    default: throw Failure("Unknown shot \(id) in screenshots.config.json")
    }
}

@main
struct StoreScreenshots {
    @MainActor
    static func main() {
        let args = CommandLine.arguments
        guard args.count >= 2 else {
            FileHandle.standardError.write(Data("usage: StoreScreenshots <repo root>\n".utf8))
            exit(2)
        }
        let root = URL(fileURLWithPath: args[1])
        NSApplication.shared.setActivationPolicy(.prohibited)
        // SettingsView shows NSApp's icon; this tool has none of its own.
        NSApp.applicationIconImage = NSImage(contentsOf: root.appendingPathComponent("Resources/AppIcon-1024.png"))
        // The settings slide shows a fresh install: CommandH on, icon in the menu bar.
        UserDefaults.standard.set(true, forKey: Keys.enabled)
        UserDefaults.standard.set(true, forKey: Keys.showInMenuBar)

        do {
            let config = try JSONDecoder().decode(Config.self, from: Data(contentsOf: root.appendingPathComponent("screenshots.config.json")))
            let captions = try Captions(url: root.appendingPathComponent("fastlane/screenshots/captions.json"))
            for language in config.languages {
                for locale in language.store {
                    // Render the whole locale into a temp folder, then swap it in, so a
                    // failure never leaves a half-updated set behind.
                    let out = root.appendingPathComponent(config.store.outDir.replacingOccurrences(of: "{store}", with: locale))
                    let temp = out.deletingLastPathComponent().appendingPathComponent(".\(locale).tmp")
                    try? FileManager.default.removeItem(at: temp)
                    try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
                    for (index, shot) in config.store.shots.enumerated() {
                        let file = temp.appendingPathComponent("\(index)_APP_DESKTOP_\(shot.id).png")
                        try render(try slide(shot.id, captions, locale), to: file)
                        print("\(locale) \(file.lastPathComponent)")
                    }
                    try? FileManager.default.removeItem(at: out)
                    try FileManager.default.moveItem(at: temp, to: out)
                }
            }
        } catch {
            FileHandle.standardError.write(Data("error: \(error)\n".utf8))
            exit(1)
        }
    }
}
