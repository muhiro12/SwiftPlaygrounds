//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2022/01/04.
//

import SwiftUI
import CoreData
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query
    private var allItems: [Item]

    private var sections: [SectionedItem] {
        Dictionary(grouping: allItems, by: \Item.category!).map {
            SectionedItem(category: $0.key,
                          items: $0.value.sorted(by: { $0.name < $1.name }))
        }.sorted(by: { $0.category < $1.category })
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(sections) { section in
                    Section(content: {
                        ForEach(section.items) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.price.description + " 円")
                            }
                        }
                        .onDelete { offsets in
                            let items = offsets.map { section.items[$0] }
                            self.deleteItems(items)
                        }
                    }, header: {
                        Text(section.category)
                    })
                }
            }.navigationTitle("商品一覧")
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
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let itemType = ItemType(rawValue: Int.random(in: 0..<5))!

            let newItem = Item(name: itemType.name,
                               category: itemType.category.rawValue,
                               price: itemType.price)

            context.insert(newItem)

            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(_ items: [Item]) {
        withAnimation {
            items.forEach { context.delete($0) }

            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SectionedItem: Identifiable {
    let id = UUID()

    let category: String
    let items: [Item]
}

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
        case .milk: return "ミルク"
        case .coffee: return "コーヒー"
        case .orange: return "みかん"
        case .apple: return "りんご"
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

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        ContentView()
    }
}


struct ModelContainerPreview<Content: View>: View {
    var content: () -> Content
    let container: ModelContainer

    init(@ViewBuilder content: @escaping () -> Content, modelContainer: @escaping () throws -> ModelContainer) {
        self.content = content
        do {
            self.container = try MainActor.assumeIsolated(modelContainer)
        } catch {
            fatalError("Failed to create the model container: \(error.localizedDescription)")
        }
    }

    init(_ modelContainer: @escaping () throws -> ModelContainer, @ViewBuilder content: @escaping () -> Content) {
        self.init(content: content, modelContainer: modelContainer)
    }

    var body: some View {
        content()
            .modelContainer(container)
    }
}

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
