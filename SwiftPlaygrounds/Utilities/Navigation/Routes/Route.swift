enum Route: String, CaseIterable {
    case combineConcurrencyLab
    case stateComparison
    case photoRef
    case keychainLab
    case collectionCompositionalLab
    case hybridTextField
    case textFieldSizingLab
    case secure
    case infiniteScrollingLab
    case storyboard
    case table
    case flashTest
    case realmSettings
    case navigationBug
    case webIntegration
    case pdfPoC
    case typographyLab

    static var preferRoutes: [Route] {
        [.textFieldSizingLab, .typographyLab]
    }
}
