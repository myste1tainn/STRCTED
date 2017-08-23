//
//  ContextWorker.swift
//  Strcted
//
//  Created by Arnon Keereena on 8/12/2560 BE.
//
//

import Foundation

extension Context {
    /// Internal worker has a role to collect data and put them to context
    class Worker {
        static func collect(controller: IController) {
            Strcted.context.controllerClasses.append(controller)
        }
    }
}
