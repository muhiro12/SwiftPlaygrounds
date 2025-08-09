//
//  ObservableObjectUserListView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

struct ObservableObjectUserListView: View {
    @StateObject private var store = ObservableObjectUserStore.shared

    @State private var selectedUserID: User.ID?
    @State private var isCurrentUserPresented = false
    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
        List(store.userList, selection: $selectedUserID) { user in
            HStack {
                Circle()
                    .frame(width: 8)
                    .foregroundStyle(user.gender.color)
                Spacer()
                    .frame(width: 16)
                Text(user.name)
                    .fontWeight(store.currentUser == user ? .bold : nil)
                Spacer()
                Text(user.likeCount.description)
                    .frame(width: 48)
                Text(user.dislikeCount.description)
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
            .disabled(store.currentUser == nil)
        }
        .sheet(isPresented: $isCurrentUserPresented) {
            NavigationStack {
                ObservableObjectUserView(userID: store.currentUser?.id)
            }
        }
        .sheet(item: $selectedUserID) { userID in
            NavigationStack {
                ObservableObjectUserView(userID: userID)
            }
        }
        .task {
            await load()
        }
        .progress(isLoading: $isLoading)
        .alert(error: $error)
    }

    private func load() async {
        isLoading = true
        do {
            async let request0: () = store.requestCurrentUser()
            async let request1: () = store.requestUserList()
            _ = try await (request0, request1)
        } catch {
            self.error = .init(from: error)
        }
        isLoading = false
    }
}

#Preview {
    NavigationView {
        ObservableObjectUserListView()
    }
}
