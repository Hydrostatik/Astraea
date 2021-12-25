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
}
