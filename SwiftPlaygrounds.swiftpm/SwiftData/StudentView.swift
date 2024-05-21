//
//  StudentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/04/16.
//

import SwiftUI
import SwiftData

struct StudentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Student.createdAt, order: .reverse) private var students: [Student]

    var body: some View {
        NavigationStack {
            List(students) { student in
                Section {
                    HStack {
                        Text("Name")
                            .font(.headline)
                            .frame(width: 80)
                        Text(student.name)
                    }
                    HStack {
                        Text("Score")
                            .font(.headline)
                            .frame(width: 80)
                        NavigationLink(student.score?.value.description ?? "", value: student.score)
                    }
                    HStack {
                        Text("Grade")
                            .font(.headline)
                            .frame(width: 80)
                        NavigationLink(student.grade?.value.description ?? "", value: student.grade)
                    }
                    if student.clubs?.isEmpty == true {
                            HStack {
                                Text("Clubs")
                                    .font(.headline)
                                    .frame(width: 80)
                            }
                    } else {
                        ForEach(student.clubs ?? []) { club in
                            HStack {
                                Text(student.clubs?.firstIndex(of: club) == 0 ? "Clubs" : "")
                                    .font(.headline)
                                    .frame(width: 80)
                                NavigationLink(club.value, value: club)
                            }
                        }
                    }
                    HStack {
                        Text("Created at")
                            .font(.headline)
                            .frame(width: 80)
                       Text(student.createdAt.description)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add", systemImage: "dice") {
                        modelContext.insert(
                            Student.create(
                                name: "Student " + Int.random(in: 0...1000).description,
                                score: .init(value: .random(in: 1...5)),
                                grade: .init(value: .random(in: 1...3)),
                                clubs: (0...Int.random(in: 0...2)).map { _ in
                                    Club(value: "Club " + Int.random(in: 0...10).description)
                                },
                                createdAt: .now
                            )
                        )
                    }
                }
            }
            .navigationDestination(for: Score.self) {
                List([$0.student].compactMap { $0 }) {
                    Text($0.name)
                }
                .navigationTitle("Score " + $0.value.description)
            }
            .navigationDestination(for: Grade.self) {
                List($0.students) {
                    Text($0.name)
                }
                .navigationTitle("Grade" + $0.value.description)
            }
            .navigationDestination(for: Club.self) {
                List($0.students) {
                    Text($0.name)
                }
                .navigationTitle($0.value)
            }
        }
    }
}

#Preview {
    StudentView()
        .modelContainer(for: Student.self, inMemory: true)
}
