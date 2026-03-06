import SwiftUI
import KeychainAccess

struct KeychainLabView: View {
    private struct ScenarioItem: Identifiable {
        let id: String
        let scenario: KeychainBiometryScenario
        let title: String
        let detail: String
    }

    @State private var identifierInput = ""
    @State private var passwordInput = ""
    @State private var newPasswordInput = ""
    @State private var output = "Ready."
    @State private var lastRunTitle: String?
    @State private var error: PlaygroundsError?

    private let keychain = Keychain()
    private let newKeychain = Keychain()
    private let identifierKey = "Identifier"
    private let passwordKey = "Password"
    private let newPasswordKey = "NewPassword"

    private let scenarios: [ScenarioItem] = [
        .init(
            id: "oldMissing_newA_AtoA",
            scenario: .oldMissing_newA_AtoA,
            title: "Old missing / New A (A -> A)",
            detail: "Only the App Group key A exists with biometryCurrentSet."
        ),
        .init(
            id: "oldMissing_newB_AtoB",
            scenario: .oldMissing_newB_AtoB,
            title: "Old missing / New B (A -> B)",
            detail: "Only the App Group key B exists with biometryCurrentSet."
        ),
        .init(
            id: "bothA_AtoA",
            scenario: .bothA_AtoA,
            title: "Old A + New A (A -> A)",
            detail: "The default keychain and App Group both contain key A."
        ),
        .init(
            id: "bothA_AtoB",
            scenario: .bothA_AtoB,
            title: "Old A + New B (A -> B)",
            detail: "The default keychain has A and the App Group has B."
        )
    ]

    var body: some View {
        Form {
            Section("Overview") {
                Text("Basic KeychainAccess operations and biometry/access-group diagnostics live on one screen.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text("App Group: \(KeychainBiometryDebugger.accessGroup)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let lastRunTitle {
                    Text("Last debug run: \(lastRunTitle)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section(identifierKey) {
                TextField(identifierKey, text: $identifierInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                Button("Save Identifier") {
                    keychain[identifierKey] = identifierInput
                    output = "Saved identifier: \(identifierInput)"
                    identifierInput = ""
                }

                Button("Fetch Identifier") {
                    output = "Identifier: \(keychain[identifierKey] ?? "nil")"
                    identifierInput = ""
                }

                Button("Delete Identifier") {
                    keychain[identifierKey] = nil
                    output = "Deleted identifier key."
                    identifierInput = ""
                }
            }

            Section(passwordKey) {
                TextField(passwordKey, text: $passwordInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                Button("Save Password") {
                    do {
                        try keychain
                            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .biometryAny)
                            .set(passwordInput, key: passwordKey)
                        output = "Saved legacy password key."
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }

                Button("Fetch Password") {
                    do {
                        output = "Password: \(try keychain.get(passwordKey) ?? "nil")"
                    } catch KeychainAccess.Status.userCanceled {
                        output = "Password fetch canceled by user."
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }

                Button("Delete Password") {
                    do {
                        try keychain.remove(passwordKey)
                        output = "Deleted legacy password key."
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }
            }

            Section(newPasswordKey) {
                TextField(newPasswordKey, text: $newPasswordInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                Button("Save New Password") {
                    do {
                        try newKeychain
                            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .biometryAny)
                            .set(newPasswordInput, key: newPasswordKey)
                        output = "Saved new password key."
                    } catch {
                        self.error = .init(from: error)
                    }
                    newPasswordInput = ""
                }

                Button("Fetch New Password") {
                    do {
                        output = "New password: \(try newKeychain.get(newPasswordKey) ?? "nil")"
                    } catch KeychainAccess.Status.userCanceled {
                        output = "New password fetch canceled by user."
                    } catch {
                        self.error = .init(from: error)
                    }
                    newPasswordInput = ""
                }

                Button("Delete New Password") {
                    do {
                        try newKeychain.remove(newPasswordKey)
                        output = "Deleted new password key."
                    } catch {
                        self.error = .init(from: error)
                    }
                    newPasswordInput = ""
                }
            }

            Section("Migration Check") {
                Button("Fetch Old or New Password") {
                    do {
                        if let legacyValue = try keychain.getData(passwordKey)?.description {
                            output = "Resolved legacy password data: \(legacyValue)"
                        } else if let newValue = try newKeychain.getData(newPasswordKey)?.description {
                            output = "Resolved new password data: \(newValue)"
                        } else {
                            output = "No password data found in either key."
                        }
                    } catch KeychainAccess.Status.userCanceled {
                        output = "Migration check canceled by user."
                    } catch {
                        self.error = .init(from: error)
                    }
                }
            }

            Section("Biometry Debug") {
                Text("Use a real device with the App Group configured. Inspect the Xcode console for the debug output.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

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

                Button("Run Access Group Debug") {
                    print("========== RUN AccessGroup Debug ==========")
                    KeychainBiometryDebugger.runAccessGroupAttributesDebug()
                    lastRunTitle = "Access Group Debug"
                    output = "Ran access-group diagnostics. Check the console output."
                }
            }

            Section("Last Output") {
                Text(output)
                    .font(.caption.monospaced())
                    .textSelection(.enabled)
            }
        }
        .navigationTitle("Keychain Lab")
        .alert(error: $error)
    }

    private func run(_ item: ScenarioItem) {
        print("========== RUN \(item.id) ==========")
        KeychainBiometryDebugger.runScenario(item.scenario)
        lastRunTitle = item.title
        output = "Ran debug scenario: \(item.title). Check the console output."
    }
}

#Preview {
    NavigationStack {
        KeychainLabView()
    }
}
