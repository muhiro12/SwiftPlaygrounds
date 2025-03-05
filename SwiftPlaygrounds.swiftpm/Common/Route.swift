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
    case transition
    case collection
    case secure
    case compositional
    case infiniteCompositional
    case infinitePaging
    case storyboard
    case table
    case webView
    case random

    static var preferRoutes: [Route] {
        [.random]
    }

    var title: String {
        rawValue.camelCased()
    }

    var section: any ContentSection {
        switch self {
        case .combineDetail,
             .combine:
            LogicSection.combine
        case .authentication:
            LogicSection.common
        case .actor,
             .asyncStream:
            LogicSection.concurrency
        case .observationUserList,
             .observationUser,
             .observableObjectUserList,
             .observableObjectUser,
             .publishedUserList,
             .publishedUser:
            LogicSection.observation
        case .student:
            LogicSection.swiftData
        case .groupingUserList,
             .userList,
             .user:
            LogicSection.user
        case .keychainAccess:
            PackageSection.keychainAccess
        case .infiniteCarousel:
            SwiftUISection.layout
        case .modifier:
            SwiftUISection.modifier
        case .sampleContent:
            SwiftUISection.sample
        case .transition:
            SwiftUISection.transition
        case .collection:
            UIKitSection.collection
        case .secure:
            UIKitSection.common
        case .compositional:
            UIKitSection.compositional
        case .infiniteCompositional,
             .infinitePaging:
            UIKitSection.infinitePaging
        case .storyboard:
            UIKitSection.storyboard
        case .table:
            UIKitSection.table
        case .webView:
            UIKitSection.webView
        case .random:
            LogicSection.common
        }
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
        case .random:
            RandomView()
        }
    }
}
