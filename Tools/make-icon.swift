// Renders the CommandH app icon and writes Resources/AppIcon.icns.
// Usage: swift Tools/make-icon.swift   (run from the repo root)
//
// Layout: a 2x2 grid on the standard macOS rounded square. The Command symbol
// sits top left, a stylized H bottom right, and the other two cells are empty.

import AppKit

func render(size: CGFloat) -> NSBitmapImageRep {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size), pixelsHigh: Int(size),
                               bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                               colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    let s = size / 1024 // design on a 1024 canvas

    // Body: 824pt rounded square centered, per Apple's macOS icon grid.
    let body = NSRect(x: 100 * s, y: 100 * s, width: 824 * s, height: 824 * s)
    let bodyPath = NSBezierPath(roundedRect: body, xRadius: 185 * s, yRadius: 185 * s)

    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.35)
    shadow.shadowBlurRadius = 24 * s
    shadow.shadowOffset = NSSize(width: 0, height: -10 * s)
    shadow.set()
    NSColor.black.setFill()
    bodyPath.fill()
    NSGraphicsContext.restoreGraphicsState()

    NSGradient(starting: NSColor(srgbRed: 0.20, green: 0.22, blue: 0.27, alpha: 1),
               ending: NSColor(srgbRed: 0.08, green: 0.09, blue: 0.11, alpha: 1))!
        .draw(in: bodyPath, angle: -90)

    // Grid cells inside the body (AppKit origin is bottom left).
    let inset = 110 * s
    let cell = (body.width - inset * 2) / 2
    let topLeft = NSRect(x: body.minX + inset, y: body.minY + inset + cell, width: cell, height: cell)
    let bottomRight = NSRect(x: body.minX + inset + cell, y: body.minY + inset, width: cell, height: cell)

    // Empty cells: faint little windows, each with a title bar and three dots.
    for r in [NSRect(x: topLeft.maxX, y: topLeft.minY, width: cell, height: cell),
              NSRect(x: topLeft.minX, y: bottomRight.minY, width: cell, height: cell)] {
        let win = r.insetBy(dx: 26 * s, dy: 26 * s)
        let winPath = NSBezierPath(roundedRect: win, xRadius: 40 * s, yRadius: 40 * s)
        NSColor.white.withAlphaComponent(0.06).setFill()
        winPath.fill()

        let barHeight = win.height * 0.24
        NSGraphicsContext.saveGraphicsState()
        winPath.addClip()
        NSColor.white.withAlphaComponent(0.09).setFill()
        NSRect(x: win.minX, y: win.maxY - barHeight, width: win.width, height: barHeight).fill()
        NSGraphicsContext.restoreGraphicsState()

        let dot = barHeight * 0.34
        NSColor.white.withAlphaComponent(0.22).setFill()
        for i in 0..<3 {
            let x = win.minX + barHeight * 0.55 + CGFloat(i) * dot * 1.7
            NSBezierPath(ovalIn: NSRect(x: x, y: win.maxY - barHeight / 2 - dot / 2, width: dot, height: dot)).fill()
        }
    }

    // Command symbol, top left.
    let config = NSImage.SymbolConfiguration(pointSize: cell * 0.78, weight: .bold)
        .applying(.init(paletteColors: [.white]))
    if let cmd = NSImage(systemSymbolName: "command", accessibilityDescription: nil)?.withSymbolConfiguration(config) {
        let fit = cmd.size
        cmd.draw(in: NSRect(x: topLeft.midX - fit.width / 2, y: topLeft.midY - fit.height / 2, width: fit.width, height: fit.height))
    }

    // Stylized H, bottom right: two rounded posts and a raised accent crossbar.
    let h = bottomRight.insetBy(dx: cell * 0.16, dy: cell * 0.12)
    let post = h.width * 0.27
    let radius = post / 2
    NSColor.white.setFill()
    NSBezierPath(roundedRect: NSRect(x: h.minX, y: h.minY, width: post, height: h.height), xRadius: radius, yRadius: radius).fill()
    NSBezierPath(roundedRect: NSRect(x: h.maxX - post, y: h.minY, width: post, height: h.height), xRadius: radius, yRadius: radius).fill()
    let bar = NSRect(x: h.minX + post * 0.5, y: h.minY + h.height * 0.5 - post * 0.425, width: h.width - post, height: post * 0.85)
    NSColor(srgbRed: 1.0, green: 0.58, blue: 0.20, alpha: 1).setFill()
    NSBezierPath(roundedRect: bar, xRadius: bar.height / 2, yRadius: bar.height / 2).fill()

    NSGraphicsContext.restoreGraphicsState()
    return rep
}

let fm = FileManager.default
let iconset = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("AppIcon.iconset")
try? fm.removeItem(at: iconset)
try! fm.createDirectory(at: iconset, withIntermediateDirectories: true)

for base in [16, 32, 128, 256, 512] {
    for scale in [1, 2] {
        let name = scale == 1 ? "icon_\(base)x\(base).png" : "icon_\(base)x\(base)@2x.png"
        let png = render(size: CGFloat(base * scale)).representation(using: .png, properties: [:])!
        try! png.write(to: iconset.appendingPathComponent(name))
    }
}
try! fm.createDirectory(atPath: "Resources", withIntermediateDirectories: true)
try! render(size: 1024).representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "Resources/AppIcon-1024.png"))

let task = Process()
task.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
task.arguments = ["-c", "icns", iconset.path, "-o", "Resources/AppIcon.icns"]
try! task.run()
task.waitUntilExit()
print(task.terminationStatus == 0 ? "Wrote Resources/AppIcon.icns" : "iconutil failed")
