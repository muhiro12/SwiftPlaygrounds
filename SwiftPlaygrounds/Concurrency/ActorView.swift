//
//  ActorView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/04/04.
//

import SwiftUI

struct ActorView: View {
    private let state = ActorViewState()

    var body: some View {
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

#Preview {
    ActorView()
}
