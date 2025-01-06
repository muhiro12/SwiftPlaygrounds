//
//  SecureViewController.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 12/20/24.
//

import SwiftUI

final class SecureViewController: UIViewController {
    private let stackView = UIStackView()
    private let standardLabel = UILabel()
    private let secureLabel = UILabel()
    private let standardTextField = UITextField()
    private let secureTextField = UITextField()
    private let secureTextEntryTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].forEach { $0.isActive = true }

        [
            standardLabel,
            secureLabel,
            standardTextField,
            secureTextField,
            secureTextEntryTextField
        ].forEach(stackView.addArrangedSubview)

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually

        standardLabel.text = "Standard"

        secureLabel.text = "Secure"
        secureLabel.makeSecure()

        standardTextField.placeholder = "Standard"

        secureTextField.placeholder = "Secure"
        secureTextField.makeSecure()

        secureTextEntryTextField.placeholder = "Secure Text Entry"
        secureTextEntryTextField.isSecureTextEntry = true
    }
}

private extension UIView {
    func makeSecure() {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        guard let canvas = textField.subviews.first(where: {
            type(of: $0).description().contains("UITextLayoutCanvasView")
        }) else {
            return
        }
        canvas.translatesAutoresizingMaskIntoConstraints = false
        addSubview(canvas)
        [
            topAnchor.constraint(equalTo: canvas.topAnchor),
            leadingAnchor.constraint(equalTo: canvas.leadingAnchor),
            bottomAnchor.constraint(equalTo: canvas.bottomAnchor),
            trailingAnchor.constraint(equalTo: canvas.trailingAnchor),
        ].forEach { $0.isActive = true }
        layer.superlayer?.addSublayer(canvas.layer)
        canvas.layer.addSublayer(layer)
    }
}

struct SecureView: View {
    var body: some View {
        ViewControllerRepresentable {
            SecureViewController()
        }
    }
}

#Preview {
    SecureView()
}

