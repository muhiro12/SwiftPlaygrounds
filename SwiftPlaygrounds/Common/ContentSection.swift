enum Tag: String, CaseIterable, Identifiable {
    case logic = "Logic"
    case combine = "Combine"
    case common = "Common"
    case concurrency = "Concurrency"
    case observation = "Observation"
    case swiftData = "SwiftData"
    case user = "User"
    case package = "Package"
    case keychain = "Keychain"
    case swiftUI = "SwiftUI"
    case layout = "Layout"
    case modifier = "Modifier"
    case sample = "Sample"
    case hybrid = "Hybrid"
    case transition = "Transition"
    case uiKit = "UIKit"
    case collection = "Collection"
    case compositional = "Compositional"
    case infinitePaging = "Infinite Paging"
    case navigation = "Navigation"
    case storyboard = "Storyboard"
    case table = "Table"
    case webView = "WebView"
    case secure = "Secure"

    var id: String {
        rawValue
    }

    var title: String {
        rawValue
    }
}
