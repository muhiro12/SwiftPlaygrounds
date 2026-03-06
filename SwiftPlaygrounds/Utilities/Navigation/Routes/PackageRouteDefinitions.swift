import SwiftUI

enum PackageRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .keychainLab,
            tags: [CategoryTag.package, FeatureTag.keychain],
            viewBuilder: { AnyView(KeychainLabView()) }
        )
    ]
}
