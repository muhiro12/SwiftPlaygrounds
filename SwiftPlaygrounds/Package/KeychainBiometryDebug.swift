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
import KeychainAccess

enum KeychainBiometryScenario {
    case oldMissing_newA_AtoA      // old無し / AppGroup側にAあり / oldKey=A, newKey=A
    case oldMissing_newB_AtoB      // old無し / AppGroup側にBあり / oldKey=A, newKey=B
    case bothA_AtoA                // 通常側Aあり / AppGroup側Aあり
    case bothA_AtoB                // 通常側Aあり / AppGroup側Bあり
}

struct KeychainBiometryDebugger {

    static let service = "com.muhiro12.SwiftPlaygrounds"
    static let accessGroup = "group.com.muhiro12.SwiftPlaygrounds"

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
}
