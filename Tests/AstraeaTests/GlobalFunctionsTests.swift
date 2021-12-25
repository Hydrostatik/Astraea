//
//  GlobalFunctionsTests.swift
//  
//
//  Created by Manaswi Daksha on 12/24/21.
//

import Astraea
import XCTest

final class GlobalFunctionsTests: XCTestCase {
    func testPipeLeft() {
        XCTAssertEqual( { x in "This is the value: \(x)" } <| String.init <| { x in 20 * x } <| 20, "This is the value: 400")
    }

    func testComposeLeft() {
        let f: (Int) -> Bool = { x in x > 10 }
        let g: (String) -> Int = { x in x.count }
        let h: (Double) -> String = { x in String(x) }

        XCTAssertEqual(f <+ g <+ h <| 1234.2343, false)
    }
}
