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
                HStack {
                    Text(user.name)
                    Spacer()
                    Circle()
                        .frame(width: 8)
                        .foregroundStyle({ () -> Color in
                            switch user.gender {
                            case .male: return .blue
                            case .female: return .red
                            case .other: return .green
                            }
                        }())
                }
            }
            Button("Reload") {
                Task {
                    do {
                        userList = []
                        userList = try await UserListRequest().execute()
                    } catch {
                        print(error)
                    }
                }
            }
        }.task {
            userList = UserListRequest().expected
        }
    }
}

#Preview {
    APIRequestView()
}
