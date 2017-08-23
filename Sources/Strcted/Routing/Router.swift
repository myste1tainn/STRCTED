//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation
import PerfectHTTP
public extension Strcted {
    public class Router {
        var executionFlows: [RouteExecutionFlow<Controller>]
        
        init() {
            executionFlows = []
        }
        
        /// This is a root handler that takes all the requests and end all the responses
        func rootHandler(request: HTTPRequest, response: HTTPResponse) {
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            response.completed()
        }
        
        func map<T: Controller>(route: String, with handler: @escaping (T) -> () throws -> Void) {
            executionFlows.append(RouteExecutionFlow(
                requestMiddlewares: [],
                controllerClass: T.self,
                controllerMethod: handler,
                responseMiddlewares: []
            ))
        }
    }
    
    class RouteExecutionFlow<T> where T: Controller {
        var requestMiddlewares: [Any]
        var controllerClass: T.Type
        var controllerMethod: (T) -> () throws -> Void
        var responseMiddlewares: [Any]
        
    
        init(requestMiddlewares: Array<Any>,
             controllerClass: T.Type,
             controllerMethod: @escaping (T) -> () throws -> Void,
             responseMiddlewares: Array<Any>) {
            self.requestMiddlewares = requestMiddlewares
            self.controllerClass = controllerClass
            self.controllerMethod = controllerMethod
            self.responseMiddlewares = responseMiddlewares
        }
    }
}