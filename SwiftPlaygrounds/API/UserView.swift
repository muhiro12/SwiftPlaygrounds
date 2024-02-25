//
//  UserView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import SwiftUI

struct UserView: View {
    var user: User?

    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
        if let user {
            VStack(spacing: 40) {
                Text(user.id)
                Text(user.name)
                Text(String(describing: user.gender))
                Text(user.followingCount.description)
                Text(user.followersCount.description)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            isLoading = true
                            do {
                                _ = try await UserFollowRequest(id: user.id).execute()
                            } catch {
                                self.error = .init(from: error)
                            }
                            isLoading = false
                        }
                    } label: {
                        Image(systemName: "heart")
                    }
                }
            }
            .progress(isLoading: $isLoading)
            .alert(error: $error)
        }
    }
}

#Preview {
    NavigationStack {
        UserView(user: .init(name: "Name", gender: .other))
    }
}
