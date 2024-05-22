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
    case combine
    case concurrency
    case swiftData
    case package
    case transition
    case webView

    var id: Self {
        self
    }

    var contents: [Content] {
        switch self {
        case .all:
            Content.allCases.reversed()
        case .sample:
            [.sampleContent]
        case .modifier:
            [.modifier]
        case .user:
            [.userList,
             .user]
        case .observation:
            [.observationUserList,
             .observationUser,
             .observableObjectUserList,
             .observableObjectUser,
             .publishedUserList,
             .publishedUser]
        case .storyboard:
            [.storyboard,
             .table,
             .collection,
             .compositional,
             .infinitePaging,
             .infiniteCompositional]
        case .combine:
            [.combine,
             .combineDetail]
        case .concurrency:
            [.asyncStream,
             .actor]
        case .swiftData:
            [.student]
        case .package:
            [.keychainAccess]
        case .transition:
            [.transition]
        case .webView:
            [.webView]
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
    case collection
    case compositional
    case combine
    case combineDetail
    case asyncStream
    case actor
    case student
    case keychainAccess
    case transition
    case infinitePaging
    case infiniteCompositional
    case webView
    
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
        case .collection:
            CollectionView()
        case .compositional:
            CompositionalView()
        case .combine:
            CombineView()
        case .combineDetail:
            CombineDetailView()
        case .asyncStream:
            AsyncStreamView()
        case .actor:
            ActorView()
        case .student:
            StudentView()
        case .keychainAccess:
            KeychainAccessView()
        case .transition:
            TransitionView()
        case .infinitePaging:
            InfinitePagingView()
        case .infiniteCompositional:
            InfiniteCompositionalView()
        case .webView:
            WebView()
        }
    }
}

struct ContentView: View {
    @State private var sidebar: Sidebar? = .all
    @State private var content: Content? = Sidebar.all.contents.first

    var body: some View {
        NavigationSplitView {
            List((Sidebar.allCases.dropFirst() + [.all]).reversed(), selection: $sidebar) {
                Text($0.rawValue.camelCased())
            }
            .navigationTitle(String(describing: type(of: self)))
        } content: {
            if let sidebar {
                List(sidebar.contents, selection: $content) {
                    Text($0.rawValue.camelCased())
                }
                .navigationTitle(sidebar.rawValue.camelCased())
            }
        } detail: {
            if let content {
                content.detail
                    .navigationTitle(content.rawValue.camelCased())
            }
        }
    }
}

#Preview {
    ContentView()
}
