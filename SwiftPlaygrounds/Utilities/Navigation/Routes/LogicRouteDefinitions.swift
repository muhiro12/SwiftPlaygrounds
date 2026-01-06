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
            route: .authentication,
            tags: [CategoryTag.logic, FeatureTag.common],
            viewBuilder: { AnyView(AuthenticationView()) }
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
            route: .observationUserList,
            tags: [CategoryTag.logic, FeatureTag.observation],
            viewBuilder: { AnyView(ObservationUserListView()) }
        ),
        RouteDefinition(
            route: .observationUser,
            tags: [CategoryTag.logic, FeatureTag.observation],
            viewBuilder: { AnyView(ObservationUserView()) }
        ),
        RouteDefinition(
            route: .observableObjectUserList,
            tags: [CategoryTag.logic, FeatureTag.observation],
            viewBuilder: { AnyView(ObservableObjectUserListView()) }
        ),
        RouteDefinition(
            route: .observableObjectUser,
            tags: [CategoryTag.logic, FeatureTag.observation],
            viewBuilder: { AnyView(ObservableObjectUserView()) }
        ),
        RouteDefinition(
            route: .publishedUserList,
            tags: [CategoryTag.logic, FeatureTag.observation],
            viewBuilder: { AnyView(PublishedUserListView()) }
        ),
        RouteDefinition(
            route: .publishedUser,
            tags: [CategoryTag.logic, FeatureTag.observation],
            viewBuilder: { AnyView(PublishedUserView()) }
        ),
        RouteDefinition(
            route: .student,
            tags: [CategoryTag.logic, FeatureTag.swiftData],
            viewBuilder: { AnyView(StudentView()) }
        ),
        RouteDefinition(
            route: .groupingUserList,
            tags: [CategoryTag.logic, FeatureTag.user],
            viewBuilder: { AnyView(GroupingUserListView()) }
        ),
        RouteDefinition(
            route: .userList,
            tags: [CategoryTag.logic, FeatureTag.user],
            viewBuilder: { AnyView(UserListView()) }
        ),
        RouteDefinition(
            route: .user,
            tags: [CategoryTag.logic, FeatureTag.user],
            viewBuilder: { AnyView(UserView()) }
        ),
        RouteDefinition(
            route: .random,
            tags: [CategoryTag.logic, FeatureTag.common],
            viewBuilder: { AnyView(RandomView()) }
        )
    ]
}
