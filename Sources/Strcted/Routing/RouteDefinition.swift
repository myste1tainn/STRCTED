//
// Created by Arnon Keereena on 8/25/2017 AD.
//

import Foundation

public func route(uri: String?) -> RouteDefinition {
    return RouteDefinition(uri: uri)
}

public func middleware(pre: [Middleware.Type], post: [Middleware.Type]) -> RouteDefinition {
    let middlewareDefinition = MiddlewareDefinition(pre: pre, post: post)
    let definition = RouteDefinition(uri: nil)
    definition.type = .globalMiddleware(middleware: middlewareDefinition)
    return definition
}

public class RouteDefinition {
    public enum RouteDefinitionType {
        case staticRoute(documentRoot: String)
        case controllerRoute(definition: ControllerDefinition)
        case globalMiddleware(middleware: MiddlewareDefinition)
    }
    
    public var uri: String?
    public var type: RouteDefinitionType!
    
    var buildInfo = BuildInfo()
    struct BuildInfo {
        var controllerDefinition: ControllerDefinition?
        var middlewareDefinition: MiddlewareDefinition?
        var documentRootPath: String?
        // TODO: Impose some kind of setter fatalError
        // to throw error when certain sequence setter are called, because they are illegal e.g.
        // setting documentRootPath then setting controllerDefinition & the other way around
        // The build info can only contains static route type or controller type at one time and not both
        init() {}
    }
    
    init() {}
    init(uri: String?) {
        self.uri = uri
    }
    
    public func to(controller: Controller.Type, method: String) -> Self {
        buildInfo.controllerDefinition = ControllerDefinition(controller: controller, method: method)
        return self
    }
    
    public func to(documentRootPath: String) -> Self {
        buildInfo.documentRootPath = documentRootPath
        return self
    }
    
    public func middleware(pre: [Middleware.Type], post: [Middleware.Type] = []) -> Self {
        buildInfo.middlewareDefinition = MiddlewareDefinition(pre: pre, post: post)
        return self
    }
    
    public func build() -> Self {
        if let controllerDefinition = buildInfo.controllerDefinition,
           let middlewareDefinition = buildInfo.middlewareDefinition {
            controllerDefinition.middlewareDefinition = middlewareDefinition
            type = .controllerRoute(definition: controllerDefinition)
        } else if let controllerDefinition = buildInfo.controllerDefinition {
            type = .controllerRoute(definition: controllerDefinition)
        } else if let middlewareDefinition = buildInfo.middlewareDefinition {
            type = .globalMiddleware(middleware: middlewareDefinition)
        } else if let documentRootPath = buildInfo.documentRootPath {
            type = .staticRoute(documentRoot: documentRootPath)
        }
        return self
    }
}

infix operator +: AdditionPrecedence
public class MiddlewareDefinition {
    public var pre: [Middleware.Type]
    public var post: [Middleware.Type]
    
    init(pre: [Middleware.Type], post: [Middleware.Type]) {
        self.pre = pre
        self.post = post
    }
    
    public static func + (left: MiddlewareDefinition, right: MiddlewareDefinition) -> MiddlewareDefinition {
        return MiddlewareDefinition(pre: left.pre + right.pre, post: left.post + right.post)
    }
}

public class ControllerDefinition {
    public var controllerMetadata: [ControllerExecutableMetadata]
    public var middlewareDefinition: MiddlewareDefinition
    
    public init(controller: Controller.Type, method: String) {
        self.controllerMetadata = [ControllerExecutableMetadata(class: controller, method: method)]
        self.middlewareDefinition = MiddlewareDefinition(pre: [], post: [])
    }
    
    public init(controllerAndMethodTuples: [(class: Controller.Type, method: String)]) {
        self.controllerMetadata = controllerAndMethodTuples.map { ControllerExecutableMetadata(class: $0.0, method: $0.1) }
        self.middlewareDefinition = MiddlewareDefinition(pre: [], post: [])
    }
}

public struct ControllerExecutableMetadata {
    public var `class`: Controller.Type
    public var method: String
}