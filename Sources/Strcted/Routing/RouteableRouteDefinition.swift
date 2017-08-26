//
// Created by Arnon Keereena on 8/26/2017 AD.
//

import Foundation

/// Slight difference between RouteDefinition & RouteableRouteDefinition is that
/// the RouteableRouteDefinition has its enum type of only 2 types: staticRoute & controllerRoute
/// both are of which can be created as a real route in Strcted's sense.
/// Although, PerfectLib allows you to setup any logic calculator with any route at all, we don't to.
/// Just for the sake of clarity
public class RouteableRouteDefinition {
    public var uri: String?
    public var type: RouteableRouteDefinitionType
    
    init(uri: String?, type: RouteableRouteDefinitionType) {
        self.uri = uri
        self.type = type
    }
    
    init?(definition: RouteDefinition) {
        switch definition.type! {
        case let .staticRoute(path): self.type = .staticRoute(documentRoot: path)
        case let .controllerRoute(definition): self.type = .controllerRoute(definition: definition)
        case .globalMiddleware(_): return nil
        }
        self.uri = definition.uri
    }
    
    public enum RouteableRouteDefinitionType {
        case staticRoute(documentRoot: String)
        case controllerRoute(definition: ControllerDefinition)
    }
}