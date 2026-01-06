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
}
