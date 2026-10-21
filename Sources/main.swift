// CommandH: make Cmd+H work when the frontmost app is the last visible app.
//
// macOS refuses to hide an app when every other regular app is hidden. Every
// route to the hide (NSRunningApplication, AppleScript, Accessibility, private
// LaunchServices calls) is checked in the same place and gets refused, and
// forcing it just unhides the next app in line.
//
// Two ways around it, picked in settings:
//
// Hide the App (default): the rule only counts regular (Dock) apps. So whenever
// at most one other app is visible, CommandH turns itself into a regular app
// with a nearly invisible window. The last real app is then no longer "last",
// and the app's own Cmd+H hides it normally. The cost is a Dock icon while the
// stand-in is active. Regular apps always get one; there is no way around that.
//
// Show Desktop: CommandH stays out of the Dock. While the front app is the last
// visible one, it claims Cmd+H as a global hotkey and triggers the system's
// Show Desktop, which slides the windows to the screen edges. Cmd+H again
// brings them back.

import AppKit
import Carbon.HIToolbox
import ServiceManagement
import SwiftUI
import os // DEBUG-STANDIN

let standInLog = Logger(subsystem: "com.mattsenter.CommandH", category: "standin") // DEBUG-STANDIN

// MARK: - Show Desktop (private Dock API, no permissions needed)

#if APP_STORE
// The Mac App Store build (APP_STORE, set in project.yml) leaves Show Desktop
// out: it is a private Dock call, and App Review rejects private API use.
private enum ShowDesktop {
    static let isAvailable = false
    static func toggle() {}
}
#else
private enum ShowDesktop {
    private typealias SendFn = @convention(c) (CFString, UnsafeMutableRawPointer?) -> Void
    private static let send: SendFn? = {
        guard let handle = dlopen("/System/Library/Frameworks/ApplicationServices.framework/ApplicationServices", RTLD_NOW),
              let sym = dlsym(handle, "CoreDockSendNotification") else { return nil }
        return unsafeBitCast(sym, to: SendFn.self)
    }()

    static var isAvailable: Bool { send != nil }

    static func toggle() {
        guard let send else { NSSound.beep(); return }
        send("com.apple.showdesktop.awake" as CFString, nil)
    }
}
#endif

// MARK: - Global Cmd+H hotkey (Carbon, no permissions needed)

private final class HotKey {
    private var ref: EventHotKeyRef?
    private var handler: EventHandlerRef?
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        var spec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { _, _, userData in
            Unmanaged<HotKey>.fromOpaque(userData!).takeUnretainedValue().action()
            return noErr
        }, 1, &spec, Unmanaged.passUnretained(self).toOpaque(), &handler)
    }

    func register() {
        guard ref == nil else { return }
        let id = EventHotKeyID(signature: OSType(0x434D_4448), id: 1) // "CMDH"
        RegisterEventHotKey(UInt32(kVK_ANSI_H), UInt32(cmdKey), id, GetApplicationEventTarget(), 0, &ref)
    }

    func unregister() {
        guard let ref else { return }
        UnregisterEventHotKey(ref)
        self.ref = nil
    }
}

// MARK: - App

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var statusItem: NSStatusItem!
    private var statusVisibilityObservation: NSKeyValueObservation?
    private var settingStatusVisibility = false
    private var enabledItem: NSMenuItem!
    private var hideAppItem: NSMenuItem?
    private var showDesktopItem: NSMenuItem?
    private var menuBarItem: NSMenuItem!
    private var loginItem: NSMenuItem!
    private lazy var hotKey = HotKey { ShowDesktop.toggle() }

    /// Set only by the explicit Quit items. Every other quit collapses to the menu bar.
    private var isQuitting = false
    private var settingsOpen = false
    private var standingIn = false

    private let defaults = UserDefaults.standard

    private var enabled: Bool {
        get { defaults.object(forKey: Keys.enabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.enabled) }
    }

    private var method: HideMethod {
        get {
            guard ShowDesktop.isAvailable else { return .hideApp }
            return defaults.string(forKey: Keys.method).flatMap(HideMethod.init) ?? .hideApp
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.method) }
    }

    private var showInMenuBar: Bool {
        get { defaults.object(forKey: Keys.showInMenuBar) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.showInMenuBar) }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildMainMenu()
        buildStatusMenu()

        let center = NSWorkspace.shared.notificationCenter
        for name in [NSWorkspace.didActivateApplicationNotification,
                     NSWorkspace.didHideApplicationNotification,
                     NSWorkspace.didUnhideApplicationNotification,
                     NSWorkspace.didLaunchApplicationNotification,
                     NSWorkspace.didTerminateApplicationNotification] {
            center.addObserver(self, selector: #selector(update), name: name, object: nil)
        }
        // The settings window and the menu both write to UserDefaults.
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChanged), name: UserDefaults.didChangeNotification, object: nil)
        update()

        // Opened by hand (Finder, Spotlight, Launchpad): show settings. Opened at login: stay quiet.
        if !launchedAtLogin { showSettings() }
    }

    // Opening the app again while it runs, or clicking its Dock icon, shows settings.
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showSettings()
        return false
    }

    // A stray Cmd+Q (or Quit from the Dock or a script) collapses to the menu bar
    // instead of terminating. Only the Quit items, and logout, restart or shutdown,
    // actually quit.
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if isQuitting || systemIsEndingSession { return .terminateNow }
        collapseToTray()
        return .terminateCancel
    }

    /// Logout, restart and shutdown send a quit event with a reason attached.
    private var systemIsEndingSession: Bool {
        guard let event = NSAppleEventManager.shared().currentAppleEvent,
              event.eventID == kAEQuitApplication else { return false }
        return event.attributeDescriptor(forKeyword: kAEQuitReason) != nil
    }

    @objc private func quitApp() {
        isQuitting = true
        NSApp.terminate(nil)
    }

    private var launchedAtLogin: Bool {
        guard let event = NSAppleEventManager.shared().currentAppleEvent else { return false }
        return event.eventID == kAEOpenApplication
            && event.paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue == keyAELaunchedAsLogInItem
    }

    @objc private func settingsChanged() {
        update()
        refreshMenu()
    }

    /// Regular apps other than CommandH that are not hidden.
    private var visibleOtherApps: [NSRunningApplication] {
        let me = ProcessInfo.processInfo.processIdentifier
        return NSWorkspace.shared.runningApplications.filter {
            $0.activationPolicy == .regular && !$0.isHidden && !$0.isTerminated && $0.processIdentifier != me
        }
    }

    @objc private func update() {
        let visible = visibleOtherApps

        // Hide the App: stand in as a visible regular app while at most one other
        // app is visible. Staying regular after the last app is hidden matters:
        // dropping back to accessory then would make macOS unhide something.
        let standIn = enabled && method == .hideApp && visible.count <= 1
        standingIn = standIn
        // The settings window also needs a Dock icon while it is open.
        let policy: NSApplication.ActivationPolicy = standIn || settingsOpen ? .regular : .accessory
        if NSApp.activationPolicy() != policy {
            NSApp.setActivationPolicy(policy)
        }
        // A hidden CommandH does not count as visible, so it can't stand in.
        if standIn && NSApp.isHidden {
            if settingsOpen { settingsWindow.close() }
            NSApp.unhideWithoutActivation()
        }
        // Without a window, macOS hands focus to Finder after the hide and
        // unhides it. A nearly invisible window makes CommandH the next app.
        if standIn { placeholder.orderFront(nil) } else { placeholder.orderOut(nil) }

        // Show Desktop: claim Cmd+H only while the front app is the last visible one.
        let front = NSWorkspace.shared.frontmostApplication
        let frontIsLast = visible.count == 1 && visible[0].processIdentifier == front?.processIdentifier
        if enabled && method == .showDesktop && ShowDesktop.isAvailable && frontIsLast {
            hotKey.register()
        } else {
            hotKey.unregister()
        }
        standInLog.notice("update front=\(front?.localizedName ?? "-", privacy: .public) visible=\(visible.map { $0.localizedName ?? "?" }.joined(separator: ","), privacy: .public) standIn=\(standIn) policy=\(NSApp.activationPolicy().rawValue) hidden=\(NSApp.isHidden) active=\(NSApp.isActive) placeholderVisible=\(self.placeholder.isVisible) onScreen=\(self.placeholder.occlusionState.contains(.visible))") // DEBUG-STANDIN
    }

    private lazy var placeholder: NSWindow = {
        let w = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1, height: 1), styleMask: [.borderless], backing: .buffered, defer: false)
        w.backgroundColor = NSColor.black.withAlphaComponent(0.01)
        w.isOpaque = false
        w.hasShadow = false
        w.ignoresMouseEvents = true
        w.isReleasedWhenClosed = false
        w.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        return w
    }()

    // MARK: Settings window

    private lazy var settingsWindow: NSWindow = {
        let view = SettingsView(onQuit: { [weak self] in self?.quitApp() }).toggleStyle(.switch)
        let hosting = NSHostingController(rootView: view)
        // Sizing is left to the window, so it opens at the minimum and can grow.
        hosting.sizingOptions = []
        let w = NSWindow(contentViewController: hosting)
        w.title = "CommandH Preferences"
        w.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        w.setContentSize(SettingsView.minimumSize)
        w.contentMinSize = SettingsView.minimumSize
        w.titlebarAppearsTransparent = true
        w.backgroundColor = .windowBackgroundColor
        w.isReleasedWhenClosed = false
        w.delegate = self
        w.center()
        return w
    }()

    @objc private func showSettings() {
        settingsOpen = true
        update()
        settingsWindow.makeKeyAndOrderFront(nil)
        NSApp.activate()
    }

    func windowWillClose(_ notification: Notification) {
        guard (notification.object as? NSWindow) === settingsWindow else { return }
        settingsOpen = false
        // Flip the policy on the next runloop tick; done synchronously while the
        // app is frontmost, the Dock ignores it and the icon lingers.
        DispatchQueue.main.async { self.update() }
    }

    /// Cmd+Q and Cmd+W: close settings and drop out of the Dock and Cmd+Tab,
    /// keeping only the menu bar icon. While standing in, CommandH must stay a
    /// visible regular app, so it only closes the window.
    @objc private func collapseToTray() {
        if settingsOpen { settingsWindow.close() }
        if !standingIn { NSApp.hide(nil) }
        DispatchQueue.main.async { self.update() }
    }

    /// Cmd+H: an ordinary Hide, unless CommandH is standing in for the last
    /// app. Hiding it then would undo the stand-in, so just close the window.
    @objc private func hideFromKeyboard() {
        if standingIn {
            collapseToTray()
        } else {
            NSApp.hide(nil)
        }
    }

    // MARK: Menus

    // Shown while CommandH is the active app (settings open, or standing in).
    private func buildMainMenu() {
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "Preferences…", action: #selector(showSettings), keyEquivalent: ",").target = self
        appMenu.addItem(.separator())
        // Cmd+H is an ordinary Hide; Cmd+W and Cmd+Q collapse to the menu bar.
        appMenu.addItem(withTitle: "Hide CommandH", action: #selector(hideFromKeyboard), keyEquivalent: "h").target = self
        appMenu.addItem(withTitle: "Close Window", action: #selector(collapseToTray), keyEquivalent: "w").target = self
        appMenu.addItem(withTitle: "Close and Keep Running", action: #selector(collapseToTray), keyEquivalent: "q").target = self
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: "Quit CommandH", action: #selector(quitApp), keyEquivalent: "").target = self
        let appItem = NSMenuItem()
        appItem.submenu = appMenu
        let main = NSMenu()
        main.addItem(appItem)
        NSApp.mainMenu = main
    }

    private func buildStatusMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = makeMenuBarIcon()

        let menu = NSMenu()
        enabledItem = menu.addItem(withTitle: "Enabled", action: #selector(toggleEnabled), keyEquivalent: "")
        enabledItem.target = self

        #if !APP_STORE
        let methodMenu = NSMenu()
        let hideAppItem = methodMenu.addItem(withTitle: "Hide the App (Dock icon appears)", action: #selector(chooseHideApp), keyEquivalent: "")
        let showDesktopItem = methodMenu.addItem(withTitle: "Show Desktop (no Dock icon)", action: #selector(chooseShowDesktop), keyEquivalent: "")
        hideAppItem.target = self
        showDesktopItem.target = self
        if !ShowDesktop.isAvailable { showDesktopItem.action = nil }
        self.hideAppItem = hideAppItem
        self.showDesktopItem = showDesktopItem
        let methodItem = menu.addItem(withTitle: "When Cmd+H Can't Hide", action: nil, keyEquivalent: "")
        methodItem.submenu = methodMenu
        #endif

        menu.addItem(.separator())
        menuBarItem = menu.addItem(withTitle: "Show in Menu Bar", action: #selector(toggleMenuBar), keyEquivalent: "")
        menuBarItem.target = self
        loginItem = menu.addItem(withTitle: "Open at Login", action: #selector(toggleLogin), keyEquivalent: "")
        loginItem.target = self
        menu.addItem(withTitle: "Preferences…", action: #selector(showSettings), keyEquivalent: ",").target = self
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit CommandH", action: #selector(quitApp), keyEquivalent: "q").target = self
        statusItem.menu = menu

        statusItem.isVisible = showInMenuBar
        // Cmd-dragging the icon out of the menu bar turns the setting off too.
        statusVisibilityObservation = statusItem.observe(\.isVisible) { [weak self] item, _ in
            guard let self, item.isVisible != self.showInMenuBar else { return }
            self.showInMenuBar = item.isVisible
        }
        refreshMenu()
    }

    private func refreshMenu() {
        // Setting isVisible makes AppKit write its own defaults key, which posts
        // didChangeNotification and lands back here before isVisible reads the new
        // value. Without the guard that loops until the stack overflows.
        if !settingStatusVisibility && statusItem.isVisible != showInMenuBar {
            settingStatusVisibility = true
            statusItem.isVisible = showInMenuBar
            settingStatusVisibility = false
        }
        enabledItem.state = enabled ? .on : .off
        hideAppItem?.state = method == .hideApp ? .on : .off
        showDesktopItem?.state = method == .showDesktop ? .on : .off
        menuBarItem.state = showInMenuBar ? .on : .off
        loginItem.state = SMAppService.mainApp.status == .enabled ? .on : .off
    }

    @objc private func toggleEnabled() { enabled.toggle() }
    @objc private func chooseHideApp() { method = .hideApp }
    @objc private func chooseShowDesktop() { method = .showDesktop }
    @objc private func toggleMenuBar() { showInMenuBar.toggle() }

    @objc private func toggleLogin() {
        let service = SMAppService.mainApp
        do {
            if service.status == .enabled { try service.unregister() } else { try service.register() }
        } catch {
            NSSound.beep()
        }
        refreshMenu()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
