import SwiftUI
import Combine

enum DeepLink {
    static let scheme = "playgrounds"

    static func shouldPresentAlert(for url: URL) -> Bool {
        guard url.scheme?.lowercased() == scheme else {
            return false
        }
        return url.host?.lowercased() == "alert"
    }

    static func route(from url: URL) -> Route? {
        guard url.scheme?.lowercased() == scheme else {
            return nil
        }

        let host = url.host?.trimmingCharacters(in: .init(charactersIn: "/")) ?? ""
        let pathComponents = url.pathComponents.filter { $0 != "/" }

        var candidates: [String] = []
        if host == "route" || host.isEmpty {
            candidates.append(contentsOf: pathComponents)
        } else {
            candidates.append(host)
            candidates.append(contentsOf: pathComponents)
        }

        for candidate in candidates where !candidate.isEmpty {
            if let route = Route(deepLinkIdentifier: candidate) {
                return route
            }
        }

        return nil
    }
}

final class DeepLinkNavigator: ObservableObject {
    @Published var selection: Route? = .photoRef

    @discardableResult
    func handle(url: URL) -> Bool {
        guard let route = DeepLink.route(from: url) else {
            return false
        }
        selection = route
        return true
    }
}

private extension Route {
    init?(deepLinkIdentifier: String) {
        let normalizedIdentifier = Self.normalize(deepLinkIdentifier)
        guard let route = Self.allCases.first(where: {
            Self.normalize($0.rawValue) == normalizedIdentifier
        }) else {
            return nil
        }
        self = route
    }

    static func normalize(_ value: String) -> String {
        value
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "_", with: "")
            .lowercased()
    }
}
