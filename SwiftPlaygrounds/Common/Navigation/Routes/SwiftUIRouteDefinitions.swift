import SwiftUI

enum SwiftUIRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .infiniteCarousel,
            tags: [CategoryTag.swiftUI, FeatureTag.layout],
            viewBuilder: { AnyView(InfiniteCarouselView()) }
        ),
        RouteDefinition(
            route: .modifier,
            tags: [CategoryTag.swiftUI, FeatureTag.modifier],
            viewBuilder: { AnyView(ModifierView()) }
        ),
        RouteDefinition(
            route: .sampleContent,
            tags: [CategoryTag.swiftUI, FeatureTag.sample],
            viewBuilder: { AnyView(SampleContentView()) }
        ),
        RouteDefinition(
            route: .hybridTextField,
            tags: [CategoryTag.swiftUI, FeatureTag.hybrid],
            viewBuilder: { AnyView(HybridTextFieldView()) }
        ),
        RouteDefinition(
            route: .transition,
            tags: [CategoryTag.swiftUI, FeatureTag.transition],
            viewBuilder: { AnyView(TransitionView()) }
        ),
        RouteDefinition(
            route: .deepLinkDemo,
            tags: [CategoryTag.swiftUI, FeatureTag.webView],
            viewBuilder: { AnyView(DeepLinkDemoView()) }
        )
    ]
}
