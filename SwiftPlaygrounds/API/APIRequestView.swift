//
//  APIRequestView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/23.
//

import SwiftUI

struct APIRequestView: View {
    @State private var user: User?

    var body: some View {
        VStack {
            Text(user?.name ?? "")
            Button("Execute") {
                Task {
                    do {
                        user = nil
                        user = try await UserRequest(name: "Apple").execute()
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
