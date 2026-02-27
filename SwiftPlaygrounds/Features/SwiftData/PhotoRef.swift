import Foundation
import SwiftData

@Model
final class PhotoRef {
    @Attribute(.unique) var id: UUID
    var assetLocalIdentifier: String
    var createdAt: Date
    var memo: String
    var lastResolvedAt: Date?

    init(
        id: UUID = UUID(),
        assetLocalIdentifier: String,
        createdAt: Date = .now,
        memo: String = "",
        lastResolvedAt: Date? = nil
    ) {
        self.id = id
        self.assetLocalIdentifier = assetLocalIdentifier
        self.createdAt = createdAt
        self.memo = memo
        self.lastResolvedAt = lastResolvedAt
    }
}
