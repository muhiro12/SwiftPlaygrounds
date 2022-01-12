//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2022/01/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @SectionedFetchRequest(
        sectionIdentifier: \Item.category!,
        sortDescriptors: [.init(keyPath: \Item.category, ascending: true),
                          .init(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var sections: SectionedFetchResults<String, Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(sections) { section in
                    Section(content: {
                        ForEach(section) { item in
                            HStack {
                                Text(item.name!)
                                Spacer()
                                Text(item.price!.stringValue + " 円")
                            }
                        }
                        .onDelete { offsets in
                            let items = offsets.map { section[$0] }
                            self.deleteItems(items)
                        }
                    }, header: {
                        Text(section.id)
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
            let newItem = Item(context: viewContext)

            let itemType = ItemType(rawValue: Int.random(in: 0..<5))!
            newItem.name = itemType.name
            newItem.category = itemType.category.rawValue
            newItem.price = itemType.price

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(_ items: [Item]) {
        withAnimation {
            items.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
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

    var price: NSDecimalNumber {
        let num = Int.random(in: 1...5)
        return NSDecimalNumber(value: num * 108)
    }

    enum Category: String {
        case drink = "ドリンク"
        case fruit = "フルーツ"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
