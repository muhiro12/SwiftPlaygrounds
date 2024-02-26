//
//  APIClient.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct APIClient {
    func execute<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let statusCode = Int.random(in: 200...410)
        let delay = Double.random(in: 0...3)

        do {
            try await Task.sleep(for: .seconds(delay))
        } catch {
            throw APIError.undefined
        }

        if delay <= 0.1 {
            throw APIError.offline
        }

        if 2.9 <= delay {
            throw APIError.timeout
        }

        if 400 <= statusCode {
            throw APIError.serverError
        }

        return request.expected
    }
}
