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
    
    func testRouteMapping_mappedControllerExists() {
        let targetType = TestController.self
        defineRoute(definitions: [
            .route(uri: "/some/path", controller: (class: targetType, "changeTestStateToTrue"))
        ])
        let matches = Strcted.current.router.routeDefinitions.filter { $0.controllers.first!.class == targetType }
        XCTAssert(matches.count > 0)
    }
    
    func testRouteMapping_mappedPathsExists() {
        let targetType = TestController.self
        defineRoute(definitions: [
            .route(uri: "/some/path", controller: (class: targetType, "changeTestStateToTrue")),
            .route(uri: "/some/other/path", controller: (class: targetType, "anotherTestMethod"))
        ])
        let matches = Strcted.current.router.routeDefinitions.filter { $0.controllers.first!.class == targetType }
        XCTAssert(matches.count > 1)
    }
    
    func testRouteExecution_controllerStateChanged() {
        let targetType = TestController.self
        defineRoute(definitions: [
            .route(uri: "/some/path", controller: (class: targetType, "changeTestStateToTrue")),
            .route(uri: "/some/other/path", controller: (class: targetType, "anotherTestMethod"))
        ])
        DispatchQueue.global().async {
            Strcted.current.boot()
        }
        XCTAssertNotNil(Strcted.current.router.controller(with: targetType))
        XCTAssert(Strcted.current.router.controller(with: targetType)?.testState == true)
    }
}
