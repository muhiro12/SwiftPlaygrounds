//
//  UserRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct UserRequest: APIRequest {
    typealias Response = User?

    let id: String

    let apiClient = APIClient()

    var expected: Response {
        ServerData.userList.first { $0.id == id }
    }
}
