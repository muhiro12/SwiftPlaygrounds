//
//  RealmManager.swift
//  SwiftPlaygrounds
//
//  Created by Codex on 2026/01/29.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()

    private init() {}

    private var realm: Realm {
        try! Realm()
    }

    func update<T: Object>(object: T) {
        let realm = self.realm
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
        }
    }

    func allSettings(userId: String) -> [String: String] {
        let realm = self.realm
        guard let profile = realm.object(ofType: SessionProfile.self, forPrimaryKey: userId) else {
            return [:]
        }
        return profile.settings.reduce(into: [:]) { result, element in
            result[element.key] = element.value
        }
    }

    @discardableResult
    func addOrUpdateSetting(userId: String, key: String, value: String) -> Bool {
        let realm = self.realm
        if let existing = realm.object(ofType: SessionProfile.self, forPrimaryKey: userId) {
            let profile = SessionProfile()
            profile.userId = userId
            for entry in existing.settings {
                profile.settings[entry.key] = entry.value
            }
            let isNewKey = profile.settings[key] == nil
            profile.settings[key] = value
            update(object: profile)
            return isNewKey
        } else {
            let profile = SessionProfile()
            profile.userId = userId
            profile.settings[key] = value
            update(object: profile)
            return true
        }
    }

    @discardableResult
    func removeSetting(userId: String, key: String) -> Bool {
        let realm = self.realm
        guard let existing = realm.object(ofType: SessionProfile.self, forPrimaryKey: userId) else {
            return false
        }

        guard existing.settings[key] != nil else {
            return false
        }

        let profile = SessionProfile()
        profile.userId = userId
        for entry in existing.settings where entry.key != key {
            profile.settings[entry.key] = entry.value
        }
        update(object: profile)
        return true
    }
}
