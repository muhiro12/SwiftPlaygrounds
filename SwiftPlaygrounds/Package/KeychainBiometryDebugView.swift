//
//  KeychainBiometryDebugView.swift
//  SwiftPlaygrounds
//
//  Debug UI for KeychainAccess biometry migration prompts.
//  呼び出し時は必ず実機 + App Group を設定した状態で利用してください。
//

import SwiftUI

struct KeychainBiometryDebugView: View {
    private struct ScenarioItem: Identifiable {
        let id: String
        let scenario: KeychainBiometryScenario
        let title: String
        let detail: String
    }

    @State private var lastRunTitle: String?

    private let scenarios: [ScenarioItem] = [
        .init(id: "oldMissing_newA_AtoA",
              scenario: .oldMissing_newA_AtoA,
              title: "Oldなし / New=A (A→A)",
              detail: "App Group に A が biometryCurrentSet で存在"),
        .init(id: "oldMissing_newB_AtoB",
              scenario: .oldMissing_newB_AtoB,
              title: "Oldなし / New=B (A→B)",
              detail: "App Group に B が biometryCurrentSet で存在"),
        .init(id: "bothA_AtoA",
              scenario: .bothA_AtoA,
              title: "Old A + New A (A→A)",
              detail: "通常/Group ともに A が biometryCurrentSet で存在"),
        .init(id: "bothA_AtoB",
              scenario: .bothA_AtoB,
              title: "Old A + New B (A→B)",
              detail: "通常に A, Group に B が biometryCurrentSet で存在")
    ]

    var body: some View {
        List {
            Section("注意事項") {
                Text("App Group: \(KeychainBiometryDebugger.accessGroup)")
                Text("実機でのみ動作確認できます。ログは Xcode コンソールの [DEBUG]/[SETUP] を確認してください。")
                if let lastRunTitle {
                    Text("Last run: \(lastRunTitle)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("シナリオ実行") {
                ForEach(scenarios) { item in
                    Button {
                        run(item)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                            Text(item.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Keychain Biometry")
    }

    private func run(_ item: ScenarioItem) {
        print("========== RUN \(item.id) ==========")
        KeychainBiometryDebugger.runScenario(item.scenario)
        lastRunTitle = item.title
    }
}

#Preview {
    NavigationStack {
        KeychainBiometryDebugView()
    }
}
