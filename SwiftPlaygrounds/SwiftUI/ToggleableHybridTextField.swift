import SwiftUI
import UIKit

struct ToggleableHybridTextField {
    @Binding private var text: String

    private let placeholder: String

    private var isSecure = false
    private var allowsCopyCut = true

    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
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
        textField.updateConfiguration(isSecure: isSecure, allowsCopyCut: allowsCopyCut)

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
        uiView.updateConfiguration(isSecure: isSecure, allowsCopyCut: allowsCopyCut)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
}

final class ToggleableTextField: UITextField {
    private var allowsCopyCut = true

    func updateConfiguration(isSecure: Bool, allowsCopyCut: Bool) {
        self.isSecureTextEntry = isSecure
        self.allowsCopyCut = allowsCopyCut
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if !allowsCopyCut,
           action == #selector(copy(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
