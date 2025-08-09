//
//  APIError.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

enum APIError: Error {
    case undefined
    case offline
    case timeout
    case serverError
}
