//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation
import PerfectHTTP

open class Middleware: NSObject, HTTPMessageHandlerObject {
    public var request: HTTPRequest
    public var response: HTTPResponse
    
    public required init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
    }
    
    open func execute() {
        fatalError("Middleware.execute() should be overridden and should not be called")
    }
}