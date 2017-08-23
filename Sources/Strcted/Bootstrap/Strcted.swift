//
//  Strcted.swift
//  Strcted
//
//  Created by Arnon Keereena on 8/12/2560 BE.
//
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

public class Strcted {
    public static var current: Strcted!
    public var context: Context!
    public func collect(controllerClasses: [IController.Type]) {
        context.controllerClasses = controllerClasses
    }
    
    init() {
        context = Context()
        Strcted.current = self
    }
    
    public func boot() {
        let confData = [
            "servers": [
                [
                    "name": "localhost",
                    "port": 8181,
                    "routes":[
                        ["method": "get", "uri": "/", "handler": self.handler],
                        ["method": "get", "uri": "/**", "handler": PerfectHTTPServer.HTTPHandler.staticFiles,
                         "documentRoot": "./webroot",
                         "allowResponseFilters":true]
                    ],
                    "filters":[
                        [
                            "type": "response",
                            "priority": "high",
                            "name": PerfectHTTPServer.HTTPFilter.contentCompression,
                        ]
                    ]
                ]
            ]
        ]
    
        do {
            // Launch the servers based on the configuration data.
            try HTTPServer.launch(configurationData: confData)
        } catch {
            fatalError("\(error)") // fatal error launching one of the servers
        }
    }
    
    private func handler(data: [String:Any]) throws -> RequestHandler {
        return { request, response in
            // Respond with a simple message.
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            // Ensure that response.completed() is called when your processing is done.
            response.completed()
        }
    }
    func test(data: [String:Any]) throws -> RequestHandler {
        return { req, res in
            let path = FileManager.default.currentDirectoryPath
            // Respond with a simple message.
            res.setHeader(.contentType, value: "text/html")
            res.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!\(path)</body></html>")
            // Ensure that response.completed() is called when your processing is done.
            res.completed()
            
        }
    }
}