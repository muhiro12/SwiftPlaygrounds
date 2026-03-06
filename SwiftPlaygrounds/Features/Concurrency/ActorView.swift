//
//  ActorView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/04/04.
//

import SwiftUI

struct ActorView: View {
    @State private var state = ActorViewState()

    var body: some View {
        VStack(spacing: 16) {
            Text(state.classText)
            Text(state.actorText)
            Button("Button") {
                Task {
                    await state.onTap()
                }
                Task {
                    await state.onTap()
                }
                Task {
                    await state.onTap()
                }
                Task {
                    await state.onTap()
                }
                Task {
                    await state.onTap()
                }
                Task {
                    await state.onTap()
                }
                Task {
                    await state.onTap()
                }
                Task {
                    await state.onTap()
                }
            }
        }
    }
}

#Preview {
    ActorView()
}
