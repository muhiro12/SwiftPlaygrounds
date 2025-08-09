//
//  User.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct User: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var gender: Gender
    var likeCount: Int = Int.random(in: 100...1000)
    var dislikeCount: Int = Int.random(in: 10...100)
}
