//
//  ObservableObjectUserView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

struct ObservableObjectUserView: View {
    var userID: User.ID?

    @Environment(\.dismiss)
    private var dismiss

    @StateObject private var store = ObservableObjectUserStore.shared

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
    NavigationView {
        ObservableObjectUserView()
    }
}
