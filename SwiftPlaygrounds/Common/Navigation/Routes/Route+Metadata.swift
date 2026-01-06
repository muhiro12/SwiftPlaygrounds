import SwiftUI

extension Route {
    var title: String {
        rawValue.camelCased()
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
