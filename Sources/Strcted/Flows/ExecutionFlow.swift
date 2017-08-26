//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation
import PerfectHTTP

struct ExecutionFlow {
    var requestMiddlewareTypes: [Middleware.Type]
    var controllerClass: Controller.Type
    var controllerMethodName: String
    var responseMiddlewareTypes: [Middleware.Type]
    
    init(requestMiddlewareTypes: [Middleware.Type],
         controllerClass: Controller.Type,
         controllerMethodName: String,
         responseMiddleWareTypes: [Middleware.Type]) {
        self.requestMiddlewareTypes = requestMiddlewareTypes
        self.controllerClass = controllerClass
        self.controllerMethodName = controllerMethodName
        self.responseMiddlewareTypes = responseMiddleWareTypes
    }
    
    var requestMiddlewareExecutables: [HTTPMessageHandler] {
        return self.requestMiddlewareTypes.map { middlewareType in
            return { request, response in
                let middleware = middlewareType.init(request: request, response: response)
                middleware.execute()
            }
        }
    }
    var controllerExecutable: HTTPMessageHandler {
        return { request, response in
            let controller = self.controllerClass.init(request: request, response: response)
            let selector = Selector(self.controllerMethodName)
            controller.perform(selector)
        }
    }
    var responseMiddlewareExecutables: [HTTPMessageHandler] {
        return self.responseMiddlewareTypes.map { middlewareType in
            return { request, response in
                let middleware = middlewareType.init(request: request, response: response)
                middleware.execute()
            }
        }
    }
    
    var messageFlow: HTTPMessageHandler {
        return { request, response in
            var flow = MessageFlow(
                currentIndex: 0,
                executableFlows: self.requestMiddlewareExecutables + [self.controllerExecutable] + self.responseMiddlewareExecutables
            )
            flow.next(request: request, response: response)
        }
    }
}

typealias HTTPMessageHandler = (HTTPRequest, HTTPResponse) -> Void

struct MessageFlow {
    var currentIndex = 0
    var executableFlows: [HTTPMessageHandler]
    
    mutating func next(request: HTTPRequest, response: HTTPResponse) {
        executableFlows.enumerated().forEach { (index, flow) in
            flow(request, response)
            self.currentIndex += 1
            
            guard index == executableFlows.count - 1 else {
                return
            }
            response.next()
            response.completed()
        }
    }
}