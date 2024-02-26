//
//  ViewControllerRepresentable.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    init(_ name: String) {
        self.name = name
    }

    private let name: String

    func makeUIViewController(context: Context) -> UIViewController {
        UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
