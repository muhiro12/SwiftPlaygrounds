//
//  Gender.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

enum Gender {
    case male
    case female
    case other
}

extension Gender {
    var color: Color {
        switch self {
        case .male: return .blue
        case .female: return .red
        case .other: return .green
        }
    }
}
