import SwiftUI
import UIKit

struct SwiftUINoCopyCutTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> NoCopyCutTextField {
        let textField = NoCopyCutTextField()
        textField.borderStyle = .roundedRect
        textField.text = text
        textField.placeholder = placeholder
        textField.applyUsernameConfiguration()
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(TextFieldCoordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: NoCopyCutTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
        uiView.applyUsernameConfiguration()
    }

    func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(text: $text)
    }
}

struct UIKitTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.text = text
        textField.applyUsernameConfiguration()
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(TextFieldCoordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
        uiView.applyUsernameConfiguration()
    }

    func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(text: $text)
    }
}

struct UIKitNoCopyCutTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> NoCopyCutTextField {
        let textField = NoCopyCutTextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.text = text
        textField.applyUsernameConfiguration()
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(TextFieldCoordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: NoCopyCutTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
        uiView.applyUsernameConfiguration()
    }

    func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(text: $text)
    }
}

struct CustomUIKitTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> RoundedTextField {
        let textField = RoundedTextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.applyUsernameConfiguration()
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(TextFieldCoordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: RoundedTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
        uiView.applyUsernameConfiguration()
    }

    func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(text: $text)
    }
}

struct CustomUIKitNoCopyCutTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> RoundedNoCopyCutTextField {
        let textField = RoundedNoCopyCutTextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.applyUsernameConfiguration()
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(TextFieldCoordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: RoundedNoCopyCutTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
        uiView.applyUsernameConfiguration()
    }

    func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(text: $text)
    }
}

final class TextFieldCoordinator: NSObject, UITextFieldDelegate {
    private let text: Binding<String>

    init(text: Binding<String>) {
        self.text = text
    }

    @objc
    func textChanged(_ sender: UITextField) {
        text.wrappedValue = sender.text ?? ""
    }
}

final class NoCopyCutTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return true
    }
}

class RoundedTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        borderStyle = .none
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

final class RoundedNoCopyCutTextField: RoundedTextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension UITextField {
    func applyUsernameConfiguration() {
        textContentType = .username
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
    }
}
