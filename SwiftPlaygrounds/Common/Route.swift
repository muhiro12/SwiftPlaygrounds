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
            [.logic, .combine]
        case .authentication:
            [.logic, .common]
        case .actor,
             .asyncStream:
            [.logic, .concurrency]
        case .observationUserList,
             .observationUser,
             .observableObjectUserList,
             .observableObjectUser,
             .publishedUserList,
             .publishedUser:
            [.logic, .observation]
        case .student:
            [.logic, .swiftData]
        case .groupingUserList,
             .userList,
             .user:
            [.logic, .user]
        case .keychainAccess:
            [.package, .keychain]
        case .infiniteCarousel:
            [.swiftUI, .layout]
        case .modifier:
            [.swiftUI, .modifier]
        case .sampleContent:
            [.swiftUI, .sample]
        case .hybridTextField:
            [.swiftUI, .hybrid]
        case .transition:
            [.swiftUI, .transition]
        case .collection:
            [.uiKit, .collection]
        case .secure:
            [.uiKit, .common, .secure]
        case .compositional:
            [.uiKit, .compositional]
        case .infiniteCompositional,
             .infinitePaging:
            [.uiKit, .infinitePaging]
        case .storyboard:
            [.uiKit, .storyboard]
        case .table:
            [.uiKit, .table]
        case .webView:
            [.uiKit, .webView]
        case .navigationBug:
            [.uiKit, .navigation]
        case .random:
            [.logic, .common]
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
