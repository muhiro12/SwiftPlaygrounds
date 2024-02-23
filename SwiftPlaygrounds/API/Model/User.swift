//
//  User.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct User: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let gender: Gender
    let followingCount: Int = Int.random(in: 0...10000)
    let followersCount: Int = Int.random(in: 0...10000)
}
