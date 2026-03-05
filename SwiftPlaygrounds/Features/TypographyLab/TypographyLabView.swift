import Foundation
import SwiftUI

enum TypographySwiftUITextMode: String, CaseIterable, Identifiable {
    case `default`
    case kerningZero
    case trackingZero
    case bridgedUIFont

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .default:
            return "A) Text + .font(.custom)"
        case .kerningZero:
            return "B) A + .kerning(0)"
        case .trackingZero:
            return "C) A + .tracking(0)"
        case .bridgedUIFont:
            return "D) Text + .font(Font(uiFont))"
        }
    }

    var fontSourceDescription: String {
        switch self {
        case .default:
            return ".custom(\"HiraginoSans-W3\", size:)"
        case .kerningZero:
            return ".custom + .kerning(0)"
        case .trackingZero:
            return ".custom + .tracking(0)"
        case .bridgedUIFont:
            return "Font(uiFont)"
        }
    }
}

struct TypographySwiftUITextDiagnostics: Equatable {
    let mode: TypographySwiftUITextMode
    let fontSourceDescription: String
    let requestedFontName: String
    let resolvedFontName: String
    let pointSize: CGFloat
    let isFallbackFont: Bool
    let drawingGroupEnabled: Bool

    var logLine: String {
        "\(mode.rawValue) | source=\(fontSourceDescription) | font=\(resolvedFontName) | pointSize=\(String(format: "%.2f", Double(pointSize))) | requested=\(requestedFontName) | fallback=\(isFallbackFont) | drawingGroup=\(drawingGroupEnabled)"
    }
}

struct TypographyLabDebugSnapshot: Equatable {
    let sampleText: String
    let fontSize: Double
    let adjustsFontForContentSizeCategory: Bool
    let drawingGroupEnabled: Bool
    let kernMode: TypographyKernMode
    let requestedFontName: String
    let resolvedFontName: String
    let resolvedPointSize: CGFloat
    let isFallbackFont: Bool
    let uikitDiagnostics: [TypographyUILabelDiagnostics]
    let swiftUIDiagnostics: [TypographySwiftUITextDiagnostics]

    var logLines: [String] {
        var lines: [String] = []
        lines.append(
            "settings | text=\(sampleText) | fontSize=\(String(format: "%.1f", fontSize)) | uiKitKern=\(kernMode.title) | uiKitAdjustsForDynamicType=\(adjustsFontForContentSizeCategory) | swiftUIDrawingGroup=\(drawingGroupEnabled)"
        )
        lines.append(
            "baseFont | requested=\(requestedFontName) | resolved=\(resolvedFontName) | pointSize=\(String(format: "%.2f", Double(resolvedPointSize))) | fallback=\(isFallbackFont)"
        )

        for diagnostics in uikitDiagnostics {
            lines.append("uiKit | \(diagnostics.logLine)")
        }

        for diagnostics in swiftUIDiagnostics {
            lines.append("swiftUI | \(diagnostics.logLine)")
        }

        return lines
    }

    var debugText: String {
        logLines.joined(separator: "\n")
    }
}

private enum LocalizationInterpretationVariant: String, CaseIterable, Identifiable {
    case textLocalizedLiteral
    case textVerbatimLiteral
    case textLocalizedStringKey
    case textDynamicString

    var id: String {
        rawValue
    }

    var label: String {
        switch self {
        case .textLocalizedLiteral:
            return "L1 Text(\"BANK口座\")"
        case .textVerbatimLiteral:
            return "L2 Text(verbatim: \"BANK口座\")"
        case .textLocalizedStringKey:
            return "L3 Text(LocalizedStringKey(\"BANK口座\"))"
        case .textDynamicString:
            return "L4 Text(String(\"BANK口座\"))"
        }
    }
}

private struct LocalizationDebugRow: Identifiable {
    let id: String
    let title: String
    let value: String
}

struct TypographyLabView: View {
    private let sampleText = "BANK口座"
    private let requestedFontName = "HiraginoSans-W3"

    @State private var fontSize: Double = 24
    @State private var adjustsFontForContentSizeCategory = false
    @State private var isDrawingGroupEnabled = false
    @State private var selectedKernMode: TypographyKernMode = .none
    @State private var uikitDiagnosticsByMode: [TypographyUILabelMode: TypographyUILabelDiagnostics] = [:]
    @State private var lastLoggedSnapshot: TypographyLabDebugSnapshot?

    private var baseFontResolution: TypographyResolvedFont {
        TypographyFontResolver.resolveBaseFont(
            requestedFontName: requestedFontName,
            pointSize: CGFloat(fontSize)
        )
    }

    private var orderedUIKitDiagnostics: [TypographyUILabelDiagnostics] {
        TypographyUILabelMode.displayOrder.compactMap {
            uikitDiagnosticsByMode[$0]
        }
    }

    private var swiftUIDiagnostics: [TypographySwiftUITextDiagnostics] {
        TypographySwiftUITextMode.allCases.map { mode in
            let resolvedFontName: String
            let pointSize: CGFloat

            switch mode {
            case .bridgedUIFont:
                resolvedFontName = baseFontResolution.resolvedFontName
                pointSize = baseFontResolution.uiFont.pointSize
            case .default, .kerningZero, .trackingZero:
                if baseFontResolution.isFallback {
                    resolvedFontName = "inferred fallback: \(baseFontResolution.resolvedFontName)"
                } else {
                    resolvedFontName = requestedFontName
                }
                pointSize = CGFloat(fontSize)
            }

            return .init(
                mode: mode,
                fontSourceDescription: mode.fontSourceDescription,
                requestedFontName: requestedFontName,
                resolvedFontName: resolvedFontName,
                pointSize: pointSize,
                isFallbackFont: baseFontResolution.isFallback,
                drawingGroupEnabled: isDrawingGroupEnabled
            )
        }
    }

    private var debugSnapshot: TypographyLabDebugSnapshot {
        .init(
            sampleText: sampleText,
            fontSize: fontSize,
            adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory,
            drawingGroupEnabled: isDrawingGroupEnabled,
            kernMode: selectedKernMode,
            requestedFontName: requestedFontName,
            resolvedFontName: baseFontResolution.resolvedFontName,
            resolvedPointSize: baseFontResolution.uiFont.pointSize,
            isFallbackFont: baseFontResolution.isFallback,
            uikitDiagnostics: orderedUIKitDiagnostics,
            swiftUIDiagnostics: swiftUIDiagnostics
        )
    }

    private var cardBackgroundColor: Color {
        Color(uiColor: .secondarySystemBackground)
    }

    private var sampleBackgroundColor: Color {
        Color(uiColor: .tertiarySystemBackground)
    }

    private var sampleRowMinimumHeight: CGFloat {
        max(56, CGFloat(fontSize) * 1.9)
    }

    private var localizationDebugRows: [LocalizationDebugRow] {
        [
            .init(
                id: "literal-bank",
                title: "Literal \"BANK口座\"",
                value: sampleText
            ),
            .init(
                id: "localized-bank",
                title: "Localized \"BANK口座\"",
                value: localizedValue(for: sampleText)
            )
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                controlsSection
                comparisonSection
                localizationInterpretationSection
                debugSection
            }
            .padding()
        }
        .navigationTitle("Typography Lab")
        .onAppear {
            emitDebugLogs(snapshot: debugSnapshot, force: true)
        }
        .onChange(of: debugSnapshot) {
            _, newValue in
            emitDebugLogs(snapshot: newValue)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Typography Lab")
                .font(.title.bold())
            Text("Compare spacing between UIKit UILabel and SwiftUI Text using BANK口座 with controlled font settings.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Controls")
                .font(.headline)

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Font size")
                        Spacer()
                        Text("\(Int(fontSize)) pt")
                            .monospacedDigit()
                    }
                    Slider(value: $fontSize, in: 10...40, step: 1)
                }

                Toggle(
                    "UILabel adjustsFontForContentSizeCategory",
                    isOn: $adjustsFontForContentSizeCategory
                )

                Toggle(
                    "SwiftUI drawingGroup()",
                    isOn: $isDrawingGroupEnabled
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("UILabel kern mode")
                        .font(.subheadline)
                    Picker("UILabel kern mode", selection: $selectedKernMode) {
                        ForEach(TypographyKernMode.allCases) {
                            mode in
                            Text(mode.title)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(16)
            .background(cardBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            }
        }
    }

    private var comparisonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comparison")
                .font(.headline)

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    uikitBlock
                        .frame(maxWidth: .infinity, alignment: .leading)
                    swiftUIBlock
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 16) {
                    uikitBlock
                    swiftUIBlock
                }
            }
        }
    }

    private var uikitBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("UIKit UILabel")
                .font(.headline)
            Text("A/B/C are rendered simultaneously using the same container style.")
                .font(.caption)
                .foregroundStyle(.secondary)

            typographySampleRow(title: TypographyUILabelMode.plain.title) {
                TypographyUILabelLineRepresentable(
                    text: sampleText,
                    requestedFontName: requestedFontName,
                    pointSize: CGFloat(fontSize),
                    mode: .plain,
                    kernMode: selectedKernMode,
                    adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
                ) {
                    diagnostics in
                    updateUIKitDiagnostics(diagnostics)
                }
            }

            typographySampleRow(title: TypographyUILabelMode.attributed.title) {
                TypographyUILabelLineRepresentable(
                    text: sampleText,
                    requestedFontName: requestedFontName,
                    pointSize: CGFloat(fontSize),
                    mode: .attributed,
                    kernMode: selectedKernMode,
                    adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
                ) {
                    diagnostics in
                    updateUIKitDiagnostics(diagnostics)
                }
            }

            typographySampleRow(
                title: "\(TypographyUILabelMode.attributedKern.title) [\(selectedKernMode.title)]"
            ) {
                TypographyUILabelLineRepresentable(
                    text: sampleText,
                    requestedFontName: requestedFontName,
                    pointSize: CGFloat(fontSize),
                    mode: .attributedKern,
                    kernMode: selectedKernMode,
                    adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
                ) {
                    diagnostics in
                    updateUIKitDiagnostics(diagnostics)
                }
            }
        }
        .padding(16)
        .background(cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        }
    }

    private var swiftUIBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SwiftUI Text")
                .font(.headline)
            Text("A/B/C/D are rendered simultaneously using the same container style.")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(TypographySwiftUITextMode.allCases) {
                mode in
                typographySampleRow(title: mode.title) {
                    swiftUIText(for: mode)
                }
            }
        }
        .padding(16)
        .background(cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        }
    }

    private var debugSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Debug")
                .font(.headline)

            Text(debugSnapshot.debugText)
                .font(.system(.caption, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(cardBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                }
        }
    }

    private var localizationInterpretationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Localization Interpretation Lab")
                .font(.headline)
            Text("Compare localized-key and verbatim SwiftUI Text initializers with identical font and container styles.")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(LocalizationInterpretationVariant.allCases) { variant in
                typographySampleRow(title: variant.label) {
                    localizationInterpretationText(for: variant)
                }
            }

            localizationDiagnosticsPanel
        }
    }

    private var localizationDiagnosticsPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Localization Unicode Diagnostics")
                .font(.subheadline.weight(.semibold))

            ForEach(localizationDebugRows) { row in
                VStack(alignment: .leading, spacing: 4) {
                    Text(row.title)
                        .font(.caption.weight(.semibold))
                    Text("Visible: \(visibleWhitespaceTokens(row.value))")
                        .font(.system(.caption, design: .monospaced))
                    Text("Scalars: \(unicodeScalarsDump(row.value))")
                        .font(.system(.caption, design: .monospaced))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
        .background(cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        }
    }

    private func typographySampleRow<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            content()
                .frame(maxWidth: .infinity, minHeight: sampleRowMinimumHeight, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(sampleBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                }
        }
    }

    @ViewBuilder
    private func swiftUIText(for mode: TypographySwiftUITextMode) -> some View {
        switch mode {
        case .default:
            textWithOptionalDrawingGroup(
                Text(sampleText)
                    .font(.custom(requestedFontName, size: CGFloat(fontSize)))
            )
        case .kerningZero:
            textWithOptionalDrawingGroup(
                Text(sampleText)
                    .font(.custom(requestedFontName, size: CGFloat(fontSize)))
                    .kerning(0)
            )
        case .trackingZero:
            textWithOptionalDrawingGroup(
                Text(sampleText)
                    .font(.custom(requestedFontName, size: CGFloat(fontSize)))
                    .tracking(0)
            )
        case .bridgedUIFont:
            textWithOptionalDrawingGroup(
                Text(sampleText)
                    .font(.init(baseFontResolution.uiFont))
            )
        }
    }

    @ViewBuilder
    private func localizationInterpretationText(
        for variant: LocalizationInterpretationVariant
    ) -> some View {
        switch variant {
        case .textLocalizedLiteral:
            localizationLabText(Text(sampleText))
        case .textVerbatimLiteral:
            localizationLabText(Text(verbatim: sampleText))
        case .textLocalizedStringKey:
            localizationLabText(Text(LocalizedStringKey(sampleText)))
        case .textDynamicString:
            localizationLabText(Text(String(sampleText)))
        }
    }

    private func localizationLabText(_ text: Text) -> some View {
        text
            .font(.init(baseFontResolution.uiFont))
    }

    @ViewBuilder
    private func textWithOptionalDrawingGroup<Content: View>(_ content: Content) -> some View {
        if isDrawingGroupEnabled {
            content
                .drawingGroup()
        } else {
            content
        }
    }

    private func localizedValue(for key: String) -> String {
        switch key {
        case "BANK口座":
            return String(localized: "BANK口座")
        default:
            return NSLocalizedString(key, comment: "")
        }
    }

    private func unicodeScalarsDump(_ value: String) -> String {
        value.unicodeScalars.map { scalar in
            String(format: "U+%04X", scalar.value)
        }
        .joined(separator: " ")
    }

    private func visibleWhitespaceTokens(_ value: String) -> String {
        var output = ""

        for scalar in value.unicodeScalars {
            switch scalar.value {
            case 0x20:
                output.append("[SPACE]")
            case 0x00A0:
                output.append("[NBSP]")
            case 0x2009:
                output.append("[THIN]")
            case 0x200B:
                output.append("[ZWSP]")
            default:
                output.append(String(scalar))
            }
        }

        return output
    }

    private func updateUIKitDiagnostics(_ diagnostics: TypographyUILabelDiagnostics) {
        if uikitDiagnosticsByMode[diagnostics.mode] == diagnostics {
            return
        }

        uikitDiagnosticsByMode[diagnostics.mode] = diagnostics
    }

    private func emitDebugLogs(snapshot: TypographyLabDebugSnapshot, force: Bool = false) {
        if !force {
            if snapshot == lastLoggedSnapshot {
                return
            }
        }

        for line in snapshot.logLines {
            print("[TypographyLab] \(line)")
        }

        lastLoggedSnapshot = snapshot
    }
}

#Preview {
    NavigationStack {
        TypographyLabView()
    }
}
