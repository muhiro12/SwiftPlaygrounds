import SwiftUI

enum LogicRouteDefinitions {
    static let all: [RouteDefinition] = [
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
