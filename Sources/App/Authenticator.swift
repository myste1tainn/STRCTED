//
// Created by Arnon Keereena on 8/26/2017 AD.
//

import Foundation

class Authenticator: Middleware {
    override func execute() {
        response.appendBody(string: "<html><title>Hello, world!</title><body>Appended from authenticator")
    }
}

class PostAuthenticator: Middleware {
    override func execute() {
        response.appendBody(string: "Appended from POST AUTHENTICATOR")
    }
}
