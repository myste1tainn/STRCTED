import Foundation
import Strcted

defineRoute(definitions: [
    route(uri: "/test").to(controller: AppController.self, method: "index")
        .middleware(pre: [Authenticator.self]),
    route(uri: "/another-test").to(controller: AppController.self, method: "index")
        .middleware(pre: [Authenticator.self], post: [PostAuthenticator.self])
])

Strcted.current.boot()