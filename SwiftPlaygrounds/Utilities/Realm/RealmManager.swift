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

    private func realm() throws -> Realm {
        try Realm()
    }

    func allSettings(userId: String) -> [String: String] {
        do {
            let realm = try realm()
            guard let profile = realm.object(ofType: SessionProfile.self, forPrimaryKey: userId) else {
                return [:]
            }
            return profile.settings.reduce(into: [:]) { result, element in
                result[element.key] = element.value
            }
        } catch {
            return [:]
        }
    }

    @discardableResult
    func addOrUpdateSetting(userId: String, key: String, value: String) -> Bool {
        do {
            let realm = try realm()
            var isNewKey = false

            try realm.write {
                let profile = realm.object(ofType: SessionProfile.self, forPrimaryKey: userId) ?? SessionProfile()
                if profile.userId.isEmpty {
                    profile.userId = userId
                }

                isNewKey = profile.settings[key] == nil
                profile.settings[key] = value

                if profile.realm == nil {
                    realm.add(profile)
                }
            }

            return isNewKey
        } catch {
            return false
        }
    }

    @discardableResult
    func removeSetting(userId: String, key: String) -> Bool {
        do {
            let realm = try realm()
            guard let profile = realm.object(ofType: SessionProfile.self, forPrimaryKey: userId) else {
                return false
            }

            var removed = false
            try realm.write {
                if profile.settings[key] != nil {
                    profile.settings.removeObject(for: key)
                    removed = true
                }
            }

            return removed
        } catch {
            return false
        }
    }
}
