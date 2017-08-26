//
// Created by Arnon Keereena on 8/12/2017 AD.
//

import Foundation
import PerfectHTTP

open class Controller: NSObject, HTTPMessageHandlerObject {
    open var request: HTTPRequest
    open var response: HTTPResponse
    public required init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
    }
}