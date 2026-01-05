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
    case keychainBiometryDebug
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
    case deepLinkDemo

    static var preferRoutes: [Route] {
        [.deepLinkDemo, .keychainBiometryDebug, .hybridTextField, .navigationBug]
    }

    var title: String {
        rawValue.camelCased()
    }

    var tags: [any Tag] {
        switch self {
        case .combineDetail,
             .combine:
            [CategoryTag.logic, FeatureTag.combine]
        case .authentication:
            [CategoryTag.logic, FeatureTag.common]
        case .actor,
             .asyncStream:
            [CategoryTag.logic, FeatureTag.concurrency]
        case .observationUserList,
             .observationUser,
             .observableObjectUserList,
             .observableObjectUser,
             .publishedUserList,
             .publishedUser:
            [CategoryTag.logic, FeatureTag.observation]
        case .student:
            [CategoryTag.logic, FeatureTag.swiftData]
        case .groupingUserList,
             .userList,
             .user:
            [CategoryTag.logic, FeatureTag.user]
        case .keychainBiometryDebug,
             .keychainAccess:
            [CategoryTag.package, FeatureTag.keychain]
        case .infiniteCarousel:
            [CategoryTag.swiftUI, FeatureTag.layout]
        case .modifier:
            [CategoryTag.swiftUI, FeatureTag.modifier]
        case .sampleContent:
            [CategoryTag.swiftUI, FeatureTag.sample]
        case .hybridTextField:
            [CategoryTag.swiftUI, FeatureTag.hybrid]
        case .transition:
            [CategoryTag.swiftUI, FeatureTag.transition]
        case .collection:
            [CategoryTag.uiKit, FeatureTag.collection]
        case .secure:
            [CategoryTag.uiKit, FeatureTag.common, FeatureTag.secure]
        case .compositional:
            [CategoryTag.uiKit, FeatureTag.compositional]
        case .infiniteCompositional,
             .infinitePaging:
            [CategoryTag.uiKit, FeatureTag.infinitePaging]
        case .storyboard:
            [CategoryTag.uiKit, FeatureTag.storyboard]
        case .table:
            [CategoryTag.uiKit, FeatureTag.table]
        case .webView:
            [CategoryTag.uiKit, FeatureTag.webView]
        case .navigationBug:
            [CategoryTag.uiKit, FeatureTag.navigation]
        case .deepLinkDemo:
            [CategoryTag.swiftUI, FeatureTag.webView]
        case .random:
            [CategoryTag.logic, FeatureTag.common]
        }
    }

    var primaryTag: (any Tag)? {
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
        case .keychainBiometryDebug:
            KeychainBiometryDebugView()
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
        case .deepLinkDemo:
            DeepLinkDemoView()
        case .random:
            RandomView()
        }
    }
}
