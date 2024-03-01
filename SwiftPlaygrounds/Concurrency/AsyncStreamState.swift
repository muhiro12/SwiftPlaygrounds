//
//  AsyncStreamState.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/29.
//

import Foundation

final class AsyncStreamState {
    lazy var countStream = AsyncStream<Int> { [weak self] continuation in
        self?.continuation = continuation
    }

    private var continuation: AsyncStream<Int>.Continuation?
    private var count = 0

    func countUp() {
        count += 1
        continuation?.yield(count)
    }

    func countDown() {
        count -= 1
        continuation?.yield(count)
    }
}
