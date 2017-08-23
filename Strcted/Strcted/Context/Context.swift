//
//  Context.swift
//  Strcted
//
//  Created by Arnon Keereena on 8/12/2560 BE.
//
//

import Foundation

public class Context {
    var controllerClasses: [IController.Type]
    
    static func create() {
        Strcted.context = Context()
    }
    
    private init() {}
}
