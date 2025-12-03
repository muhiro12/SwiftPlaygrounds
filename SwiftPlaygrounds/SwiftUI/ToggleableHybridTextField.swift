import SwiftUI
import UIKit

struct ToggleableHybridTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String
    private var isSecure = false
    private var allowsCopyCut = true

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> ToggleableTextField {
        let textField = ToggleableTextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.updateConfiguration(isSecure: isSecure, allowsCopyCut: allowsCopyCut)
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(TextFieldCoordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: ToggleableTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
        uiView.updateConfiguration(isSecure: isSecure, allowsCopyCut: allowsCopyCut)
    }

    func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(text: $text)
    }

    func secure(_ isSecure: Bool) -> ToggleableHybridTextField {
        var copy = self
        copy.isSecure = isSecure
        return copy
    }

    func allowsCopyCut(_ allowsCopyCut: Bool) -> ToggleableHybridTextField {
        var copy = self
        copy.allowsCopyCut = allowsCopyCut
        return copy
    }
}

final class ToggleableTextField: UITextField {
    private var allowsCopyCut = true

    func updateConfiguration(isSecure: Bool, allowsCopyCut: Bool) {
        self.allowsCopyCut = allowsCopyCut
        if isSecureTextEntry != isSecure {
            let currentText = text
            isSecureTextEntry = isSecure
            text = currentText
        }
        applyInputConfiguration(isSecure: isSecure)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(copy(_:)) || action == #selector(cut(_:))) && !allowsCopyCut {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension UITextField {
    func applyInputConfiguration(isSecure: Bool) {
        textContentType = isSecure ? .password : .username
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
    }
}
