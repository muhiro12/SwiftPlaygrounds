import SwiftUI

enum Route: String, CaseIterable {
    case sampleContent
    case modifier
    case userList
    case user
    case observationUserList
    case observationUser
    case observableObjectUserList
    case observableObjectUser
    case publishedUserList
    case publishedUser
    case storyboard
    case table
    case collection
    case compositional
    case combine
    case combineDetail
    case asyncStream
    case actor
    case student
    case keychainAccess
    case transition
    case infinitePaging
    case infiniteCompositional
    case webView
    case toolbarWebView
    case infiniteCarousel
    case groupingUserList
    case secure

    var title: String {
        rawValue.camelCased()
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .sampleContent:
            SampleContentView()
        case .modifier:
            ModifierView()
        case .userList:
            UserListView()
        case .user:
            UserView()
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
        case .storyboard:
            StoryboardView()
        case .table:
            TableView()
        case .collection:
            CollectionView()
        case .compositional:
            CompositionalView()
        case .combine:
            CombineView()
        case .combineDetail:
            CombineDetailView()
        case .asyncStream:
            AsyncStreamView()
        case .actor:
            ActorView()
        case .student:
            StudentView()
        case .keychainAccess:
            KeychainAccessView()
        case .transition:
            TransitionView()
        case .infinitePaging:
            InfinitePagingView()
        case .infiniteCompositional:
            InfiniteCompositionalView()
        case .webView:
            WebView()
        case .toolbarWebView:
            ToolbarWebView()
        case .infiniteCarousel:
            InfiniteCarouselView()
        case .groupingUserList:
            GroupingUserListView()
        case .secure:
            SecureView()
        }
    }
}
