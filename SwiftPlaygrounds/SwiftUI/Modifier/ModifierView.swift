//
//  ModifierView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import SwiftUI

struct ModifierView: View {
    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
        VStack(spacing: 40) {
            Button("Toggle isLoading") {
                isLoading.toggle()
            }
            Button("Throw error") {
                error = PlaygroundsError()
            }
        }
        .progress(isLoading: $isLoading)
        .alert(error: $error)
    }
}

#Preview {
    ModifierView()
}
