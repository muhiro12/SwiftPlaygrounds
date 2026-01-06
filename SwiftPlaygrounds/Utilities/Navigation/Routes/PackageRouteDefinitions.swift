import SwiftUI

enum PackageRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .keychainBiometryDebug,
            tags: [CategoryTag.package, FeatureTag.keychain],
            viewBuilder: { AnyView(KeychainBiometryDebugView()) }
        ),
        RouteDefinition(
            route: .keychainAccess,
            tags: [CategoryTag.package, FeatureTag.keychain],
            viewBuilder: { AnyView(KeychainAccessView()) }
        )
    ]
}
