//
//  PlaygroundsError.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import Foundation

struct PlaygroundsError: LocalizedError {
    let errorDescription: String?

    init(with description: String) {
        errorDescription = description
    }

    init(from error: Error) {
        self.init(with: String(describing: error))
    }

    init() {
        self.init(from: NSError(domain: "", code: -1))
    }
}
