import SwiftUI

struct RouteDefinition {
    let route: Route
    let tags: [any Tag]
    let viewBuilder: () -> AnyView
}
