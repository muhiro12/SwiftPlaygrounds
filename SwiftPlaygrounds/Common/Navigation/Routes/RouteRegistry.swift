enum RouteRegistry {
    private static let definitionsByRoute: [Route: RouteDefinition] = {
        var definitions: [Route: RouteDefinition] = [:]
        let allDefinitions = LogicRouteDefinitions.all
            + SwiftUIRouteDefinitions.all
            + UIKitRouteDefinitions.all
            + PackageRouteDefinitions.all

        for definition in allDefinitions {
            definitions[definition.route] = definition
        }
        return definitions
    }()

    static func definition(for route: Route) -> RouteDefinition {
        guard let definition = definitionsByRoute[route] else {
            preconditionFailure("Missing route definition for \(route)")
        }
        return definition
    }
}
