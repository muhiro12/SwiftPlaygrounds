import SwiftUI

enum UIKitRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .collection,
            tags: [CategoryTag.uiKit, FeatureTag.collection],
            viewBuilder: { AnyView(CollectionView()) }
        ),
        RouteDefinition(
            route: .secure,
            tags: [CategoryTag.uiKit, FeatureTag.common, FeatureTag.secure],
            viewBuilder: { AnyView(SecureView()) }
        ),
        RouteDefinition(
            route: .compositional,
            tags: [CategoryTag.uiKit, FeatureTag.compositional],
            viewBuilder: { AnyView(CompositionalView()) }
        ),
        RouteDefinition(
            route: .infiniteCompositional,
            tags: [CategoryTag.uiKit, FeatureTag.infinitePaging],
            viewBuilder: { AnyView(InfiniteCompositionalView()) }
        ),
        RouteDefinition(
            route: .infinitePaging,
            tags: [CategoryTag.uiKit, FeatureTag.infinitePaging],
            viewBuilder: { AnyView(InfinitePagingView()) }
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
            route: .webView,
            tags: [CategoryTag.uiKit, FeatureTag.webView],
            viewBuilder: { AnyView(WebView()) }
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
