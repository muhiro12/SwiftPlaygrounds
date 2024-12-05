import SwiftUI

enum SwiftUISection: String, ContentSection {
    case modifier
    case sample
    case transition
    
    var contents: [Route] {
        switch self {
        case .modifier:
            [.modifier]
        case .sample:
            [.sampleContent]
        case .transition:
            [.transition]
        }
    }
}