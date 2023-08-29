//
//  SectionedItems.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2023/08/30.
//

import Foundation

struct SectionedItems: Identifiable {
    let id = UUID()

    let category: String
    let items: [Item]
}
