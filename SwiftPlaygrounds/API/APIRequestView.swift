//
//  APIRequestView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct APIRequestView: View {
    @State private var userList: [User] = []

    var body: some View {
        VStack {
            List(userList) { user in
                Text(user.name)
                    .foregroundStyle({ () -> Color in
                        switch user.gender {
                        case .male: return .blue
                        case .female: return .red
                        case .other: return .green
                        }
                    }())
            }
            Button("Execute") {
                Task {
                    do {
                        userList = []
                        userList = try await UserListRequest().execute()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    APIRequestView()
}
