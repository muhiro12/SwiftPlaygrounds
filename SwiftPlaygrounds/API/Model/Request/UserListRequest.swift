//
//  UserListRequest.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import Foundation

struct UserListRequest: APIRequest {
    typealias Response = [User]

    var apiClient = APIClient()

    var expected: [User] {
        (maleNameList.map { User(name: $0, gender: .male) }
         + femaleNameList.map { User(name: $0, gender: .female) }
         + otherNameList.map { User(name: $0, gender: .other) })
        .shuffled()
    }

    private let maleNameList = [
        "Michael",
        "James",
        "John",
        "Robert",
        "David",
        "William",
        "Richard",
        "Joseph",
        "Charles",
        "Thomas",
        "Christopher",
        "Daniel",
        "Matthew",
        "George",
        "Anthony",
        "Mark",
        "Edward",
        "Steven",
        "Paul",
        "Andrew"
    ]

    private let femaleNameList = [
        "Mary",
        "Jennifer",
        "Linda",
        "Elizabeth",
        "Susan",
        "Jessica",
        "Sarah",
        "Karen",
        "Nancy",
        "Margaret",
        "Lisa",
        "Betty",
        "Dorothy",
        "Sandra",
        "Ashley",
        "Kimberly",
        "Donna",
        "Emily",
        "Michelle",
        "Carol"
    ]

    private let otherNameList = [
        "Alex",
        "Jordan",
        "Taylor",
        "Morgan",
        "Casey",
        "Skyler",
        "Quinn",
        "Jamie",
        "Avery",
        "Riley",
        "Peyton",
        "Cameron",
        "Sage",
        "Dakota",
        "Rowan",
        "Robin",
        "Charlie",
        "Sam",
        "Emerson",
        "Finley"
    ]
}
