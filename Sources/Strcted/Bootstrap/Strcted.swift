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
    public let context: Context
    public let router: Router
    public func collect(controllerClasses: [IController.Type]) {
        context.controllerClasses = controllerClasses
    }
    
    init() {
        context = Context()
        router = Router()
        Strcted.current = self
    }
    
    public func boot() {
        let confData = [
            "servers": [
                [
                    "name": "localhost",
                    "port": 8181,
                    "routes":[
                        ["method": "get", "uri": "/", "handler": router.rootHandler],
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
}