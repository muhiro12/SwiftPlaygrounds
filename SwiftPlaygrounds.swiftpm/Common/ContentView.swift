//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct ContentView: View {
    @State private var sidebar: Sidebar? = .all
    @State private var content: Route? = .preferRoutes.first

    @State private var isAscending = false

    var body: some View {
        NavigationSplitView {
            List(Sidebar.allCases,
                 id: \.self,
                 selection: $sidebar) {
                Text($0.title)
            }
            .navigationTitle(String(describing: type(of: self)))
        } content: {
            if let sidebar {
                List(isAscending ? sidebar.contentSections : sidebar.contentSections.reversed(),
                     id: \.id,
                     selection: $content) { section in
                    Section(section.title) {
                        ForEach(isAscending ? section.contents : section.contents.reversed(),
                                id: \.self) { content in
                            Text(content.title)
                        }
                    }
                }
                .navigationTitle(sidebar.title)
                .toolbar {
                    ToolbarItem {
                        Button("Sort", systemImage: "arrow.up.and.down.text.horizontal") {
                            isAscending.toggle()
                        }
                    }
                }
            }
        } detail: {
            if let content {
                content.view
                    .navigationTitle(content.title)
            }
        }
    }
}

#Preview {
    ContentView()
}
