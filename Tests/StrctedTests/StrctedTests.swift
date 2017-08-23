//
//  StrctedTests.swift
//  StrctedTests
//
//  Created by Arnon Keereena on 8/12/2560 BE.
//
//

import XCTest
@testable import Strcted

class StrctedTests: XCTestCase {
    
    static var allTests: [(String, (StrctedTests) -> () throws -> Void)] {
        return [
            ("testCollect_controllerClassesAreCollected", testCollect_controllerClassesAreCollected)
        ]
    }
    
    func testCollect_controllerClassesAreCollected() {
        let strcted = Strcted()
        let fixtures = Fixtures()
        strcted.collect(controllerClasses: fixtures.controllerClasses)
        
        XCTAssert(strcted.context.controllerClasses.count > 0, "There should be at least 1 controller class collected")
    }
}
