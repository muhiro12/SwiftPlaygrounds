//
//  APIRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    var apiClient: APIClient { get }
    var expected: Response { get }
    func execute() async throws -> Response
}

extension APIRequest {
    func execute() async throws -> Response {
        try await apiClient.execute(self)
    }
}
