//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

enum Sidebar: String, Identifiable, CaseIterable {
    case all
    case modifier
    case api
    case sample

    var id: Self {
        self
    }

    var contents: [Content] {
        switch self {
        case .all:
            return Content.allCases
        case .modifier:
            return [.modifier]
        case .api:
            return [.apiRequest]
        case .sample:
            return [.sampleContent]
        }
    }
}

enum Content: String, Identifiable, CaseIterable {
    case modifier
    case apiRequest
    case sampleContent

    var id: Self {
        self
    }

    @ViewBuilder
    var detail: some View {
        switch self {
        case .modifier:
            ModifierView()
        case .apiRequest:
            APIRequestView()
        case .sampleContent:
            SampleContentView()
        }
    }
}

struct ContentView: View {
    @State private var sidebar: Sidebar? = .all
    @State private var content: Content? = Content.allCases.first

    var body: some View {
        NavigationSplitView {
            List(Sidebar.allCases, selection: $sidebar) {
                Text($0.rawValue)
            }
            .navigationTitle(String(describing: type(of: self)))
        } content: {
            if let sidebar {
                List(sidebar.contents, selection: $content) {
                    Text($0.rawValue)
                }
                .navigationTitle(sidebar.rawValue)
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
