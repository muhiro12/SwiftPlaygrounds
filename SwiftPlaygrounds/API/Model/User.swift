//
//  User.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct User: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var gender: Gender
    var followingCount: Int = Int.random(in: 0...10000)
    var followersCount: Int = Int.random(in: 0...10000)
}
