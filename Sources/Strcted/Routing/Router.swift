//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer

public class Router {
    var routeDefinitions: [RouteableRouteDefinition]
    var instantiatedControllerClasses: [Controller]
    
    /// Transform route definitions into route dictionary usable in PerfectLib
    var routeDictionaries: [[String: Any]] {
        return routeDefinitions.map {
            switch $0.type {
            case let .controllerRoute(definition):
                let pre = self.executionBlocks(from: definition.middlewareDefinition.pre)
                let main = self.executionBlocks(from: definition.controllerMetadata)
                let post = self.executionBlocks(from: definition.middlewareDefinition.post)
                let handler: HTTPMessageHandler = { request, response in
                    var flow = MessageFlow(currentIndex: 0, executableFlows: pre + main + post)
                    flow.next(request: request, response: response)
                }
                return [
                    "method": "get",
                    "uri": $0.uri ?? "",
                    "handler": handler
                ]
            case .staticRoute:
                return [
                    "method": "get",
                    "uri": $0.uri ?? "",
                    "handler": PerfectHTTPServer.HTTPHandler.staticFiles,
                    "documentRoot": "./webroot",
                    "allowResponseFilters": true
                ]
            }
        }
    }
    
    init() {
        routeDefinitions = []
        instantiatedControllerClasses = []
    }
    
    func executionBlocks(from controllers: [ControllerExecutableMetadata]) -> [HTTPMessageHandler] {
        return controllers.map { controller in
            { request, response in
                let selector = Selector(controller.method)
                controller.class
                    .init(request: request, response: response)
                    .perform(selector)
            }
        }
    }
    
    func executionBlocks(from middlewareTypes: [Middleware.Type]) -> [HTTPMessageHandler] {
        return middlewareTypes.map { type in
            { request, response in
                type.init(request: request, response: response).execute()
            }
        }
    }
    
    public func controller<T>(with class: T.Type) -> T? where T: Controller {
        let match = instantiatedControllerClasses.filter { type(of: $0) == `class` }.first
        return match as? T
    }
    
    /// Execute the specify controller by the specify method name.
    /// This will try to use controller without re-instantiating from cache
    /// Specifying cache flag to true will cache controller to memory on instantiation
    /// Otherwise the controller will be discarded after method execution
    public func execute(controllerClass: Controller.Type,
                        methodName: String,
                        request: HTTPRequest,
                        response: HTTPResponse,
                        cache: Bool) {
        let selector = Selector(methodName)
        let controller = instantiatedControllerClasses
            .filter { type(of: $0) == controllerClass }.first
            ?? createController(class: controllerClass, request: request, response: response, cache: cache)
        controller.perform(selector)
    }
    
    public func createController(class: Controller.Type,
                                 request: HTTPRequest,
                                 response: HTTPResponse,
                                 cache: Bool) -> Controller {
        let controller = `class`.init(request: request, response: response)
        if cache {
            instantiatedControllerClasses.append(controller)
        }
        return controller
    }
}