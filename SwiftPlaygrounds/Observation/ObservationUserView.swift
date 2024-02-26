//
//  ObservationUserView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

struct ObservationUserView: View {
    var userID: User.ID?
    var isPreview = false

    @Environment(\.dismiss)
    private var dismiss

    @State private var store = ObservationUserStore.shared
    @State private var isLoading = false
    @State private var error: PlaygroundsError?

    var body: some View {
        VStack(spacing: 40) {
            Text(optional: store.user?.id)
            Text(optional: store.user?.name)
            Text(optional: store.user?.gender.rawValue)
            Text(optional: store.user?.likeCount.description)
            Text(optional: store.user?.dislikeCount.description)
        }
        .toolbar {
            if let id = store.user?.id {
                Button {
                    Task {
                        isLoading = true
                        do {
                            try await store.requestLike(id: id)
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
                            try await store.requestDislike(id: id)
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
                store.previewRequestCurrentUser()
                return
            }

            guard let userID else {
                return
            }

            isLoading = true
            do {
                try await store.requestUser(id: userID)
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

