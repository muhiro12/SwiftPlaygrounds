import SwiftUI

extension Route {
    var title: String {
        switch self {
        case .stateComparison:
            return "State Comparison"
        case .photoRef:
            return "Photo Refs"
        case .keychainLab:
            return "Keychain Lab"
        case .hybridTextField:
            return "Hybrid Text Field"
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
        default:
            return rawValue.camelCased()
        }
    }

    var tags: [any Tag] {
        RouteRegistry.definition(for: self).tags
    }

    var primaryTag: (any Tag)? {
        tags.first
    }

    var view: some View {
        RouteRegistry.definition(for: self).viewBuilder()
    }
}
