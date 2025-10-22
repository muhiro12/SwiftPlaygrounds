//
//  CurrentUserRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import Foundation

struct CurrentUserRequest: APIRequest {
    typealias Response = User?

    let apiClient = APIClient()

    var expected: Response {
        ServerData.userList.first
    }
}
