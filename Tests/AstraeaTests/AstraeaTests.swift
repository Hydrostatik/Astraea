//
//  AstraeaTests.swift
//  
//
//  Created by Manaswi Daksha on 12/24/21.
//

import Astraea
import XCTest

final class AstraeaTests: XCTestCase {
    typealias A = Astraea

    func testComposeLeft() {
        let f: (Int) -> Bool = { x in x > 10 }
        let g: (String) -> Int = { x in x.count }
        let h: (Double) -> String = { x in String(x) }

        XCTAssertEqual(A.compose(f, A.compose(g, h))(1234.2343), false)
    }

    func testArraySpan() {
        let a = [1,2,3,4]
        let b = [4,1,2,3,4]
        let c = [1,1,1,1,1]
        let d = Array<Int>()
        let e = [4]
        let f = [1]

        let expected = [([1,2], [3,4]), ([], [4,1,2,3,4]), ([1,1,1,1,1], []), ([], []), ([], [4]), ([1], [])]
        let output = { x in A.span(x, { x in x < 3 }) } <&> [a,b,c,d,e,f]

        XCTAssertTrue(
            ({ (x,_) in x } <&> expected) == ({ (x,_) in x } <&> output)
            && ({ (_,y) in y } <&> expected) == ({ (_,y) in y } <&> output)
        )
    }

    func testStringSpan() {
        let a = "abcd"
        let b = "cabcd"
        let c = "aaaaa"
        let d = ""
        let e = "c"
        let f = "a"

        let expected = [("ab","cd"),("","cabcd"),("aaaaa",""),("",""),("","c"),("a","")]
        let output: Array<(String, String)> = { x in A.span(x, { x in x != "c" }) } <&> [a,b,c,d,e,f]

        XCTAssertTrue(
            ({ (x,_) in x } <&> expected) == ({ (x,_) in x } <&> output)
            && ({ (_,y) in y } <&> expected) == ({ (_,y) in y } <&> output)
        )
    }

    func testID() {
        let a = "String"
        let b = 2
        let c = 2.34
        let d = [2]
        let e = Optional("Something")

        XCTAssertEqual(A.id(a), a)
        XCTAssertEqual(A.id(b), b)
        XCTAssertEqual(A.id(c), c)
        XCTAssertEqual(A.id(d), d)
        XCTAssertEqual(A.id(e), e)
    }

    func testConst() {
        let a = "String"
        let b = 2
        let c = [2]
        let d = Optional("Something")

        XCTAssertEqual(A.const(a, b), a)
        XCTAssertEqual(A.const(c, d), c)
    }

    func testCurry() {
        func f(val: (String, String)) -> String {
            val.0 + val.1
        }

        XCTAssertEqual(A.curry("This is ", "Sparta", f), "This is Sparta")
    }

    func testUncurry() {
        let f: (String, String) -> String = { x, y in x + y }

        XCTAssertEqual(A.uncurry(("This is ", "Sparta"), f), "This is Sparta")
    }

    func testUncurry3() {
        let f: (Int, Int, Int) -> Int = { x, y, z in x + y * z }

        XCTAssertEqual(A.uncurry3((1,4,5), f), 21)
    }
}
