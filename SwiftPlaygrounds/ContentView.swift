//
//  ContentView.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2022/01/04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(String(describing: SwiftDataItemsView.self)) {
                    SwiftDataItemsView()
                }
            }
            Text("To next view")
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        ContentView()
    }
}
