//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation
import Strcted

class AppController: Controller {
    func index() {
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<p>Hello, world!<p><b>Called uri: \(request.uri)</b></body></html>")
    }
}
