//
//  KeychainAccessView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/05/02.
//

import SwiftUI
import KeychainAccess

struct KeychainAccessView: View {
    @State private var identifierInput = ""
    @State private var identifierOutput = ""
    @State private var isIdentifierPresented = false
    @State private var passwordInput = ""
    @State private var passwordOutput = ""
    @State private var isPasswordPresented = false
    @State private var error: PlaygroundsError?

    private let keychain = Keychain()
    private let newKeychain = Keychain()
    private let identifierKey = "Identifier"
    private let passwordKey = "Password"
    private let newPasswordKey = "NewPassword"

    var body: some View {
        List {
            Section(identifierKey) {
                TextField(identifierKey, text: $identifierInput)
                Button("Add") {
                    keychain[identifierKey] = identifierInput
                    identifierInput = ""
                }
                Button("Fetch") {
                    identifierOutput = keychain[identifierKey] ?? "nil"
                    isIdentifierPresented = true
                    identifierInput = ""
                }
                Button("Delete") {
                    keychain[identifierKey] = nil
                    identifierInput = ""
                }
            }
            Section(passwordKey) {
                TextField(passwordKey, text: $passwordInput)
                Button("Add") {
                    do {
                        try keychain
                            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .biometryAny)
                            .set(passwordInput, key: passwordKey)
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }
                Button("Fetch") {
                    do {
                        passwordOutput = try keychain.get(passwordKey) ?? "nil"
                        isPasswordPresented = true
                    } catch KeychainAccess.Status.userCanceled {
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }
                Button("Delete") {
                    try! keychain.remove(passwordKey)
                    passwordInput = ""
                }
            }
            Section(newPasswordKey) {
                TextField(newPasswordKey, text: $passwordInput)
                Button("Add") {
                    do {
                        try newKeychain
                            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .biometryAny)
                            .set(passwordInput, key: newPasswordKey)
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }
                Button("Fetch") {
                    do {
                        passwordOutput = try newKeychain.get(newPasswordKey) ?? "nil"
                        isPasswordPresented = true
                    } catch KeychainAccess.Status.userCanceled {
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }
                Button("Delete") {
                    try! newKeychain.remove(newPasswordKey)
                    passwordInput = ""
                }
            }
            Section("Old + New") {
                Button("Fetch") {
                    do {
                        if let output = try keychain.getData(passwordKey)?.description {
                            passwordOutput = "Old + " + output
                            isPasswordPresented = true
                        } else if let output = try newKeychain.getData(newPasswordKey)?.description {
                            passwordOutput = "New + " + output
                            isPasswordPresented = true
                        } else {
                            passwordOutput = "Else"
                            isPasswordPresented = true
                        }
                    } catch KeychainAccess.Status.userCanceled {
                    } catch {
                        self.error = .init(from: error)
                    }
                    passwordInput = ""
                }
            }
        }
        .alert(identifierKey, isPresented: $isIdentifierPresented) {
        } message: {
            Text(identifierOutput)
        }
        .alert(passwordKey, isPresented: $isPasswordPresented) {
        } message: {
            Text(passwordOutput)
        }
        .alert(error: $error)
    }
}

#Preview {
    KeychainAccessView()
}
