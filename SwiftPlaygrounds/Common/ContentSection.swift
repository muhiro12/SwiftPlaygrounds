enum Tag: String, CaseIterable, Identifiable {
    case logicCombine
    case logicCommon
    case logicConcurrency
    case logicObservation
    case logicSwiftData
    case logicUser
    case packageKeychain
    case swiftUILayout
    case swiftUIModifier
    case swiftUISample
    case swiftUIHybrid
    case swiftUITransition
    case uiKitCollection
    case uiKitCommon
    case uiKitCompositional
    case uiKitInfinitePaging
    case uiKitNavigation
    case uiKitStoryboard
    case uiKitTable
    case uiKitWebView

    var id: String {
        rawValue
    }

    var title: String {
        rawValue.camelCased()
    }
}
