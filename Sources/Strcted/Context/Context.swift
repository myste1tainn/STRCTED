//
//  Context.swift
//  Strcted
//
//  Created by Arnon Keereena on 8/12/2560 BE.
//
//

import Foundation

extension Strcted {
    public class Context {
        var controllerClasses: [HTTPMessageHandlerObject.Type]
        
        init() {
            controllerClasses = []
        }
    }
    
}