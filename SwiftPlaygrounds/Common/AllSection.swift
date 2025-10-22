import SwiftUI

enum AllSection: String, ContentSection {
    case all

    var contents: [Route] {
        switch self {
        case .all:
            Route.preferRoutes + Route.allCases.filter {
                !Route.preferRoutes.contains($0)
            }
        }
    }
}
