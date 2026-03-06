import SwiftUI

enum LogicRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .combineDetail,
            tags: [CategoryTag.logic, FeatureTag.combine],
            viewBuilder: { AnyView(CombineDetailView()) }
        ),
        RouteDefinition(
            route: .combine,
            tags: [CategoryTag.logic, FeatureTag.combine],
            viewBuilder: { AnyView(CombineView()) }
        ),
        RouteDefinition(
            route: .actor,
            tags: [CategoryTag.logic, FeatureTag.concurrency],
            viewBuilder: { AnyView(ActorView()) }
        ),
        RouteDefinition(
            route: .asyncStream,
            tags: [CategoryTag.logic, FeatureTag.concurrency],
            viewBuilder: { AnyView(AsyncStreamView()) }
        ),
        RouteDefinition(
            route: .stateComparison,
            tags: [CategoryTag.logic, FeatureTag.stateManagement],
            viewBuilder: { AnyView(StateComparisonView()) }
        ),
        RouteDefinition(
            route: .photoRef,
            tags: [CategoryTag.logic, FeatureTag.swiftData],
            viewBuilder: { AnyView(PhotoRefListView()) }
        )
    ]
}
