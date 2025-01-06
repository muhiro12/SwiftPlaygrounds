import SwiftUI

enum UIKitSection: String, ContentSection {
    case common
    case collection
    case compositional
    case infinitePaging
    case storyboard
    case table
    case webView

    var contents: [Route] {
        switch self {
        case .common:
            [.secure]
        case .collection:
            [.collection]
        case .compositional:
            [.compositional]
        case .infinitePaging:
            [.infiniteCompositional,
             .infinitePaging]
        case .storyboard:
            [.storyboard]
        case .table:
            [.table]
        case .webView:
            [.webView,
             .toolbarWebView]
        }
    }
}
