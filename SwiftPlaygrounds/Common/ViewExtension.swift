//
//  ViewExtension.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import SwiftUI

extension View {
    func alert<E: LocalizedError>(error: Binding<E?>) -> some View {
        alert(isPresented: .init(get: { error.wrappedValue != nil },
                                 set: { _ in error.wrappedValue = nil }),
              error: error.wrappedValue) {}
    }
}
