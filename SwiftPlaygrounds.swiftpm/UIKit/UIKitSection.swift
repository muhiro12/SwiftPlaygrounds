import SwiftUI

enum UIKitSection: String, ContentSection {
    case collection
    case compositional
    case infinitePaging
    case storyboard
    case table
    case webView
    
    var contents: [Route] {
        switch self {
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
