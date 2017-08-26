//
// Created by Arnon Keereena on 8/26/2017 AD.
//

import Foundation

/// Convenience function for setting router eloquently
/// User have all the right to set it up by calling strcted.router.map(...) himself, though.
public func defineRoute(definitions: [RouteDefinition]) {
    let builtDefinitions = definitions.map { $0.build() }
    let categorizer = RouteDefinitionCategorizer(definitions: builtDefinitions)
    let initial = MiddlewareDefinition(pre: [], post: [])
    let flatGlobalMiddleware = categorizer.globalMiddlewareDefinitions.reduce(initial) { $0 + $1 }
    
    // Normalized by prepending & appending globals middleware to the local ones
    let normalizedDefinitions: [RouteDefinition] = categorizer.controllerRouteDefinitions.map {
        if case let .controllerRoute(definition) = $0.type! {
            definition.middlewareDefinition = definition.middlewareDefinition + flatGlobalMiddleware
            let routeDefinition = RouteDefinition(uri: $0.uri)
            routeDefinition.type = .controllerRoute(definition: definition)
            return routeDefinition
        } else {
            return $0
        }
    }
    
    let definitions = normalizedDefinitions + categorizer.staticRouteDefinition
    Strcted.current.router.routeDefinitions = definitions.flatMap { RouteableRouteDefinition(definition: $0) }
}

class RouteDefinitionCategorizer {
    private var definitions: [RouteDefinition]
    public var globalMiddlewareDefinitions: [MiddlewareDefinition] = []
    public var controllerRouteDefinitions: [RouteDefinition] = []
    public var staticRouteDefinition: [RouteDefinition] = []
    
    init(definitions: [RouteDefinition]) {
        self.definitions = definitions
        definitions.forEach {
            switch $0.type! {
            case .staticRoute(_):
                staticRouteDefinition.append($0)
            case .controllerRoute(_):
                controllerRouteDefinitions.append($0)
            case let .globalMiddleware(definition):
                globalMiddlewareDefinitions.append(definition)
            }
        }
    }
}