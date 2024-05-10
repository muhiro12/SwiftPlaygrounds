//
//  ObservationUserStore.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import Foundation

@Observable final class ObservationUserStore {
    static let shared = ObservationUserStore()

    private init() {}

    private(set) var userList: [User] = []
    private(set) var currentUser: User? {
        didSet {
            updateList(old: oldValue, new: currentUser)
        }
    }
    private(set) var user: User? {
        didSet {
            updateList(old: oldValue, new: user)
        }
    }

    func requestUserList() async throws {
        userList = try await UserListRequest().execute()
    }

    func requestCurrentUser() async throws {
        currentUser = try await CurrentUserRequest().execute()
    }

    func requestUser(id: String) async throws {
        user = try await UserRequest(id: id).execute()
    }

    func requestLike(id: String) async throws {
        user = try await UserLikeRequest(id: id).execute()
    }

    func requestDislike(id: String) async throws {
        user = try await UserLikeRequest(id: id).execute()
    }

    private func updateList(old: User?, new: User?) {
        guard let old, let new else {
            return
        }
        userList = userList.replacing([old], with: [new])
    }
}

