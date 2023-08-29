//
//  SwiftPlaygroundsApp.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2022/01/04.
//

import SwiftUI
import SwiftData

@main
struct SwiftPlaygroundsApp: App {
    private let container = {
        let url = URL.applicationSupportDirectory.appendingPathComponent("SwiftPlaygrounds.sqlite")
        let configuration = ModelConfiguration(url: url)
        return try! ModelContainer(for: Item.self, configurations: configuration)
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
