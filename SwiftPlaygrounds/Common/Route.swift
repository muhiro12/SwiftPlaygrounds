import SwiftUI

enum Route: String, CaseIterable {
    case combineDetail
    case combine
    case authentication
    case actor
    case asyncStream
    case observationUserList
    case observationUser
    case observableObjectUserList
    case observableObjectUser
    case publishedUserList
    case publishedUser
    case student
    case groupingUserList
    case userList
    case user
    case keychainAccess
    case infiniteCarousel
    case modifier
    case sampleContent
    case hybridTextField
    case transition
    case collection
    case secure
    case compositional
    case infiniteCompositional
    case infinitePaging
    case storyboard
    case table
    case webView
    case navigationBug
    case random

    static var preferRoutes: [Route] {
        [.hybridTextField, .navigationBug]
    }

    var title: String {
        rawValue.camelCased()
    }

    var tags: [Tag] {
        switch self {
        case .combineDetail,
             .combine:
            [.logicCombine]
        case .authentication:
            [.logicCommon]
        case .actor,
             .asyncStream:
            [.logicConcurrency]
        case .observationUserList,
             .observationUser,
             .observableObjectUserList,
             .observableObjectUser,
             .publishedUserList,
             .publishedUser:
            [.logicObservation]
        case .student:
            [.logicSwiftData]
        case .groupingUserList,
             .userList,
             .user:
            [.logicUser]
        case .keychainAccess:
            [.packageKeychain]
        case .infiniteCarousel:
            [.swiftUILayout]
        case .modifier:
            [.swiftUIModifier]
        case .sampleContent:
            [.swiftUISample]
        case .hybridTextField:
            [.swiftUIHybrid]
        case .transition:
            [.swiftUITransition]
        case .collection:
            [.uiKitCollection]
        case .secure:
            [.uiKitCommon]
        case .compositional:
            [.uiKitCompositional]
        case .infiniteCompositional,
             .infinitePaging:
            [.uiKitInfinitePaging]
        case .storyboard:
            [.uiKitStoryboard]
        case .table:
            [.uiKitTable]
        case .webView:
            [.uiKitWebView]
        case .navigationBug:
            [.uiKitNavigation]
        case .random:
            [.logicCommon]
        }
    }

    var primaryTag: Tag? {
        tags.first
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .combineDetail:
            CombineDetailView()
        case .combine:
            CombineView()
        case .authentication:
            AuthenticationView()
        case .actor:
            ActorView()
        case .asyncStream:
            AsyncStreamView()
        case .observationUserList:
            ObservationUserListView()
        case .observationUser:
            ObservationUserView()
        case .observableObjectUserList:
            ObservableObjectUserListView()
        case .observableObjectUser:
            ObservableObjectUserView()
        case .publishedUserList:
            PublishedUserListView()
        case .publishedUser:
            PublishedUserView()
        case .student:
            StudentView()
        case .groupingUserList:
            GroupingUserListView()
        case .userList:
            UserListView()
        case .user:
            UserView()
        case .keychainAccess:
            KeychainAccessView()
        case .infiniteCarousel:
            InfiniteCarouselView()
        case .modifier:
            ModifierView()
        case .sampleContent:
            SampleContentView()
        case .hybridTextField:
            HybridTextFieldView()
        case .transition:
            TransitionView()
        case .collection:
            CollectionView()
        case .secure:
            SecureView()
        case .compositional:
            CompositionalView()
        case .infiniteCompositional:
            InfiniteCompositionalView()
        case .infinitePaging:
            InfinitePagingView()
        case .storyboard:
            StoryboardView()
        case .table:
            TableView()
        case .webView:
            WebView()
        case .navigationBug:
            NavigationBugView()
        case .random:
            RandomView()
        }
    }
}
