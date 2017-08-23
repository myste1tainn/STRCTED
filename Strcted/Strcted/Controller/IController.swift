//
// Created by Arnon Keereena on 8/12/2017 AD.
//

import Foundation
import PerfectHTTP

public protocol IController: NSObjectProtocol {
    var request: HTTPRequest { get set }
    var response: HTTPResponse { get set }
    init(request: HTTPRequest, response: HTTPResponse)
}