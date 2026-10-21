import ServiceManagement
import SwiftUI

enum HideMethod: String {
    case hideApp, showDesktop
}

/// UserDefaults keys shared by the settings window, the menu bar menu and the app delegate.
enum Keys {
    static let enabled = "enabled"
    static let method = "method"
    static let showInMenuBar = "showInMenuBar"
}

/// CommandH's few colors. Everything else uses the system's own, so the window
/// follows Light and Dark with the rest of the Mac.
enum Brand {
    /// The icon's orange in Dark; a deeper shade in Light so text and links on
    /// the light canvas keep at least 4.5:1 contrast.
    static let accent = Color(nsColor: NSColor(name: nil) {
        $0.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
            ? NSColor(srgbRed: 1.0, green: 0.58, blue: 0.20, alpha: 1)
            : NSColor(srgbRed: 0.62, green: 0.31, blue: 0.0, alpha: 1)
    })
    static let cardFill = Color.primary.opacity(0.05)
    static let sidebarFill = Color.primary.opacity(0.035)
    static let corner: CGFloat = 10
}

struct SettingsView: View {
    /// The window's opening and minimum content size; read by the app delegate.
    static let minimumSize = NSSize(width: 720, height: 660)

    @AppStorage(Keys.enabled) private var enabled = true
    @AppStorage(Keys.method) private var method: HideMethod = .hideApp
    @AppStorage(Keys.showInMenuBar) private var showInMenuBar = true
    @State private var openAtLogin = SMAppService.mainApp.status == .enabled
    @State private var selection: Pane = .hiding
    /// Two-second "Copied" confirmation on Copy Version Info.
    @State private var copiedVersion = false
    /// Cmd+Q only closes this window, so quitting needs its own button (the
    /// menu bar icon, which also has Quit, can be turned off).
    let onQuit: () -> Void

    init(initialPane: Pane = .hiding, onQuit: @escaping () -> Void) {
        _selection = State(initialValue: initialPane)
        self.onQuit = onQuit
    }

    enum Pane: String, CaseIterable, Identifiable {
        case hiding = "Hiding"
        case system = "System"
        case privacy = "Privacy"
        case otherProjects = "Other Projects"
        case about = "About"
        var id: String { rawValue }
        var title: String {
            switch self {
            case .hiding: return String(localized: "Hiding", comment: "Settings sidebar tab and pane title.")
            case .system: return String(localized: "System", comment: "Settings sidebar tab and pane title. Also the label of the system version row in About.")
            case .privacy: return String(localized: "Privacy", comment: "Settings sidebar tab and pane title.")
            case .otherProjects: return String(localized: "Other Projects", comment: "Settings sidebar tab and pane title listing the developer's other apps.")
            case .about: return String(localized: "About", comment: "Settings sidebar tab and pane title.")
            }
        }
        var icon: String {
            switch self {
            case .hiding: return "eye.slash"
            case .system: return "gearshape"
            case .privacy: return "hand.raised"
            case .otherProjects: return "square.grid.2x2"
            case .about: return "info.circle"
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            sidebar
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    sectionTitle(selection.title)
                    pane
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .tint(Brand.accent)
        }
        .focusEffectDisabled()
        .frame(minWidth: Self.minimumSize.width, minHeight: Self.minimumSize.height)
    }

    // MARK: Sidebar

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable().interpolation(.high)
                .frame(width: 120, height: 120)
                .frame(maxWidth: .infinity)
                .padding(.top, 4).padding(.bottom, 18)
                .accessibilityHidden(true)

            ForEach(Pane.allCases) { item in
                Button {
                    selection = item
                } label: {
                    HStack(spacing: 9) {
                        Image(systemName: item.icon).frame(width: 18)
                            .accessibilityHidden(true)
                        Text(item.title).font(.system(size: 13, weight: .medium))
                        Spacer()
                    }
                    .padding(.horizontal, 10).padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .fill(selection == item ? Brand.accent.opacity(0.14) : .clear)
                    )
                    .foregroundStyle(selection == item ? Brand.accent : .secondary)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == item ? .isSelected : [])
            }
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                BuiltByCredit(content: "settings")
                CopyrightLine()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 10)
        }
        .padding(12)
        // Wide enough for the copyright line on one line at 10pt.
        .frame(width: 206)
        .background(Brand.sidebarFill)
    }

    @ViewBuilder
    private var pane: some View {
        switch selection {
        case .hiding: hidingPane
        case .system: systemPane
        case .privacy: privacyPane
        case .otherProjects: OtherProjectsView()
        case .about: aboutPane
        }
    }

    // MARK: Hiding

    private var hidingPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Makes Cmd+H work even when the app is the last one showing.")
                .font(.system(size: 13))
                .fixedSize(horizontal: false, vertical: true)
            settingRow(Text("Enabled")) { switchToggle($enabled) }
            #if APP_STORE
            // Store screenshots show this window, and App Store copy never says "macOS".
            card(Text("When only one app is showing")) {
                caption("Cmd+H hides the last app completely. While one app or none is showing, CommandH's icon appears in the Dock. That's what lets the last app hide.")
            }
            #else
            // Both options stay described so the trade-off is visible before choosing.
            card(Text("When only one app is showing")) {
                Picker("When only one app is showing", selection: $method) {
                    methodOption("Hide the app",
                                 "The app hides completely, like Cmd+H anywhere else. CommandH's icon appears in the Dock while one app or none is showing.")
                        .tag(HideMethod.hideApp)
                    methodOption("Show Desktop",
                                 "Windows slide to the edges of the screen, and Cmd+H again brings them back. CommandH never appears in the Dock.")
                        .tag(HideMethod.showDesktop)
                }
                .pickerStyle(.radioGroup)
                .labelsHidden()
                .disabled(!enabled)
            }
            #endif
        }
    }

    private func methodOption(_ title: LocalizedStringKey, _ detail: LocalizedStringKey) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.system(size: 13))
            Text(detail)
                .font(.system(size: 11.5))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 3)
    }

    // MARK: System

    private var systemPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            settingRow(Text("Open at login")) {
                switchToggle($openAtLogin)
                    .onChange(of: openAtLogin) { _, on in setOpenAtLogin(on) }
            }
            VStack(alignment: .leading, spacing: 6) {
                settingRow(Text("Show in menu bar")) { switchToggle($showInMenuBar) }
                if !showInMenuBar {
                    caption("To get back to these settings, open CommandH from your Applications folder.")
                }
            }
            card(Text("Quit")) {
                HStack {
                    caption("Closing this window keeps CommandH running.")
                    Spacer()
                    Button("Quit CommandH", action: onQuit)
                }
            }
        }
    }

    private func setOpenAtLogin(_ on: Bool) {
        let service = SMAppService.mainApp
        do {
            if on { try service.register() } else { try service.unregister() }
        } catch {
            NSSound.beep()
        }
        let actual = service.status == .enabled
        if actual != on { openAtLogin = actual }
    }

    // MARK: Privacy

    private var privacyPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CommandH works entirely on your computer. It only looks at which apps are running and whether each one is hidden, and that never leaves your computer or gets stored. No account, no analytics, and no permissions to grant.")
                .font(.system(size: 13))
                .fixedSize(horizontal: false, vertical: true)
            card(Text("Network activity")) {
                caption("None. CommandH never connects to the internet on its own. The links in these settings open in your browser.")
            }
            Button("Read the full privacy policy") {
                NSWorkspace.shared.open(Self.privacyPolicyURL)
            }
            .buttonStyle(.link)
            .font(.system(size: 12))
        }
    }

    /// PRIVACY.md in the language the app is showing. Every app localization has
    /// a translated PRIVACY.<lang>.md (scripts/check-localization.py checks).
    private static var privacyPolicyURL: URL {
        let language = Bundle.main.preferredLocalizations.first ?? "en"
        let file = language == "en" ? "PRIVACY.md" : "PRIVACY.\(language).md"
        return URL(string: "https://github.com/MattSenter/commandh/blob/main/\(file)")!
    }

    // MARK: About

    private var aboutPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable().interpolation(.high)
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(verbatim: "CommandH").font(.system(size: 22, weight: .heavy))
                        .accessibilityAddTraits(.isHeader)
                    Text("Cmd+H that works on the last app, so you can finally see your desktop.")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }
            versionCard
            card(Text("On the web")) {
                HStack(spacing: 10) {
                    webButton("Source Code", icon: "chevron.left.forwardslash.chevron.right",
                              url: "https://github.com/MattSenter/commandh")
                    webButton("Report an Issue", icon: "exclamationmark.bubble",
                              url: "https://github.com/MattSenter/commandh/issues")
                    Spacer()
                }
            }
            card(Text("About the developer")) {
                caption("CommandH is designed, built, and shipped by Matt Senter, an independent developer who makes every Senternet product end to end.")
                HStack(spacing: 12) {
                    Button("See Other Projects") { selection = .otherProjects }
                    BuiltByCredit(content: "about")
                    Spacer()
                }
            }
        }
    }

    /// What am I running: the half of a support request people never know where to find.
    private var versionCard: some View {
        card(Text("Version")) {
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                GridRow {
                    Text(verbatim: "CommandH").foregroundStyle(.secondary)
                    Text(Self.versionString).textSelection(.enabled)
                }
                GridRow {
                    Text("System").foregroundStyle(.secondary)
                    Text(Self.systemString).textSelection(.enabled)
                }
            }
            .font(.system(size: 12).monospacedDigit())
            Button {
                NSPasteboard.general.clearContents()
                // Always English: it is pasted into a support request.
                NSPasteboard.general.setString("CommandH \(Self.versionNumber), \(Self.systemString)", forType: .string)
                copiedVersion = true
                Task { try? await Task.sleep(for: .seconds(2)); copiedVersion = false }
            } label: {
                Label(copiedVersion ? String(localized: "Copied") : String(localized: "Copy Version Info"),
                      systemImage: copiedVersion ? "checkmark" : "doc.on.doc")
            }
            .help("Copies the CommandH and system versions, handy for a support request.")
        }
    }

    private func webButton(_ title: LocalizedStringKey, icon: String, url: String) -> some View {
        Button {
            NSWorkspace.shared.open(URL(string: url)!)
        } label: {
            Label(title, systemImage: icon)
        }
        .accessibilityAddTraits(.isLink)
    }

    /// "1.0 (7)": the marketing version and build number.
    private static var versionNumber: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "?"
        let build = info?["CFBundleVersion"] as? String ?? "?"
        return "\(version) (\(build))"
    }

    private static var versionString: String {
        String(localized: "Version \(versionNumber)", comment: "Version row in About. The argument is the version and build, e.g. 1.0 (7).")
    }

    /// "macOS 26.0 (25A123)": the system half of what a support reply needs.
    private static var systemString: String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        let number = v.patchVersion == 0 ? "\(v.majorVersion).\(v.minorVersion)"
                                         : "\(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
        var size = 0
        sysctlbyname("kern.osversion", nil, &size, nil, 0)
        var buffer = [CChar](repeating: 0, count: max(size, 1))
        sysctlbyname("kern.osversion", &buffer, &size, nil, 0)
        let build = String(cString: buffer)
        return build.isEmpty ? "macOS \(number)" : "macOS \(number) (\(build))"
    }

    // MARK: Kit

    private func sectionTitle(_ text: String) -> some View {
        Text(text).font(.system(size: 17, weight: .bold))
            .accessibilityAddTraits(.isHeader)
    }

    /// A titled rounded panel: the unit every grouped setting lives in.
    private func card<Content: View>(_ title: Text, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            title.font(.system(size: 13, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Brand.corner).fill(Brand.cardFill))
    }

    /// Label in a fixed 180pt column, control right after, so controls line up across rows.
    private func settingRow<Control: View>(_ label: Text, @ViewBuilder control: () -> Control) -> some View {
        HStack(spacing: 14) {
            label.font(.system(size: 13))
                .frame(width: 180, alignment: .leading)
                .accessibilityHidden(true)
            control()
                .accessibilityLabel(label)
            Spacer(minLength: 0)
        }
    }

    /// The native switch comes from `.toggleStyle(.switch)` where the window is
    /// built, so the store screenshots can swap in a switch that draws as active.
    private func switchToggle(_ isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) { EmptyView() }.labelsHidden().tint(Brand.accent)
    }

    private func caption(_ text: LocalizedStringKey) -> some View {
        Text(text)
            .font(.system(size: 11.5))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}
