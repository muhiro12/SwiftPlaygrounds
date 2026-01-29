//
//  SessionProfile.swift
//  SwiftPlaygrounds
//
//  Created by Codex on 2026/01/29.
//

import Foundation
import RealmSwift

final class SessionProfile: Object {
    @objc dynamic var userId: String = ""
    let settings = Map<String, String>()

    nonisolated override static func primaryKey() -> String? {
        "userId"
    }
}
