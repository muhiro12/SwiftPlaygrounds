import CoreFoundation
import Foundation
import SwiftUI
import UIKit

enum TypographyUILabelMode: String, CaseIterable, Identifiable {
    case plain
    case attributed
    case attributedKern

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .plain:
            return "A) UILabel.text"
        case .attributed:
            return "B) UILabel.attributedText (no kern)"
        case .attributedKern:
            return "C) UILabel.attributedText + kern"
        }
    }

    static var displayOrder: [TypographyUILabelMode] {
        [.plain, .attributed, .attributedKern]
    }
}

enum TypographyKernMode: String, CaseIterable, Identifiable {
    case none
    case zero
    case cfNull

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .none:
            return "none"
        case .zero:
            return "0"
        case .cfNull:
            return "kCFNull"
        }
    }

    func apply(to attributes: inout [NSAttributedString.Key: Any]) {
        switch self {
        case .none:
            break
        case .zero:
            attributes[.kern] = CGFloat.zero
        case .cfNull:
            attributes[.kern] = kCFNull
        }
    }

    static func describe(attributeValue: Any?) -> String {
        guard let attributeValue else {
            return "nil"
        }

        if CFGetTypeID(attributeValue as CFTypeRef) == CFNullGetTypeID() {
            return "kCFNull"
        }

        if let number = attributeValue as? NSNumber {
            return number.stringValue
        }

        return String(describing: attributeValue)
    }
}

struct TypographyResolvedFont {
    let uiFont: UIFont
    let requestedFontName: String
    let resolvedFontName: String
    let isFallback: Bool
}

enum TypographyFontResolver {
    static func resolveBaseFont(requestedFontName: String, pointSize: CGFloat) -> TypographyResolvedFont {
        if let requestedFont = UIFont(name: requestedFontName, size: pointSize) {
            return .init(
                uiFont: requestedFont,
                requestedFontName: requestedFontName,
                resolvedFontName: requestedFont.fontName,
                isFallback: false
            )
        }

        let fallbackFont = UIFont.systemFont(ofSize: pointSize)
        return .init(
            uiFont: fallbackFont,
            requestedFontName: requestedFontName,
            resolvedFontName: fallbackFont.fontName,
            isFallback: true
        )
    }

    static func resolveUILabelFont(
        requestedFontName: String,
        pointSize: CGFloat,
        adjustsFontForContentSizeCategory: Bool
    ) -> TypographyResolvedFont {
        let baseFont = resolveBaseFont(requestedFontName: requestedFontName, pointSize: pointSize)
        guard adjustsFontForContentSizeCategory else {
            return baseFont
        }

        let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont.uiFont)
        return .init(
            uiFont: scaledFont,
            requestedFontName: requestedFontName,
            resolvedFontName: scaledFont.fontName,
            isFallback: baseFont.isFallback
        )
    }
}

struct TypographyUILabelDiagnostics: Equatable {
    let mode: TypographyUILabelMode
    let isAttributedText: Bool
    let requestedFontName: String
    let resolvedFontName: String
    let pointSize: CGFloat
    let isFallbackFont: Bool
    let kernDescription: String
    let adjustsFontForContentSizeCategory: Bool

    var logLine: String {
        "\(mode.rawValue) | attributed=\(isAttributedText) | kern=\(kernDescription) | font=\(resolvedFontName) | pointSize=\(String(format: "%.2f", Double(pointSize))) | requested=\(requestedFontName) | fallback=\(isFallbackFont) | adjustsForDynamicType=\(adjustsFontForContentSizeCategory)"
    }
}

struct TypographyUILabelLineRepresentable: UIViewRepresentable {
    let text: String
    let requestedFontName: String
    let pointSize: CGFloat
    let mode: TypographyUILabelMode
    let kernMode: TypographyKernMode
    let adjustsFontForContentSizeCategory: Bool
    let onDiagnosticsChange: (TypographyUILabelDiagnostics) -> Void

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byClipping
        label.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        label.backgroundColor = .clear
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        let resolvedFont = TypographyFontResolver.resolveUILabelFont(
            requestedFontName: requestedFontName,
            pointSize: pointSize,
            adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
        )

        uiView.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        switch mode {
        case .plain:
            uiView.attributedText = nil
            uiView.font = resolvedFont.uiFont
            uiView.text = text
        case .attributed:
            uiView.text = nil
            uiView.attributedText = .init(
                string: text,
                attributes: [.font: resolvedFont.uiFont]
            )
        case .attributedKern:
            var attributes: [NSAttributedString.Key: Any] = [.font: resolvedFont.uiFont]
            kernMode.apply(to: &attributes)
            uiView.text = nil
            uiView.attributedText = .init(
                string: text,
                attributes: attributes
            )
        }

        let kernDescription: String
        if let attributedText = uiView.attributedText, attributedText.length > 0 {
            let kernValue = attributedText.attribute(.kern, at: 0, effectiveRange: nil)
            kernDescription = TypographyKernMode.describe(attributeValue: kernValue)
        } else {
            kernDescription = "n/a"
        }

        let diagnostics = TypographyUILabelDiagnostics(
            mode: mode,
            isAttributedText: uiView.attributedText != nil,
            requestedFontName: resolvedFont.requestedFontName,
            resolvedFontName: resolvedFont.resolvedFontName,
            pointSize: resolvedFont.uiFont.pointSize,
            isFallbackFont: resolvedFont.isFallback,
            kernDescription: kernDescription,
            adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
        )

        DispatchQueue.main.async {
            onDiagnosticsChange(diagnostics)
        }
    }
}
