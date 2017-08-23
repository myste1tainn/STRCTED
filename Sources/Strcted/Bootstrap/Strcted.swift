//
//  Strcted.swift
//  Strcted
//
//  Created by Arnon Keereena on 8/12/2560 BE.
//
//

import Foundation

public class Strcted {
    public static var context: Context!
    public static func collect(controllerClasses: [IController.Type]) {
        context.controllerClasses = controllerClasses
    }
}