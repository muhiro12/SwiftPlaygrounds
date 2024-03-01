//
//  AsyncStreamView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/29.
//

import SwiftUI

struct AsyncStreamView: View {
    @State private var count = 0

    private let state = AsyncStreamState()

    var body: some View {
        HStack(spacing: 40) {
            Button(action: state.countDown) {
                Image(systemName: "minus")
            }
            Text(count.description)
            Button(action: state.countUp) {
                Image(systemName: "plus")
            }
        }.task {
            for await count in state.countStream {
                self.count = count
            }
        }
    }
}

#Preview {
    AsyncStreamView()
}
