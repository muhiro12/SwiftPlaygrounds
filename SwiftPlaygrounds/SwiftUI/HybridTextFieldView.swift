import SwiftUI
import UIKit

struct HybridTextFieldView: View {
    @State private var swiftUIText1 = ""
    @State private var swiftUIText2 = ""

    @State private var uiKitText1 = ""
    @State private var uiKitText2 = ""

    @State private var customText1 = ""
    @State private var customText2 = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("SwiftUI Field 1")
                    TextField("SwiftUI Field 1", text: $swiftUIText1)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                    Text("SwiftUI Field 2 (copy/cut disabled)")
                    SwiftUINoCopyCutTextField(text: $swiftUIText2,
                                              placeholder: "SwiftUI Field 2")
                        .frame(height: 44)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("UIKit Field 1")
                    UIKitTextField(text: $uiKitText1, placeholder: "UIKit Field 1")
                        .frame(height: 44)

                    Text("UIKit Field 2 (copy/cut disabled)")
                    UIKitNoCopyCutTextField(text: $uiKitText2,
                                            placeholder: "UIKit Field 2")
                        .frame(height: 44)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom UIKit Field 1")
                    CustomUIKitTextField(text: $customText1, placeholder: "Custom UIKit Field 1")
                        .frame(height: 44)

                    Text("Custom UIKit Field 2 (copy/cut disabled)")
                    CustomUIKitNoCopyCutTextField(text: $customText2,
                                                  placeholder: "Custom UIKit Field 2")
                        .frame(height: 44)
                }
            }
            .padding()
        }
        .navigationTitle("Hybrid Text Fields")
    }
}

private struct SwiftUINoCopyCutTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

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

private struct UIKitTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

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

private struct UIKitNoCopyCutTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

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

private struct CustomUIKitTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

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

private struct CustomUIKitNoCopyCutTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

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

private final class TextFieldCoordinator: NSObject, UITextFieldDelegate {
    private var text: Binding<String>

    init(text: Binding<String>) {
        self.text = text
    }

    @objc
    func textChanged(_ sender: UITextField) {
        text.wrappedValue = sender.text ?? ""
    }
}

private class NoCopyCutTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return true//super.canPerformAction(action, withSender: sender)
    }
}

private class RoundedTextField: UITextField {
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

private final class RoundedNoCopyCutTextField: RoundedTextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

private extension UITextField {
    func applyUsernameConfiguration() {
        textContentType = .username
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
    }
}

#Preview {
    NavigationStack {
        HybridTextFieldView()
    }
}
