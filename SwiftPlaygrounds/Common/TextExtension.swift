//
//  TextExtension.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

extension Text {
    init(optional: Optional<String>) {
        self.init(optional ?? "")
    }
}
