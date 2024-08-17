import SwiftUI

protocol ContentSection: RawRepresentable, CaseIterable, Identifiable where RawValue == String {
    var title: String { get }
    var contents: [Route] { get }
}

extension ContentSection {
    var id: String {
        title
    }
    
    var title: String {
        rawValue.camelCased()
    }
}
