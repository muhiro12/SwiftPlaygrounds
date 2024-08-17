import SwiftUI

enum PackageSection: String, ContentSection {
    case keychainAccess
    
    var contents: [Route] {
        switch self {
        case .keychainAccess:
            [.keychainAccess]
        }
    }
}
