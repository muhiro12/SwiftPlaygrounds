import SwiftUI

extension Route {
    var title: String {
        switch self {
        case .combineConcurrencyLab:
            return "Combine / Concurrency Lab"
        case .stateComparison:
            return "State Comparison"
        case .photoRef:
            return "Photo Refs"
        case .keychainLab:
            return "Keychain Lab"
        case .collectionCompositionalLab:
            return "Collection / Compositional Lab"
        case .hybridTextField:
            return "Hybrid Text Field"
        case .textFieldSizingLab:
            return "Text Field Sizing Lab"
        case .infiniteScrollingLab:
            return "Infinite Scrolling Lab"
        case .flashTest:
            return "Flash Test"
        case .realmSettings:
            return "Realm Settings"
        case .navigationBug:
            return "Navigation Bug"
        case .webIntegration:
            return "Web Integration"
        case .pdfPoC:
            return "PDF PoC"
        case .typographyLab:
            return "Typography Lab"
        case .ticketSlideLab:
            return "Ticket Slide Lab"
        default:
            return rawValue.camelCased()
        }
    }

    var tags: [any Tag] {
        RouteRegistry.definition(for: self).tags
    }

    var deepLinkIdentifiers: [String] {
        switch self {
        case .combineConcurrencyLab:
            return [rawValue, "combine", "combineDetail", "actor", "asyncStream"]
        case .collectionCompositionalLab:
            return [rawValue, "collection", "compositional"]
        case .infiniteScrollingLab:
            return [rawValue, "infiniteCarousel", "infiniteCompositional", "infinitePaging"]
        default:
            return [rawValue]
        }
    }

    var searchKeywords: [String] {
        [title] + deepLinkIdentifiers + tags.map { $0.title }
    }

    var primaryTag: (any Tag)? {
        tags.first
    }

    var view: some View {
        RouteRegistry.definition(for: self).viewBuilder()
    }

    func matchesSearch(_ query: String) -> Bool {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return true
        }
        let normalizedQuery = Self.normalizeMatchTerm(trimmedQuery)
        return searchKeywords.contains { keyword in
            keyword.localizedCaseInsensitiveContains(trimmedQuery)
                || Self.normalizeMatchTerm(keyword).contains(normalizedQuery)
        }
    }

    init?(deepLinkIdentifier: String) {
        let normalizedIdentifier = Self.normalizeMatchTerm(deepLinkIdentifier)
        guard let route = Self.allCases.first(where: { route in
            route.deepLinkIdentifiers.contains { identifier in
                Self.normalizeMatchTerm(identifier) == normalizedIdentifier
            }
        }) else {
            return nil
        }
        self = route
    }

    static func normalizeMatchTerm(_ value: String) -> String {
        value
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
    }
}
