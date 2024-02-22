//
//  UserRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct UserRequest: APIRequest {
    typealias Response = User

    let name: String

    let apiClient = APIClient()
    
    var expected: User {
        .init(name: name)
    }
}
