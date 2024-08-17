import SwiftUI

enum Sidebar: String, CaseIterable {
    case all
    case logic
    case package
    case swiftUI
    case uiKit
    
    var title: String {
        rawValue.camelCased()
    }

    var contentSections: [any ContentSection] {
        switch self {
        case .all:
            AllSection.allCases
        case .logic:
            LogicSection.allCases
        case .package:
            PackageSection.allCases
        case .swiftUI:
            SwiftUISection.allCases
        case .uiKit:
            UIKitSection.allCases
        }
    }
}
