import Foundation

/// Links from CommandH to other Senternet sites, tagged so each site can tell
/// the visit came from this app. Senternet-owned sites are linked at their
/// `/from-commandh` lander; external ones (BeeReady, SeedMatrix) at the root.
enum OutboundLink {
    static func url(_ base: String, campaign: String, content: String) -> URL? {
        guard var components = URLComponents(string: base) else { return nil }
        var items = components.queryItems ?? []
        items += [URLQueryItem(name: "utm_source", value: "commandh"),
                  URLQueryItem(name: "utm_medium", value: "referral"),
                  URLQueryItem(name: "utm_campaign", value: campaign),
                  URLQueryItem(name: "utm_content", value: content)]
        components.queryItems = items
        return components.url
    }
}
