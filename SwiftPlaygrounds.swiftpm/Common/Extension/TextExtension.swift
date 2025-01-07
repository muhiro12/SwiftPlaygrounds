//
//  TextExtension.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

extension Text {
    init(optional: String?) {
        self.init(optional ?? "")
    }
}
