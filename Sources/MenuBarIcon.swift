import AppKit

/// Menu bar version of the app icon: a 2x2 grid with the Command symbol top
/// left, the H bottom right, and faint empty tiles in the other two cells.
/// Drawn as a template image so macOS tints it for light, dark and highlight.
func makeMenuBarIcon() -> NSImage {
    let side: CGFloat = 18
    let image = NSImage(size: NSSize(width: side, height: side), flipped: true) { _ in
        let gap: CGFloat = 1.5
        let cell = (side - gap) / 2
        let topLeft = NSRect(x: 0, y: 0, width: cell, height: cell)
        let bottomRight = NSRect(x: cell + gap, y: cell + gap, width: cell, height: cell)

        // Empty tiles: top right and bottom left.
        NSColor.black.withAlphaComponent(0.3).setFill()
        for r in [NSRect(x: cell + gap, y: 0, width: cell, height: cell),
                  NSRect(x: 0, y: cell + gap, width: cell, height: cell)] {
            NSBezierPath(roundedRect: r.insetBy(dx: 0.75, dy: 0.75), xRadius: 1.75, yRadius: 1.75).fill()
        }

        // Command symbol.
        let config = NSImage.SymbolConfiguration(pointSize: cell * 0.95, weight: .bold)
        if let cmd = NSImage(systemSymbolName: "command", accessibilityDescription: nil)?.withSymbolConfiguration(config) {
            let scale = min(topLeft.width / cmd.size.width, topLeft.height / cmd.size.height)
            let w = cmd.size.width * scale, h = cmd.size.height * scale
            cmd.draw(in: NSRect(x: topLeft.midX - w / 2, y: topLeft.midY - h / 2, width: w, height: h))
        }

        // H: two rounded posts and a crossbar.
        NSColor.black.setFill()
        let hRect = bottomRight.insetBy(dx: 0.9, dy: 0.4)
        let post: CGFloat = 1.9
        NSBezierPath(roundedRect: NSRect(x: hRect.minX, y: hRect.minY, width: post, height: hRect.height), xRadius: post / 2, yRadius: post / 2).fill()
        NSBezierPath(roundedRect: NSRect(x: hRect.maxX - post, y: hRect.minY, width: post, height: hRect.height), xRadius: post / 2, yRadius: post / 2).fill()
        NSBezierPath(rect: NSRect(x: hRect.minX + post, y: hRect.midY - 0.85, width: hRect.width - post * 2, height: 1.7)).fill()
        return true
    }
    image.isTemplate = true
    image.accessibilityDescription = "CommandH"
    return image
}
