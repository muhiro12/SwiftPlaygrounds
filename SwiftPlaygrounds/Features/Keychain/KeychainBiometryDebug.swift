//
//  KeychainBiometryDebug.swift
//  SwiftPlaygrounds
//
//  このファイルは KeychainAccess の挙動検証専用コードです。
//  * KeychainAccess を未導入の場合は Xcode の Package Dependencies から
//    `https://github.com/kishikawakatsumi/KeychainAccess` を追加してください。
//  * 既存アプリのロジックには触れないよう、呼び出しは検証時に限定してください。
//

import Foundation
import Security
import KeychainAccess

enum KeychainBiometryScenario {
    case oldMissing_newA_AtoA      // old無し / AppGroup側にAあり / oldKey=A, newKey=A
    case oldMissing_newB_AtoB      // old無し / AppGroup側にBあり / oldKey=A, newKey=B
    case bothA_AtoA                // 通常側Aあり / AppGroup側Aあり
    case bothA_AtoB                // 通常側Aあり / AppGroup側Bあり
}

enum AccessGroupConfig {
    case defaultKeychain
    case appBundleNoTeamID
    case appBundleWithTeamID
    case appGroup
}

struct KeychainBiometryDebugger {

    static let service = "com.muhiro12.SwiftPlaygrounds"
    static let accessGroup = "group.com.muhiro12.SwiftPlaygrounds"
    private static let teamID = "66PKF55HK5"
    private static let bundleID = "com.muhiro12.SwiftPlaygrounds"
    private static let appGroupAccessGroup = ".\(teamID).\(bundleID)"

    // biometry ON 固定版 (requiresBiometry = true)
    static func loadKeychainValueWithMigration(oldKey: String, newKey: String) throws -> Data? {
        let oldStorage = Keychain() // デフォルト (通常 Keychain)
        let newStorage = Keychain(service: service, accessGroup: accessGroup)

        print("[DEBUG] ---- loadKeychainValueWithMigration start ----")
        print("[DEBUG] oldKey = \(oldKey), newKey = \(newKey)")

        // old側の存在確認 + get
        print("[DEBUG] [old] getData(\(oldKey)) - start")
        let oldValue = try? oldStorage.getData(oldKey)
        print("[DEBUG] [old] getData(\(oldKey)) - end, valueExists = \(oldValue != nil)")

        if let oldValue {
            print("[DEBUG] [mig] oldValue exists, start migrating to newKey=\(newKey)")

            do {
                try newStorage
                    .accessibility(.whenPasscodeSetThisDeviceOnly,
                                   authenticationPolicy: .biometryCurrentSet)
                    .set(oldValue, key: newKey)
                print("[DEBUG] [mig] newStorage.set succeeded for key=\(newKey)")
            } catch {
                print("[DEBUG] [mig] newStorage.set failed for key=\(newKey), error=\(error)")
            }

            // 今回は検証用なので old の削除は任意。必要ならここで remove もログ付きで呼ぶ。
            // try? oldStorage.remove(oldKey)

            print("[DEBUG] ---- loadKeychainValueWithMigration end (migrated path) ----")
            return oldValue
        } else {
            print("[DEBUG] [old] no value, try [new] getData(\(newKey))")

            print("[DEBUG] [new] getData(\(newKey)) - start")
            let newValue = try? newStorage.getData(newKey)
            print("[DEBUG] [new] getData(\(newKey)) - end, valueExists = \(newValue != nil)")

            print("[DEBUG] ---- loadKeychainValueWithMigration end (new only path) ----")
            return newValue
        }
    }

    // シナリオごとの事前セットアップとテスト実行
    static func runScenario(_ scenario: KeychainBiometryScenario) {
        let old = Keychain()
        let new = Keychain(service: service, accessGroup: accessGroup)

        let keyA = "A"
        let keyB = "B"
        let sampleDataA = "old-A-\(Date())".data(using: .utf8)!
        let sampleDataB = "new-B-\(Date())".data(using: .utf8)!

        // 毎回クリーンな状態から始めるために、関連するキーを一旦全削除
        print("========== RESET KEYCHAIN STATE ==========")
        try? old.remove(keyA)
        try? old.remove(keyB)
        try? new.remove(keyA)
        try? new.remove(keyB)

        print("[DEBUG] Scenario = \(scenario)")

        switch scenario {
        case .oldMissing_newA_AtoA:
            // old は無し / AppGroup側に A だけ作る
            print("[SETUP] AppGroup A (biometry) を保存")
            try? new
                .accessibility(.whenPasscodeSetThisDeviceOnly,
                               authenticationPolicy: .biometryCurrentSet)
                .set(sampleDataA, key: keyA)

            do {
                _ = try loadKeychainValueWithMigration(oldKey: keyA, newKey: keyA)
            } catch {
                print("[ERROR] loadKeychainValueWithMigration failed: \(error)")
            }

        case .oldMissing_newB_AtoB:
            print("[SETUP] AppGroup B (biometry) を保存")
            try? new
                .accessibility(.whenPasscodeSetThisDeviceOnly,
                               authenticationPolicy: .biometryCurrentSet)
                .set(sampleDataB, key: keyB)

            do {
                _ = try loadKeychainValueWithMigration(oldKey: keyA, newKey: keyB)
            } catch {
                print("[ERROR] loadKeychainValueWithMigration failed: \(error)")
            }

        case .bothA_AtoA:
            print("[SETUP] 通常A + AppGroupA (両方 biometry) を保存")
            try? old
                .accessibility(.whenPasscodeSetThisDeviceOnly,
                               authenticationPolicy: .biometryCurrentSet)
                .set(sampleDataA, key: keyA)
            try? new
                .accessibility(.whenPasscodeSetThisDeviceOnly,
                               authenticationPolicy: .biometryCurrentSet)
                .set(sampleDataA, key: keyA)

            do {
                _ = try loadKeychainValueWithMigration(oldKey: keyA, newKey: keyA)
            } catch {
                print("[ERROR] loadKeychainValueWithMigration failed: \(error)")
            }

        case .bothA_AtoB:
            print("[SETUP] 通常A + AppGroupB (両方 biometry) を保存")
            try? old
                .accessibility(.whenPasscodeSetThisDeviceOnly,
                               authenticationPolicy: .biometryCurrentSet)
                .set(sampleDataA, key: keyA)
            try? new
                .accessibility(.whenPasscodeSetThisDeviceOnly,
                               authenticationPolicy: .biometryCurrentSet)
                .set(sampleDataB, key: keyB)

            do {
                _ = try loadKeychainValueWithMigration(oldKey: keyA, newKey: keyB)
            } catch {
                print("[ERROR] loadKeychainValueWithMigration failed: \(error)")
            }
        }
    }

    static func runAccessGroupAttributesDebug() {
        let testKey = "AccessGroupAttrTest"
        let data = "test-\(Date())".data(using: .utf8)!
        let agrpKey = kSecAttrAccessGroup as String

        let configs: [(AccessGroupConfig, String)] = [
            (.defaultKeychain, "defaultKeychain"),
            (.appBundleNoTeamID, "appBundleNoTeamID"),
            (.appBundleWithTeamID, "appBundleWithTeamID"),
            (.appGroup, "appGroup")
        ]

        print("[AG-DEBUG] ===== reset \(testKey) across configs =====")
        for (config, name) in configs {
            let kc = keychain(for: config)
            do {
                try kc.remove(testKey)
                print("[AG-DEBUG] reset \(name): removed \(testKey)")
            } catch {
                print("[AG-DEBUG] reset \(name): remove error \(error)")
            }
        }

        for (config, name) in configs {
            print("[AG-DEBUG] === \(name) ===")
            let kc = keychain(for: config)

            do {
                try kc.set(data, key: testKey)
                print("[AG-DEBUG] set result: success")
            } catch {
                print("[AG-DEBUG] set result: error: \(error)")
            }

            do {
                let attributes = try attributes(for: testKey, config: config)
                print("[AG-DEBUG] attributes: \(attributes)")
                if let agrp = attributes[agrpKey] ?? attributes["agrp"] {
                    print("[AG-DEBUG] agrp: \(agrp)")
                } else {
                    print("[AG-DEBUG] agrp: (not found)")
                }
            } catch {
                print("[AG-DEBUG] attributes error: \(error)")
            }
        }
    }

    private static func keychain(for config: AccessGroupConfig) -> Keychain {
        switch config {
        case .defaultKeychain:
            return Keychain()
        case .appBundleNoTeamID:
            return Keychain(accessGroup: bundleID)
        case .appBundleWithTeamID:
            return Keychain(accessGroup: "\(teamID).\(bundleID)")
        case .appGroup:
            return Keychain(service: service, accessGroup: appGroupAccessGroup)
        }
    }

    private static func attributes(for key: String, config: AccessGroupConfig) throws -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: kCFBooleanTrue as Any
        ]

        if let service = service(for: config) {
            query[kSecAttrService as String] = service
        }
        if let ag = accessGroup(for: config) {
            query[kSecAttrAccessGroup as String] = ag
        }

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let dict = result as? [String: Any] else {
            throw Status(status: status)
        }
        return dict
    }

    private static func service(for config: AccessGroupConfig) -> String? {
        switch config {
        case .defaultKeychain, .appBundleNoTeamID, .appBundleWithTeamID:
            return bundleID
        case .appGroup:
            return service
        }
    }

    private static func accessGroup(for config: AccessGroupConfig) -> String? {
        switch config {
        case .defaultKeychain:
            return nil
        case .appBundleNoTeamID:
            return bundleID
        case .appBundleWithTeamID:
            return "\(teamID).\(bundleID)"
        case .appGroup:
            return appGroupAccessGroup
        }
    }
}
