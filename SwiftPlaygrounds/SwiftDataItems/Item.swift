//
//  Item.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2023/08/27.
//
//

import Foundation
import SwiftData

@Model final class Item {
    var name: String
    var category: String
    var price: Decimal

    init(name: String, category: String, price: Decimal) {
        self.name = name
        self.category = category
        self.price = price
    }
}
