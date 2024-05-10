//
//  Student.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/04/16.
//

import Foundation
import SwiftData

@Model
final class Student {
    var name: String
    var score: Score?
    var grade: Grade?
    var clubs: [Club]?
    var createdAt: Date

    private init() {
        name = ""
        createdAt = .now
    }

    static func create(name: String, score: Score, grade: Grade, clubs: [Club], createdAt: Date) -> Student {
        let student = Student()
        student.name = name
        student.score = score
        student.grade = grade
        student.clubs = clubs
        student.createdAt = createdAt
        return student
    }
}

@Model
final class Score {
    var value: Int
    var student: Student?

    init(value: Int) {
        self.value = value
    }
}

@Model
final class Grade {
    var value: Int
    var students: [Student] = []

    init(value: Int) {
        self.value = value
    }
}

@Model
final class Club {
    var value: String
    var students: [Student] = []

    init(value: String) {
        self.value = value
    }
}
