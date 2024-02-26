//
//  UserView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import SwiftUI

struct UserView: View {
    var userID: User.ID?
    var isPreview = false

    @Environment(\.dismiss)
    private var dismiss

    @State private var user: User?
    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
        VStack(spacing: 40) {
            Text(optional: user?.id)
            Text(optional: user?.name)
            Text(optional: user?.gender.rawValue)
            Text(optional: user?.likeCount.description)
            Text(optional: user?.dislikeCount.description)
        }
        .toolbar {
            if let user {
                Button {
                    Task {
                        isLoading = true
                        do {
                            _ = try await UserLikeRequest(id: user.id).execute()
                        } catch {
                            self.error = .init(from: error)
                        }
                        isLoading = false
                    }
                } label: {
                    Image(systemName: "hand.thumbsup")
                }
                Button {
                    Task {
                        isLoading = true
                        do {
                            _ = try await UserDislikeRequest(id: user.id).execute()
                        } catch {
                            self.error = .init(from: error)
                        }
                        isLoading = false
                    }
                } label: {
                    Image(systemName: "hand.thumbsdown")
                }
            }
        }
        .task {
            if isPreview {
                user = CurrentUserRequest().expected
                return
            }

            guard let userID else {
                return
            }

            isLoading = true
            do {
                self.user = try await UserRequest(id: userID).execute()
            } catch {
                self.error = .init(from: error)
            }
            isLoading = false
        }
        .progress(isLoading: $isLoading)
        .alert(error: $error) {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        UserView(isPreview: true)
    }
}
