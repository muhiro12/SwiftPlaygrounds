import SwiftUI

enum UIKitRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .secure,
            tags: [CategoryTag.uiKit, FeatureTag.common, FeatureTag.secure],
            viewBuilder: { AnyView(SecureView()) }
        ),
        RouteDefinition(
            route: .flashTest,
            tags: [CategoryTag.uiKit, FeatureTag.webView],
            viewBuilder: { AnyView(FlashTestView()) }
        ),
        RouteDefinition(
            route: .realmSettings,
            tags: [CategoryTag.uiKit, FeatureTag.common],
            viewBuilder: { AnyView(RealmSettingsView()) }
        ),
        RouteDefinition(
            route: .navigationBug,
            tags: [CategoryTag.uiKit, FeatureTag.navigation],
            viewBuilder: { AnyView(NavigationBugView()) }
        )
    ]
}
