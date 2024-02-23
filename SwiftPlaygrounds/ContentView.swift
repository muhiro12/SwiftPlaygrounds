//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

enum Sidebar: String, Identifiable, CaseIterable {
    case all
    case sample
    case api

    var id: Self {
        self
    }

    var contents: [Content] {
        switch self {
        case .all:
            return Content.allCases
        case .sample:
            return [.sampleContent]
        case .api:
            return [.apiRequest]
        }
    }
}

enum Content: String, Identifiable, CaseIterable {
    case sampleContent
    case apiRequest

    var id: Self {
        self
    }

    @ViewBuilder
    var detail: some View {
        switch self {
        case .sampleContent:
            SampleContentView()
        case .apiRequest:
            APIRequestView()
        }
    }
}

struct ContentView: View {
    @State private var sidebar: Sidebar?
    @State private var content: Content?

    var body: some View {
        NavigationSplitView {
            List(Sidebar.allCases, selection: $sidebar) {
                Text($0.rawValue)
            }
        } content: {
            if let sidebar {
                List(sidebar.contents, selection: $content) {
                    Text($0.rawValue)
                }
            }
        } detail: {
            if let content {
                content.detail
                    .navigationTitle(content.rawValue)
            }
        }
    }
}

#Preview {
    ContentView()
}
