//
//  PreviewSampleData.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2023/08/30.
//

import Foundation
import SwiftData

actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Item.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = (0...10).map { _ in
            let itemType = ItemType(rawValue: Int.random(in: 0..<5))!
            return Item(name: itemType.name,
                        category: itemType.category.rawValue,
                        price: itemType.price)

        }
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
}
