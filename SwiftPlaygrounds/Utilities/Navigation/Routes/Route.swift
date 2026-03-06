enum Route: String, CaseIterable {
    case stateComparison
    case photoRef
    case keychainLab
    case hybridTextField
    case secure
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
