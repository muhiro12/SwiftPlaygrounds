import SwiftUI

struct HybridTextFieldView: View {
    @State private var toggleableText = ""
    @State private var isSecureEntry = false
    @State private var allowsCopyCut = true

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
                    Text("Toggleable Secure / Copy-Cut Field")
                    ToggleableHybridTextField(
                        text: $toggleableText,
                        placeholder: "Toggleable Field"
                    )
                    .allowsCopyCut(allowsCopyCut)
                    .secure(isSecureEntry)
                    .error(toggleableText.count > 6)
                    .frame(height: 44)

                    HStack {
                        Button(isSecureEntry ? "Disable Secure" : "Enable Secure",
                               systemImage: isSecureEntry ? "eye" : "eye.slash") {
                            isSecureEntry.toggle()
                        }
                        .buttonStyle(.bordered)

                        Button(allowsCopyCut ? "Disable Copy/Cut" : "Enable Copy/Cut",
                               systemImage: "doc.on.doc") {
                            allowsCopyCut.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .font(.footnote)
                    .tint(.blue)

                    Text("Secure: \(isSecureEntry ? "On" : "Off"), Copy/Cut: \(allowsCopyCut ? "Enabled" : "Disabled")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

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

#Preview {
    NavigationStack {
        HybridTextFieldView()
    }
}
