//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var deepLinkNavigator: DeepLinkNavigator
    @State private var sortOrder: SortOrder = .addedOrderReversed
    @State private var searchText = ""

    private var selection: Binding<Route?> {
        Binding(
            get: { deepLinkNavigator.selection },
            set: { deepLinkNavigator.selection = $0 }
        )
    }

    private var orderedRoutes: [Route] {
        let routes = RouteRegistry.orderedRoutes
        switch sortOrder {
        case .addedOrder:
            return Route.preferRoutes + routes.filter { !Route.preferRoutes.contains($0) }
        case .addedOrderReversed:
            return routes.reversed()
        case .alphabetical:
            return routes.sorted { $0.title < $1.title }
        case .alphabeticalReversed:
            return routes.sorted { $0.title > $1.title }
        }
    }

    private var filteredRoutes: [Route] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return orderedRoutes
        }
        return orderedRoutes.filter { route in
            if route.title.localizedCaseInsensitiveContains(query) {
                return true
            }
            return route.tags.contains {
                $0.title.localizedCaseInsensitiveContains(query)
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(filteredRoutes,
                 id: \.self,
                 selection: selection) { route in
                VStack(alignment: .leading, spacing: 4) {
                    Text(route.title)
                    if let primaryTag = route.primaryTag {
                        Text(primaryTag.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Contents")
            .toolbar {
                ToolbarItem {
                    Menu {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Button(order.title) {
                                sortOrder = order
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.and.down.text.horizontal")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search by title or tag")
        } detail: {
            if let selection = deepLinkNavigator.selection {
                selection.view
                    .navigationTitle(selection.title)
            } else {
                Text("Select a destination")
            }
        }
    }
}

private enum SortOrder: String, CaseIterable {
    case addedOrder = "Added order"
    case addedOrderReversed = "Added order (reversed)"
    case alphabetical = "Alphabetical"
    case alphabeticalReversed = "Alphabetical (reversed)"

    var title: String {
        rawValue
    }
}

#Preview {
    ContentView()
        .environmentObject(DeepLinkNavigator())
}
