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
    case common = "Common"
    case stateManagement = "State Management"
    case swiftData = "SwiftData"
    case keychain = "Keychain"
    case hybrid = "Hybrid"
    case navigation = "Navigation"
    case webView = "WebView"
    case secure = "Secure"
}
