//
//  PlaygroundsError.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import Foundation

struct PlaygroundsError: LocalizedError {
    init(from error: Error) {
        self.error = error
    }

    private let error: Error

    var errorDescription: String? {
        String(describing: error)
    }
}
