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
    private let identifierKey = "Identifier"
    private let passwordKey = "Password"

    var body: some View {
        List {
            Section(identifierKey) {
                TextField(identifierKey, text: $identifierInput)
                Button("Add") {
                    keychain[identifierKey] = identifierInput
                }
                Button("Fetch") {
                    identifierOutput = keychain[identifierKey] ?? "nil"
                    isIdentifierPresented = true
                }
                Button("Delete") {
                    identifierInput = ""
                    keychain[identifierKey] = nil
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
                }
                Button("Fetch") {
                    passwordOutput = keychain[passwordKey] ?? "nil"
                    isPasswordPresented = true
                }
                Button("Delete") {
                    passwordOutput = ""
                    keychain[passwordKey] = nil
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
