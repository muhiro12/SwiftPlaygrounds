//
//  StoryboardViewController.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

final class StoryboardViewController: UIViewController {}

struct StoryboardView: View {
    var body: some View {
        ViewControllerRepresentable("Storyboard")
    }
}

#Preview {
    StoryboardView()
}
