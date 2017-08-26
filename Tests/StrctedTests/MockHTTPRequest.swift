//
// Created by Arnon Keereena on 8/23/2017 AD.
//

import PerfectHTTP
import PerfectNet

class MockHTTPRequest: HTTPRequest {
    var method: HTTPMethod = .get
    var path: String = ""
    private(set) var pathComponents: [String] = []
    private(set) var queryParams: [(String, String)] = []
    private(set) var protocolVersion: (Int, Int) = (0, 0)
    private(set) var remoteAddress: (host: String, port: UInt16) = ("", 0)
    private(set) var serverAddress: (host: String, port: UInt16) = ("", 0)
    private(set) var serverName: String = ""
    private(set) var documentRoot: String = ""
    private(set) var connection: NetTCP = NetTCP(fd: 0)
    var urlVariables: [String: String] = [:]
    var scratchPad: [String: Any] = [:]
    
    func header(_ named: HTTPRequestHeader.Name) -> String? {
        return nil
    }
    
    func addHeader(_ named: HTTPRequestHeader.Name, value: String) {
    }
    
    func setHeader(_ named: HTTPRequestHeader.Name, value: String) {
    }
    
    private(set) var headers: AnyIterator<(HTTPRequestHeader.Name, String)> = AnyIterator { nil }
    private(set) var postParams: [(String, String)] = []
    var postBodyBytes: [UInt8]? = nil
    private(set) var postBodyString: String? = nil
    private(set) var postFileUploads: [MimeReader.BodySpec]? = nil
}