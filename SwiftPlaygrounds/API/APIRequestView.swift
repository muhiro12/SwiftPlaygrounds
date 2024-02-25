//
//  APIRequestView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct APIRequestView: View {
    @State private var userList: [User] = []
    @State private var user: User?
    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
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
                .onTapGesture {
                    Task {
                        isLoading = true
                        do {
                            self.user = try await UserRequest(id: user.id).execute()
                        } catch {
                            self.error = .init(from: error)
                        }
                        isLoading = false
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    Task {
                        await loadUserList()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .sheet(item: $user) { user in
            NavigationStack {
                UserView(user: user)
            }
        }
        .task {
            await loadUserList()
        }
        .progress(isLoading: $isLoading)
        .alert(error: $error)
    }

    private func loadUserList() async {
        isLoading = true
        do {
            userList = try await UserListRequest().execute()
        } catch {
            userList = []
                self.error = .init(from: error)
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        APIRequestView()
    }
}
