import SwiftUI

struct TextFieldSizingLabView: View {
    @State private var text = SampleTextPreset.short.value

    private let fixedWidth = 100.0
    private let fixedHeight = 40.0

    private var fixedFrameDescription: String {
        "Each sample uses .frame(width: 100, height: 40)."
    }

    private var displayedSharedText: String {
        if text.isEmpty {
            return "(empty)"
        }

        return text
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                sharedStateSection

                SizingLabSampleSection(
                    title: "Broken: Direct UITextField",
                    detail: "Returning UITextField directly lets the intrinsic width override the fixed frame.",
                    fixedWidth: fixedWidth,
                    fixedHeight: fixedHeight
                ) {
                    BrokenDirectTextField(text: $text, placeholder: "Username")
                }

                SizingLabSampleSection(
                    title: "Article Fix: Wrapper UIView",
                    detail: "Wrapping the text field in a container view keeps SwiftUI focused on the outer frame.",
                    fixedWidth: fixedWidth,
                    fixedHeight: fixedHeight
                ) {
                    WrapperFixedTextField(text: $text, placeholder: "Username")
                }

                SizingLabSampleSection(
                    title: "Article Fix: sizeThatFits",
                    detail: "Custom sizeThatFits forwards the proposed width and height back to SwiftUI.",
                    fixedWidth: fixedWidth,
                    fixedHeight: fixedHeight
                ) {
                    ProposedSizeTextField(text: $text, placeholder: "Username")
                }

                SizingLabSampleSection(
                    title: "Extra Fix: No Intrinsic Width",
                    detail: "Removing the intrinsic width makes the fixed frame width win without a wrapper.",
                    fixedWidth: fixedWidth,
                    fixedHeight: fixedHeight
                ) {
                    NoIntrinsicWidthSizingTextField(text: $text, placeholder: "Username")
                }
            }
            .padding()
        }
        .navigationTitle("Text Field Sizing Lab")
    }

    private var sharedStateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shared State")
                .font(.title3.weight(.semibold))

            Text("Type in any sample below. All four fields stay synchronized.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Text("Shared text")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(displayedSharedText)
                    .font(.body.monospaced())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.secondary.opacity(0.12))
                    }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Presets")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    ForEach(SampleTextPreset.allCases, id: \.self) { preset in
                        presetButton(for: preset)
                    }
                }
            }

            Text(fixedFrameDescription)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private func presetButton(for preset: SampleTextPreset) -> some View {
        Button(preset.title) {
            text = preset.value
        }
        .font(.footnote.weight(.semibold))
        .foregroundStyle(text == preset.value ? Color.white : Color.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(text == preset.value ? Color.accentColor : Color.secondary.opacity(0.16))
        }
    }
}

private struct SizingLabSampleSection<Content: View>: View {
    let title: String
    let detail: String
    let fixedWidth: CGFloat
    let fixedHeight: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            Text(detail)
                .font(.footnote)
                .foregroundStyle(.secondary)

            content()
                .frame(width: fixedWidth, height: fixedHeight, alignment: .leading)
                .background(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            style: .init(lineWidth: 1, dash: [5, 4])
                        )
                        .foregroundStyle(.secondary)
                        .frame(width: fixedWidth, height: fixedHeight)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Guide: 100 x 40")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private enum SampleTextPreset: CaseIterable {
    case empty
    case short
    case long

    var title: String {
        switch self {
        case .empty:
            return "Empty"
        case .short:
            return "Short"
        case .long:
            return "Long"
        }
    }

    var value: String {
        switch self {
        case .empty:
            return ""
        case .short:
            return "abc"
        case .long:
            return "abcdefghijklmno"
        }
    }
}

#Preview {
    NavigationStack {
        TextFieldSizingLabView()
    }
}
