enum Route: String, CaseIterable {
    case combineDetail
    case combine
    case actor
    case asyncStream
    case stateComparison
    case photoRef
    case keychainLab
    case infiniteCarousel
    case hybridTextField
    case collection
    case secure
    case compositional
    case infiniteCompositional
    case infinitePaging
    case storyboard
    case table
    case flashTest
    case realmSettings
    case navigationBug
    case webIntegration
    case pdfPoC
    case typographyLab

    static var preferRoutes: [Route] {
        [.typographyLab]
    }
}
