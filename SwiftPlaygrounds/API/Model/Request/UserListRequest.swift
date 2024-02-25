//
//  UserListRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct UserListRequest: APIRequest {
    typealias Response = [User]

    let apiClient = APIClient()

    var expected: [User] {
        ServerData.userList
    }
}
