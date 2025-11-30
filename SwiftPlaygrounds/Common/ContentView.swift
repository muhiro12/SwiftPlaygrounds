//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Route? = .keychainAccess
    @State private var isAscending = false
    @State private var searchText = ""

    private var orderedRoutes: [Route] {
        let routes = Route.preferRoutes + Route.allCases.filter {
            !Route.preferRoutes.contains($0)
        }
        guard isAscending else {
            return routes
        }
        return routes.sorted {
            $0.title < $1.title
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
                 selection: $selection) { route in
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
                    Button("Sort", systemImage: "arrow.up.and.down.text.horizontal") {
                        isAscending.toggle()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search by title or tag")
        } detail: {
            if let selection {
                selection.view
                    .navigationTitle(selection.title)
            } else {
                Text("Select a destination")
            }
        }
    }
}

#Preview {
    ContentView()
}
