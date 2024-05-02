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
    @State private var passwordInput = ""
    @State private var passwordOutput = ""
    @State private var error: PlaygroundsError?

    private let keychain = Keychain()
    private let identifierKey = "Identifier"
    private let passwordKey = "Password"

    var body: some View {
        List {
            Section(identifierKey) {
                HStack {
                    TextField(identifierKey, text: $identifierInput)
                    Spacer()
                    Button("", systemImage: "plus") {
                        keychain[identifierKey] = identifierInput
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    Text(identifierOutput)
                    Spacer()
                    Button("", systemImage: "minus") {
                        identifierOutput = keychain[identifierKey] ?? ""
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    Spacer()
                    Button("", systemImage: "xmark") {
                        keychain[identifierKey] = nil
                    }
                    .buttonStyle(.plain)
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            Section(passwordKey) {
                HStack {
                    TextField(passwordKey, text: $passwordInput)
                    Spacer()
                    Button("", systemImage: "plus") {
                        do {
                            try keychain
                                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .biometryAny)
                                .set(passwordInput, key: passwordKey)
                        } catch {
                            self.error = .init(from: error)
                        }
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    Text(passwordOutput)
                    Spacer()
                    Button("", systemImage: "minus") {
                        passwordOutput = keychain[passwordKey] ?? ""
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    Spacer()
                    Button("", systemImage: "xmark") {
                        keychain[passwordKey] = nil
                    }
                    .buttonStyle(.plain)
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        }
        .alert(error: $error)
    }
}

#Preview {
    KeychainAccessView()
}
