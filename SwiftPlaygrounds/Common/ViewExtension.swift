//
//  ViewExtension.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import SwiftUI

extension View {
    func alert<E: LocalizedError>(error: Binding<E?>, action: (() -> Void)? = nil) -> some View {
        alert(error: error) {
            Button("OK") {
                action?()
            }
        }
    }

    func alert<E: LocalizedError, A: View>(error: Binding<E?>, @ViewBuilder actions: () -> A) -> some View {
        alert(
            isPresented: .init(
                get: {
                    error.wrappedValue != nil
                },
                set: {
                    if !$0 {
                        error.wrappedValue = nil
                    }
                }
            ),
            error: error.wrappedValue,
            actions: actions
        )
    }

    func progress(isLoading: Binding<Bool>) -> some View {
        ZStack {
            self
            if isLoading.wrappedValue {
                ProgressView()
                    .scaleEffect(2)
            }
        }
    }
}
