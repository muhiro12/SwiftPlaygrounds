//
//  CombineViewState.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/27.
//

import Foundation
import Combine

final class CombineViewState: ObservableObject {
    @Published var count = 0
    @Published var operatorCount = 0
    @Published var mergeCount = 0
    @Published var zipCount = 0
    @Published var combineLatestCount = 0
    @Published var reverseMergeCount = 0
    @Published var isDetailPresented = false
    @Published var error: PlaygroundsError?

    init() {
        $count
            .filter { $0 % 3 == 0 }
            .map { $0 * 10 }
            .assign(to: &$operatorCount)

        $count
            .merge(with: $operatorCount)
            .assign(to: &$mergeCount)

        $count
            .zip($operatorCount)
            .map { $0.0 + $0.1 }
            .assign(to: &$zipCount)

        $count
            .combineLatest($operatorCount)
            .map { $0.0 + $0.1 }
            .assign(to: &$combineLatestCount)

        $operatorCount
            .merge(with: $count)
            .assign(to: &$reverseMergeCount)
    }

    func countUp() {
        count += 1
    }

    func throwError() {
        error = .init()
    }

    func presentDetail() {
        isDetailPresented = true
    }
}
