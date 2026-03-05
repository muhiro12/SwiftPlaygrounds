import SwiftUI

extension Route {
    var title: String {
        switch self {
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
