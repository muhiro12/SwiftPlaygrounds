protocol Tag: Identifiable {
    var title: String { get }
    var id: String { get }
}

extension Tag where Self: RawRepresentable, RawValue == String {
    var id: String {
        rawValue
    }

    var title: String {
        rawValue
    }
}

enum CategoryTag: String, CaseIterable, Identifiable, Tag {
    case logic = "Logic"
    case package = "Package"
    case swiftUI = "SwiftUI"
    case uiKit = "UIKit"
}

enum FeatureTag: String, CaseIterable, Identifiable, Tag {
    case combine = "Combine"
    case common = "Common"
    case concurrency = "Concurrency"
    case observation = "Observation"
    case swiftData = "SwiftData"
    case user = "User"
    case keychain = "Keychain"
    case layout = "Layout"
    case modifier = "Modifier"
    case sample = "Sample"
    case hybrid = "Hybrid"
    case transition = "Transition"
    case collection = "Collection"
    case compositional = "Compositional"
    case infinitePaging = "Infinite Paging"
    case navigation = "Navigation"
    case storyboard = "Storyboard"
    case table = "Table"
    case webView = "WebView"
    case secure = "Secure"
}
