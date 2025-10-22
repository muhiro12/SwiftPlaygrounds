//
//  Gender.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

enum Gender: String {
    case male
    case female
    case other
}

extension Gender {
    var color: Color {
        switch self {
        case .male: .blue
        case .female: .red
        case .other: .green
        }
    }
}
