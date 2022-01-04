//
//  SwiftPlaygroundsApp.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2022/01/04.
//

import SwiftUI

@main
struct SwiftPlaygroundsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
