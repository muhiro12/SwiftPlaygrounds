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

    func allowsCopyCut(_ allowsCopyCut: Bool) -> Self {
        var copy = self
        copy.allowsCopyCut = allowsCopyCut
        return copy
    }

    func secure(_ isSecure: Bool) -> Self {
        var copy = self
        copy.isSecure = isSecure
        return copy
    }

    func error(_ isError: Bool) -> Self {
        var copy = self
        copy.isError = isError
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

        textField.configure(
            text: text,
            placeholder: placeholder,
            allowsCopyCut: allowsCopyCut,
            isSecure: isSecure,
            isError: isError
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
        uiView.configure(
            text: text,
            placeholder: placeholder,
            allowsCopyCut: allowsCopyCut,
            isSecure: isSecure,
            isError: isError
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
}

final class ToggleableTextField: UITextField {
    private let contentInsets = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)

    private var allowsCopyCut = true

    func configure(
        text: String,
        placeholder: String,
        allowsCopyCut: Bool,
        isSecure: Bool,
        isError: Bool
    ) {
        self.text = text
        self.placeholder = placeholder
        self.allowsCopyCut = allowsCopyCut
        self.isSecureTextEntry = isSecure

        font = .systemFont(ofSize: 24)
        backgroundColor = !isError ? .systemGreen.withAlphaComponent(0.3) : .systemRed.withAlphaComponent(0.3)
        layer.borderWidth = 1
        layer.borderColor = !isError ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        layer.cornerRadius = 4
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInsets)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if !allowsCopyCut,
           action == #selector(copy(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
