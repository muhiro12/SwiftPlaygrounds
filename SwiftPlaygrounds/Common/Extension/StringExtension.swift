//
//  StringExtension.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import Foundation

extension String {
    func camelCased() -> Self {
        (first?.uppercased() ?? "") + dropFirst()
    }
}
