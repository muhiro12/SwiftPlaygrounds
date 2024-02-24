//
//  APIRequestView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct APIRequestView: View {
    @State private var userList: [User] = []
    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
        ZStack {
            VStack {
                List(userList) { user in
                    HStack {
                        Circle()
                            .frame(width: 8)
                            .foregroundStyle(user.gender.color)
                        Spacer()
                            .frame(width: 16)
                        Text(user.name)
                        Spacer()
                        Text(user.followingCount.description)
                            .frame(width: 48)
                        Text(user.followersCount.description)
                            .frame(width: 48)
                    }
                }
            }
            if isLoading {
                ProgressView()
                    .scaleEffect(2)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    Task {
                        isLoading = true
                        do {
                            userList = try await UserListRequest().execute()
                        } catch {
                            userList = []
                            self.error = .init(from: error)
                        }
                        isLoading = false
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .alert(error: $error)
        .task {
            userList = UserListRequest().expected
        }
    }
}

#Preview {
    NavigationStack {
        APIRequestView()
    }
}
