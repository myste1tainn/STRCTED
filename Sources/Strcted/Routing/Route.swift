//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation

typealias Handler<T> = (T) -> () throws -> Void

//struct Route: Hashable {
//    let path: String
//    init(string: String) {
//        path = string
//    }
//
//    var hashValue: Int {
//        return path.hashValue
//    }
//
//    static func ==(lhs: Route, rhs: Route) -> Bool {
//        return lhs.hashValue == rhs.hashValue
//    }
//}
//
//struct RouteMappedExecutionFlow {
//    var route: Route
//    var flow: ExecutionFlow
//}