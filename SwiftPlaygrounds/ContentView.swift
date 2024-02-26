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
    case storyboard

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
                    .observationUser,
                    .observableObjectUserList,
                    .observableObjectUser,
                    .publishedUserList,
                    .publishedUser]
        case .storyboard:
            return [.storyboard,
                    .table]
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
    case observableObjectUserList
    case observableObjectUser
    case publishedUserList
    case publishedUser
    case storyboard
    case table

    var id: Self {
        self
    }

    @ViewBuilder
    var detail: some View {
        switch self {
        case .sampleContent:
            SampleContentView()
        case .modifier:
            ModifierView()
        case .userList:
            UserListView()
        case .user:
            UserView()
        case .observationUserList:
            ObservationUserListView()
        case .observationUser:
            ObservationUserView()
        case .observableObjectUserList:
            ObservableObjectUserListView()
        case .observableObjectUser:
            ObservableObjectUserView()
        case .publishedUserList:
            PublishedUserListView()
        case .publishedUser:
            PublishedUserView()
        case .storyboard:
            StoryboardView()
        case .table:
            TableView()
        }
    }
}

struct ContentView: View {
    @State private var sidebar: Sidebar? = .all
    @State private var content: Content? = Sidebar.all.contents.first

    var body: some View {
        NavigationSplitView {
            List((Sidebar.allCases.dropFirst() + [.all]).reversed(), selection: $sidebar) {
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
