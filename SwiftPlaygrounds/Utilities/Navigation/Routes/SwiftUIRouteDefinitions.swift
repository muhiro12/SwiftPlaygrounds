import SwiftUI

enum SwiftUIRouteDefinitions {
    static let all: [RouteDefinition] = [
        RouteDefinition(
            route: .hybridTextField,
            tags: [CategoryTag.swiftUI, FeatureTag.hybrid],
            viewBuilder: { AnyView(HybridTextFieldView()) }
        ),
        RouteDefinition(
            route: .textFieldSizingLab,
            tags: [CategoryTag.swiftUI, FeatureTag.hybrid, FeatureTag.layout],
            viewBuilder: { AnyView(TextFieldSizingLabView()) }
        ),
        RouteDefinition(
            route: .webIntegration,
            tags: [CategoryTag.swiftUI, FeatureTag.webView],
            viewBuilder: { AnyView(WebIntegrationView()) }
        ),
        RouteDefinition(
            route: .pdfPoC,
            tags: [CategoryTag.swiftUI, FeatureTag.webView],
            viewBuilder: { AnyView(PDFPoCView()) }
        ),
        RouteDefinition(
            route: .typographyLab,
            tags: [CategoryTag.swiftUI, FeatureTag.common],
            viewBuilder: { AnyView(TypographyLabView()) }
        )
    ]
}
