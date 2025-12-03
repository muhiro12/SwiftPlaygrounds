import SwiftUI
import UIKit

struct ToggleableHybridTextField {
    @Binding private var text: String

    private let placeholder: String

    private var isError = false
    private var isSecure = false
    private var allowsCopyCut = true

    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    func error(_ isError: Bool) -> Self {
        var copy = self
        copy.isError = isError
        return copy
    }

    func secure(_ isSecure: Bool) -> Self {
        var copy = self
        copy.isSecure = isSecure
        return copy
    }

    func allowsCopyCut(_ allowsCopyCut: Bool) -> Self {
        var copy = self
        copy.allowsCopyCut = allowsCopyCut
        return copy
    }
}

extension ToggleableHybridTextField: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        private let text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        @objc
        func textChanged(_ sender: UITextField) {
            text.wrappedValue = sender.text ?? ""
        }
    }

    func makeUIView(context: Context) -> ToggleableTextField {
        let textField = ToggleableTextField()
        textField.text = text
        textField.placeholder = placeholder
        textField.updateConfiguration(
            isError: isError,
            isSecure: isSecure,
            allowsCopyCut: allowsCopyCut
        )
        textField.delegate = context.coordinator
        textField.addTarget(
            context.coordinator,
            action: #selector(context.coordinator.textChanged),
            for: .editingChanged
        )
        return textField
    }

    func updateUIView(_ uiView: ToggleableTextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.updateConfiguration(
            isError: isError,
            isSecure: isSecure,
            allowsCopyCut: allowsCopyCut
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
}

final class ToggleableTextField: UITextField {
    private let insets = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)

    private var allowsCopyCut = true

    func updateConfiguration(isError: Bool, isSecure: Bool, allowsCopyCut: Bool) {
        self.isSecureTextEntry = isSecure
        self.allowsCopyCut = allowsCopyCut

        font = .systemFont(ofSize: 24)
        backgroundColor = !isError ? .systemGreen.withAlphaComponent(0.3) : .systemRed.withAlphaComponent(0.3)
        layer.borderWidth = 1
        layer.borderColor = !isError ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        layer.cornerRadius = 4
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if !allowsCopyCut,
           action == #selector(copy(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
