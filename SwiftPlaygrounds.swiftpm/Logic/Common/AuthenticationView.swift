//
//  AuthenticationView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 1/7/25.
//

import SwiftUI
import LocalAuthentication

struct AuthenticationView: View {
    @State private var result: Result<Void, Error>?
    @State private var isPresented = false

    private let context = LAContext()

    var body: some View {
        Text("Result")
        Text(result.debugDescription)
        Button("Authenticate") {
            Task {
                do {
                    try await context.evaluatePolicy(
                        .deviceOwnerAuthentication,
                        localizedReason: "localizedReason"
                    )
                    result = .success(())
                } catch {
                    result = .failure(error)
                    switch (error as? LAError)?.code {
                    case LAError.passcodeNotSet:
                        isPresented = true
                    default:
                        break
                    }
                }
            }
        }
        .alert("Not Set", isPresented: $isPresented) {}
    }
}

#Preview {
    AuthenticationView()
}
