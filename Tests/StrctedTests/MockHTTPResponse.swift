//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import Foundation
import PerfectHTTP

class MockHTTPResponse: HTTPResponse {
    var request: HTTPRequest = MockHTTPRequest()
    var status: HTTPResponseStatus = .accepted
    var isStreaming: Bool = false
    var bodyBytes: [UInt8] = []
    
    func header(_ named: HTTPResponseHeader.Name) -> String? {
        return nil
    }
    
    func addHeader(_ named: HTTPResponseHeader.Name, value: String) -> Self {
        return self
    }
    
    func setHeader(_ named: HTTPResponseHeader.Name, value: String) -> Self {
        return self
    }
    
    private(set) var headers: AnyIterator<(HTTPResponseHeader.Name, String)> = AnyIterator { nil }
    
    func push(callback: @escaping (Bool) -> ()) {
    }
    
    func completed() {
    }
    
    func next() {
    }
}