import SwiftUI

enum UIKitRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .collectionCompositionalLab,
            tags: [CategoryTag.uiKit, FeatureTag.collection, FeatureTag.compositional],
            viewBuilder: { AnyView(CollectionCompositionalLabView()) }
        ),
        RouteDefinition(
            route: .secure,
            tags: [CategoryTag.uiKit, FeatureTag.common, FeatureTag.secure],
            viewBuilder: { AnyView(SecureView()) }
        ),
        RouteDefinition(
            route: .infiniteScrollingLab,
            tags: [CategoryTag.uiKit, FeatureTag.layout, FeatureTag.infinitePaging],
            viewBuilder: { AnyView(InfiniteScrollingLabView()) }
        ),
        RouteDefinition(
            route: .storyboard,
            tags: [CategoryTag.uiKit, FeatureTag.storyboard],
            viewBuilder: { AnyView(StoryboardView()) }
        ),
        RouteDefinition(
            route: .table,
            tags: [CategoryTag.uiKit, FeatureTag.table],
            viewBuilder: { AnyView(TableView()) }
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
