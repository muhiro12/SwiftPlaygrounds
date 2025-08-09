//
//  GroupingUserListView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 12/9/24.
//

import SwiftUI

struct GroupingUserListView: View {
    struct DTO {
        let gender: Gender
        let subList: [SubDTO]
    }

    struct SubDTO {
        let character: String
        let userList: [User]
    }

    enum SortOption {
        case character
        case likeCount
    }

    @State private var dtoList: [DTO] = .empty
    @State private var userList: [User] = .empty
    @State private var sortOption: SortOption = .character

    var body: some View {
        List(dtoList, id: \.gender) { dto in
            Section(dto.gender.rawValue) {
                ForEach(dto.subList, id: \.character) { subDTO in
                    ForEach(subDTO.userList) { user in
                        HStack {
                            Circle()
                                .frame(width: 8)
                                .foregroundStyle(user.gender.color)
                            Spacer()
                                .frame(width: 16)
                            Text(user.name)
                            Spacer()
                            Text(user.likeCount.description)
                                .frame(width: 48)
                            Text(user.dislikeCount.description)
                                .frame(width: 48)
                        }
                    }
                    if sortOption == .character,
                       subDTO.character != dto.subList.last?.character {
                        Color.secondary
                            .frame(height: 16)
                    }
                }
            }
        }
        .toolbar {
            Button {
                sortOption = sortOption == .character ? .likeCount : .character
                sort()
            } label: {
                Image(systemName: "arrow.up.and.down.text.horizontal")
            }
        }
        .task {
            userList = UserListRequest().expected
            sort()
        }
    }
}

private extension GroupingUserListView {
    func sort() {
        dtoList = Dictionary(grouping: userList, by: \.gender).map {
            .init(
                gender: $0.key,
                subList: Dictionary(grouping: $0.value) {
                    switch sortOption {
                    case .character:
                        .init($0.name.first!)
                    case .likeCount:
                        ""
                    }
                }.map {
                    .init(
                        character: $0.key,
                        userList: $0.value.sorted {
                            switch sortOption {
                            case .character:
                                $0.name < $1.name
                            case .likeCount:
                                $0.likeCount > $1.likeCount
                            }
                        }
                    )
                }.sorted {
                    $0.character < $1.character
                }
            )
        }.sorted {
            $0.gender.rawValue < $1.gender.rawValue
        }
    }
}

#Preview {
    NavigationView {
        GroupingUserListView()
    }
}
