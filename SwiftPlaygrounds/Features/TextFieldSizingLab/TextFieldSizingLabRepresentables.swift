import SwiftUI
import UIKit

struct BrokenDirectTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        configureTextField(textField, text: text, placeholder: placeholder)
        textField.addTarget(
            context.coordinator,
            action: #selector(TextFieldSizingCoordinator.textChanged(_:)),
            for: .editingChanged
        )
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        configureTextField(uiView, text: text, placeholder: placeholder)
    }

    func makeCoordinator() -> TextFieldSizingCoordinator {
        .init(text: $text)
    }
}

struct WrapperFixedTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> WrappedTextFieldContainerView {
        let wrapper = WrappedTextFieldContainerView()
        configureTextField(wrapper.textField, text: text, placeholder: placeholder)
        wrapper.textField.addTarget(
            context.coordinator,
            action: #selector(TextFieldSizingCoordinator.textChanged(_:)),
            for: .editingChanged
        )
        return wrapper
    }

    func updateUIView(_ uiView: WrappedTextFieldContainerView, context: Context) {
        configureTextField(uiView.textField, text: text, placeholder: placeholder)
    }

    func makeCoordinator() -> TextFieldSizingCoordinator {
        .init(text: $text)
    }
}

struct ProposedSizeTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        configureTextField(textField, text: text, placeholder: placeholder)
        textField.addTarget(
            context.coordinator,
            action: #selector(TextFieldSizingCoordinator.textChanged(_:)),
            for: .editingChanged
        )
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        configureTextField(uiView, text: text, placeholder: placeholder)
    }

    func makeCoordinator() -> TextFieldSizingCoordinator {
        .init(text: $text)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextField, context: Context) -> CGSize? {
        let intrinsicSize = uiView.intrinsicContentSize
        return .init(
            width: proposal.width ?? intrinsicSize.width,
            height: proposal.height ?? intrinsicSize.height
        )
    }
}

struct NoIntrinsicWidthSizingTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    func makeUIView(context: Context) -> NoIntrinsicWidthTextField {
        let textField = NoIntrinsicWidthTextField()
        configureTextField(textField, text: text, placeholder: placeholder)
        textField.addTarget(
            context.coordinator,
            action: #selector(TextFieldSizingCoordinator.textChanged(_:)),
            for: .editingChanged
        )
        return textField
    }

    func updateUIView(_ uiView: NoIntrinsicWidthTextField, context: Context) {
        configureTextField(uiView, text: text, placeholder: placeholder)
    }

    func makeCoordinator() -> TextFieldSizingCoordinator {
        .init(text: $text)
    }
}

final class TextFieldSizingCoordinator: NSObject {
    private let text: Binding<String>

    init(text: Binding<String>) {
        self.text = text
    }

    @objc
    func textChanged(_ sender: UITextField) {
        text.wrappedValue = sender.text ?? ""
    }
}

final class WrappedTextFieldContainerView: UIView {
    let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

final class NoIntrinsicWidthTextField: UITextField {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return .init(width: UIView.noIntrinsicMetric, height: size.height)
    }
}

private func configureTextField(_ textField: UITextField, text: String, placeholder: String) {
    if textField.text != text {
        textField.text = text
    }

    if textField.placeholder != placeholder {
        textField.placeholder = placeholder
    }

    textField.borderStyle = .roundedRect
    textField.textContentType = .username
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.spellCheckingType = .no
    textField.clearButtonMode = .whileEditing
}
