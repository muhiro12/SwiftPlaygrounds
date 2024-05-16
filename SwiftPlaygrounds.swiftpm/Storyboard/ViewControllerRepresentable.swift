//
//  ViewControllerRepresentable.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    private let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
