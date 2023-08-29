//
//  ItemType.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2023/08/30.
//

import Foundation

enum ItemType: Int {
    case milk
    case coffee
    case orange
    case apple

    init?(rawValue: RawValue) {
        switch rawValue {
        case 0:
            self = .milk
        case 1:
            self = .coffee
        case 2:
            self = .orange
        default:
            self = .apple
        }
    }

    var name: String {
        switch self {
        case .milk: return "ミルク3"
        case .coffee: return "コーヒー3"
        case .orange: return "みかん3"
        case .apple: return "りんご3"
        }
    }

    var category: Category {
        switch self {
        case .milk: return .drink
        case .coffee: return .drink
        case .orange: return .fruit
        case .apple: return .fruit
        }
    }

    var price: Decimal {
        let num = Int.random(in: 1...5)
        return Decimal(num * 108)
    }

    enum Category: String {
        case drink = "ドリンク"
        case fruit = "フルーツ"
    }
}
