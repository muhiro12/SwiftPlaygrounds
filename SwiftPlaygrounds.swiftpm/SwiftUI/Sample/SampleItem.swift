//
//  SampleItem.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation
import SwiftData

@Model
final class SampleItem {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
