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
                Picker("When Cmd+H can't hide the last app", selection: $method) {
                    Text("Hide the app").tag(HideMethod.hideApp)
                    Text("Show Desktop").tag(HideMethod.showDesktop)
                }
                .pickerStyle(.radioGroup)
                .disabled(!enabled)
                Text(method == .hideApp
                     ? "CommandH briefly appears in the Dock so macOS lets the last app hide."
                     : "Windows slide to the edges of the screen. Press Cmd+H again to bring them back. No Dock icon.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
