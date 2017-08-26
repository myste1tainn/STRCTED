//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation
import PerfectHTTP
import Strcted

class Fixtures {
    var controllerClasses: [HTTPMessageHandlerObject.Type] = [TestController.self]
    var mockRequest = MockHTTPRequest()
    var mockResponse = MockHTTPResponse()
}

class TestController: Controller {
    var testState = false
    var anotherTestState = false
    func changeTestStateToTrue() {
        print("Test method executed")
        testState = true
    }
    func anotherTestMethod() {
        print("Another test method executed")
        anotherTestState = true
    }
}