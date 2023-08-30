//
//  SwiftDataItemsView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2023/08/30.
//

import SwiftUI
import CoreData
import SwiftData

struct SwiftDataItemsView: View {
    @Environment(\.modelContext)
    private var context

    @Query(filter: #Predicate<Item> { $0.price < 300 })
    private var allItems: [Item]

    private var sections: [SectionedItems] {
        Dictionary(grouping: allItems, by: \Item.category).map {
            SectionedItems(category: $0.key,
                          items: $0.value.sorted(by: { $0.name < $1.name }))
        }.sorted(by: { $0.category < $1.category })
    }

    var body: some View {
        List {
            ForEach(sections) { section in
                Section(content: {
                    ForEach(section.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.price.description + " 円")
                        }
                        .swipeActions(edge: .leading) {
                            Button("Multiple") {
                                editItems([item])
                            }
                        }
                    }
                    .onDelete { offsets in
                        let items = offsets.map { section.items[$0] }
                        deleteItems(items)
                    }
                }, header: {
                    Text(section.category)
                })
            }
        }
        .navigationTitle("商品一覧")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let itemType = ItemType(rawValue: Int.random(in: 0..<5))!
            let newItem = Item(name: itemType.name,
                               category: itemType.category.rawValue,
                               price: itemType.price)
            context.insert(newItem)
        }
    }

    private func editItems(_ items: [Item]) {
        withAnimation {
            items.forEach {
                $0.price = $0.price * 10
            }
        }
    }

    private func deleteItems(_ items: [Item]) {
        withAnimation {
            items.forEach(context.delete)
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        SwiftDataItemsView()
    }
}
