enum RouteRegistry {
    private static let definitionsByRoute: [Route: RouteDefinition] = {
        var definitions: [Route: RouteDefinition] = [:]
        var duplicates: [Route] = []
        let allDefinitions = LogicRouteDefinitions.all
            + SwiftUIRouteDefinitions.all
            + UIKitRouteDefinitions.all
            + PackageRouteDefinitions.all

        for definition in allDefinitions {
            if definitions[definition.route] != nil {
                duplicates.append(definition.route)
            }
            definitions[definition.route] = definition
        }
        if !duplicates.isEmpty {
            assertionFailure("Duplicate route definitions found: \(duplicates)")
        }
        let missing = Set(Route.allCases).subtracting(definitions.keys)
        if !missing.isEmpty {
            assertionFailure("Missing route definitions: \(missing)")
        }
        return definitions
    }()

    static var orderedRoutes: [Route] {
        Route.allCases
    }

    static func definition(for route: Route) -> RouteDefinition {
        guard let definition = definitionsByRoute[route] else {
            preconditionFailure("Missing route definition for \(route)")
        }
        return definition
    }
}
