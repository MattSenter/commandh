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

struct SettingsView: View {
    @AppStorage(Keys.enabled) private var enabled = true
    @AppStorage(Keys.method) private var method: HideMethod = .hideApp
    @AppStorage(Keys.showInMenuBar) private var showInMenuBar = true
    @State private var openAtLogin = SMAppService.mainApp.status == .enabled
    /// Cmd+Q only closes this window, so quitting needs its own button (the
    /// menu bar icon, which also has Quit, can be turned off).
    let onQuit: () -> Void

    var body: some View {
        Form {
            Section {
                HStack(spacing: 12) {
                    Image(nsImage: NSApp.applicationIconImage)
                        .resizable()
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("CommandH").font(.headline)
                        Text("Makes Cmd+H work even when the app is the last one showing.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            Section {
                Toggle("Enabled", isOn: $enabled)
                #if APP_STORE
                // Store screenshots show this window, and App Store copy never says "macOS".
                Text("Cmd+H hides the last app completely. While one app or none is showing, CommandH's icon appears in the Dock. That's what lets the last app hide.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                #else
                // Both options stay described so the trade-off is visible before choosing.
                Picker("When only one app is showing", selection: $method) {
                    methodOption("Hide the app",
                                 "The app hides completely, like Cmd+H anywhere else. CommandH's icon appears in the Dock while one app or none is showing.")
                        .tag(HideMethod.hideApp)
                    methodOption("Show Desktop",
                                 "Windows slide to the edges of the screen, and Cmd+H again brings them back. CommandH never appears in the Dock.")
                        .tag(HideMethod.showDesktop)
                }
                .pickerStyle(.radioGroup)
                .disabled(!enabled)
                #endif
            }

            Section {
                Toggle("Show in menu bar", isOn: $showInMenuBar)
                Toggle("Open at login", isOn: $openAtLogin)
                    .onChange(of: openAtLogin) { _, on in setOpenAtLogin(on) }
            } footer: {
                VStack(alignment: .leading, spacing: 12) {
                    if !showInMenuBar {
                        Text("To get back to these settings, open CommandH from your Applications folder.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Closing this window keeps CommandH running.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("Quit CommandH", action: onQuit)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .focusEffectDisabled()
        .frame(width: 440)
        .fixedSize(horizontal: false, vertical: true)
    }

    private func methodOption(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 2)
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
}
