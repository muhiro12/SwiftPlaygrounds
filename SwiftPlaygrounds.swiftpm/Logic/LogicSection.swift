import SwiftUI

enum LogicSection: String, ContentSection {
    case combine
    case concurrency
    case observation
    case swiftData
    case user

    var contents: [Route] {
        switch self {
        case .combine:
            [.combine,
             .combineDetail]
        case .concurrency:
            [.asyncStream,
             .actor]
        case .observation:
            [.observationUserList,
             .observationUser,
             .observableObjectUserList,
             .observableObjectUser,
             .publishedUserList,
             .publishedUser]
        case .swiftData:
            [.student]
        case .user:
            [.userList,
             .user,
             .groupingUserList]
        }
    }
}
