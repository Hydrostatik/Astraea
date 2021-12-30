//
//  String+ExtensionTests.swift
//  
//
//  Created by Manaswi Daksha on 12/29/21.
//

import Astraea
import XCTest

final class StringExtensionTests: XCTestCase {
    typealias A = Astraea

    func testSemigroup_AssociativityLaw() {
        let a = "something "
        let b = "something else "
        let c = "some other thing"

        XCTAssertEqual((a <> b) <> c, a <> (b <> c))
    }

    func testMonoid_Mempty() {
        XCTAssertEqual(String.mempty, "")
    }

    func testMonoid_Mconcat() {
        let a = ["This ", "is ", "imaginative."]
        let b = "This is imaginative."

        XCTAssertEqual(A.mconcat(a), b)
    }

    func testMonoid_IdentityLaw() {
        let a = "something"

        XCTAssertEqual(a <> String.mempty, a)
    }
}
