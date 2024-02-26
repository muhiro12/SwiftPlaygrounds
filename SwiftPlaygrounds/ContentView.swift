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
    case modifier
    case user
    case observation

    var id: Self {
        self
    }

    var contents: [Content] {
        switch self {
        case .all:
            return Content.allCases.reversed()
        case .sample:
            return [.sampleContent]
        case .modifier:
            return [.modifier]
        case .user:
            return [.userList,
                    .user]
        case .observation:
            return [.observationUserList,
                    .observationUser]
        }
    }
}

enum Content: String, Identifiable, CaseIterable {
    case sampleContent
    case modifier
    case userList
    case user
    case observationUserList
    case observationUser

    var id: Self {
        self
    }

    @ViewBuilder
    var detail: some View {
        switch self {
        case .observationUserList:
            ObservationUserListView()
        case .observationUser:
            ObservationUserView()
        case .userList:
            UserListView()
        case .user:
            UserView()
        case .modifier:
            ModifierView()
        case .sampleContent:
            SampleContentView()
        }
    }
}

struct ContentView: View {
    @State private var sidebar: Sidebar? = .all
    @State private var content: Content? = Sidebar.all.contents.first

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
