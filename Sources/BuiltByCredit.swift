import AppKit
import SwiftUI

/// "Built by Matt Senter", with the name linking to his site. Used in the
/// settings sidebar footer and the About pane; `content` is the `utm_content`
/// tag that tells the two apart.
struct BuiltByCredit: View {
    let content: String

    static func url(content: String) -> URL? {
        OutboundLink.url("https://www.mattsenter.com/from-commandh", campaign: "built-by", content: content)
    }

    var body: some View {
        HStack(spacing: 0) {
            Text("Built by ")
            // Its own button so it gets the pointing-hand cursor.
            Button {
                if let url = Self.url(content: content) { NSWorkspace.shared.open(url) }
            } label: {
                Text("Matt Senter").underline().foregroundStyle(Brand.accent)
            }
            .buttonStyle(.plain)
            .pointingHandCursor()
            .accessibilityAddTraits(.isLink)
        }
        .font(.system(size: 11))
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
}

/// "Copyright © 2026 Senternet LLC", with the company linking to its site.
struct CopyrightLine: View {
    var body: some View {
        Text(Self.text)
            .font(.system(size: 10))
            .foregroundStyle(.secondary)
            .tint(Brand.accent)
            .lineLimit(1)
            .minimumScaleFactor(0.85)
    }

    private static var text: AttributedString {
        let line = AttributedString("Copyright © 2026 ")
        var company = AttributedString("Senternet LLC")
        company.link = OutboundLink.url("https://www.senter.net/from-commandh", campaign: "built-by", content: "settings")
        return line + company
    }
}

extension View {
    /// The pointing-hand cursor over a link-like control, which `.plain`
    /// buttons don't get on their own.
    func pointingHandCursor() -> some View {
        onHover { inside in
            if inside { NSCursor.pointingHand.push() } else { NSCursor.pop() }
        }
    }
}
