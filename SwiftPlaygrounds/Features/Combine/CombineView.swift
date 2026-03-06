//
//  CombineView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/27.
//

import SwiftUI

struct CombineView: View {
    @StateObject private var state = CombineViewState()

    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 16) {
                Button("Count up", action: state.countUp)
                Text(state.count.description)
            }
            VStack(spacing: 16) {
                Text("Operator count")
                Text(state.operatorCount.description)
            }
            VStack(spacing: 16) {
                Text("Merge count")
                Text(state.mergeCount.description)
            }
            VStack(spacing: 16) {
                Text("Zip count")
                Text(state.zipCount.description)
            }
            VStack(spacing: 16) {
                Text("Combine latest count")
                Text(state.combineLatestCount.description)
            }
            VStack(spacing: 16) {
                Text("Reverse merge count")
                Text(state.reverseMergeCount.description)
            }
            Button("Throw error", action: state.throwError)
        }
        .toolbar {
            Button(action: state.presentDetail) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $state.isDetailPresented) {
            CombineDetailView()
        }
        .alert(error: $state.error)
    }
}

#Preview {
    NavigationStack {
        CombineView()
    }
}
