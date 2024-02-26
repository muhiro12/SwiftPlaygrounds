//
//  APIRequestView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct APIRequestView: View {
    var isPreview = false

    @State private var userList: [User] = []
    @State private var currentUser: User?
    @State private var selectedUserID: User.ID?
    @State private var isCurrentUserPresented = false
    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
        List(userList, selection: $selectedUserID) { user in
            HStack {
                Circle()
                    .frame(width: 8)
                    .foregroundStyle(user.gender.color)
                Spacer()
                    .frame(width: 16)
                Text(user.name)
                    .fontWeight(currentUser == user ? .bold : nil)
                Spacer()
                Text(user.followingCount.description)
                    .frame(width: 48)
                Text(user.followersCount.description)
                    .frame(width: 48)
            }
        }
        .toolbar {
            Button {
                Task {
                    await load()
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            Button {
                isCurrentUserPresented = true
            } label: {
                Image(systemName: "person.circle")
            }
            .disabled(currentUser == nil)
        }
        .sheet(isPresented: $isCurrentUserPresented) {
            NavigationStack {
                UserView(userID: currentUser?.id)
            }
        }
        .sheet(item: $selectedUserID) { userID in
            NavigationStack {
                UserView(userID: userID)
            }
        }
        .task {
            if isPreview {
                currentUser = CurrentUserRequest().expected
                userList = UserListRequest().expected
                return
            }

            await load()
        }
        .progress(isLoading: $isLoading)
        .alert(error: $error)
    }

    private func load() async {
        isLoading = true
        do {
            async let request0 = CurrentUserRequest().execute()
            async let request1 = UserListRequest().execute()
            let result = try await (request0, request1)
            currentUser = result.0
            userList = result.1
        } catch {
            self.error = .init(from: error)
        }
        isLoading = false
    }
}

#Preview {
    NavigationView {
        APIRequestView(isPreview: true)
    }
}
