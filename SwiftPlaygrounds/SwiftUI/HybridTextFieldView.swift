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
                VStack(spacing: 12) {
                    Text("SwiftUI Text Fields")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("SwiftUI Text Field 1", text: $swiftUIText1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("SwiftUI Text Field 2", text: $swiftUIText2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))

                VStack(spacing: 12) {
                    Text("UIKit Text Fields")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    UIKitTextField(text: $uiKitText1, placeholder: "UIKit Text Field 1")
                        .frame(height: 44)

                    UIKitTextField(text: $uiKitText2, placeholder: "UIKit Text Field 2")
                        .frame(height: 44)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))

                VStack(spacing: 12) {
                    Text("Custom UIKit Text Fields")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    CustomUIKitTextField(text: $customText1, placeholder: "Custom UIKit Text Field 1")
                        .frame(height: 44)

                    CustomUIKitTextField(text: $customText2, placeholder: "Custom UIKit Text Field 2")
                        .frame(height: 44)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
            }
            .padding()
        }
        .navigationTitle("Hybrid Text Fields")
    }
}

private struct UIKitTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        private var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        @objc
        func textChanged(_ sender: UITextField) {
            text.wrappedValue = sender.text ?? ""
        }
    }
}

private struct CustomUIKitTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

    func makeUIView(context: Context) -> RoundedTextField {
        let textField = RoundedTextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: RoundedTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        private var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        @objc
        func textChanged(_ sender: UITextField) {
            text.wrappedValue = sender.text ?? ""
        }
    }
}

private final class RoundedTextField: UITextField {
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

#Preview {
    NavigationStack {
        HybridTextFieldView()
    }
}
