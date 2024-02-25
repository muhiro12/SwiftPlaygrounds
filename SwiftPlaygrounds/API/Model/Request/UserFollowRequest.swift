//
//  UserFollowRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/25.
//

import Foundation

struct UserFollowRequest: APIRequest {
    typealias Response = Empty

    let id: String

    let apiClient = APIClient()

    var expected: Empty {
        guard let index = ServerData.userList.firstIndex(where: { $0.id == id }) else {
            return .init()
        }
        let user = ServerData.userList[index]
        ServerData.userList[index] = User(id: user.id,
                                          name: user.name,
                                          gender: user.gender,
                                          followingCount: user.followingCount,
                                          followersCount: user.followersCount + Int.random(in: 100...1000))
        return .init()
    }
}

struct Empty {}
