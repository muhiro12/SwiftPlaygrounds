//
//  UserDislikeRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import Foundation

struct UserDislikeRequest: APIRequest {
    typealias Response = User?

    let id: String

    let apiClient = APIClient()

    var expected: Response {
        guard let index = ServerData.userList.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        let user = ServerData.userList[index]
        ServerData.userList[index] = User(id: user.id,
                                          name: user.name,
                                          gender: user.gender,
                                          likeCount: user.likeCount,
                                          dislikeCount: user.dislikeCount + Int.random(in: 1...10))
        return ServerData.userList[index]
    }
}
