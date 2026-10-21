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
        // The name's place in the sentence depends on the language.
        let parts = String(localized: "Built by %@", comment: "Credit line. The argument is the developer's name, Matt Senter, which links to his site.")
            .components(separatedBy: "%@")
        HStack(spacing: 0) {
            Text(verbatim: parts[0])
            // Its own button so it gets the pointing-hand cursor.
            Button {
                if let url = Self.url(content: content) { NSWorkspace.shared.open(url) }
            } label: {
                Text(verbatim: "Matt Senter").underline().foregroundStyle(Brand.accent)
            }
            .buttonStyle(.plain)
            .pointingHandCursor()
            .accessibilityAddTraits(.isLink)
            if parts.count > 1 { Text(verbatim: parts[1]) }
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
        let parts = String(localized: "Copyright © 2026 %@", comment: "Copyright line. The argument is the company name, Senternet LLC, which links to its site.")
            .components(separatedBy: "%@")
        var company = AttributedString("Senternet LLC")
        company.link = OutboundLink.url("https://www.senter.net/from-commandh", campaign: "built-by", content: "settings")
        return AttributedString(parts[0]) + company + AttributedString(parts.count > 1 ? parts[1] : "")
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
