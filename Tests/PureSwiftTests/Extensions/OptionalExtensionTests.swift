//
//  OptionalExtensionTests.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

import XCTest
@testable import PureSwift

final class OptionalExtensionTests: XCTestCase {

    func testSemigroup_AssociativityLaw() {
        XCTAssertEqual((Optional(1) <> Optional(2)) <> Optional(3), Optional(1) <> (Optional(2) <> Optional(3)))
        XCTAssertEqual(
            Optional<Int>.combine(Optional<Int>.combine(Optional(1), Optional(2)), Optional(3)),
            Optional<Int>.combine(Optional(1), Optional<Int>.combine(Optional(2), Optional(3)))
        )
    }

    func testMonoid_Mempty() {
        XCTAssertEqual(Optional<Int>.mempty, nil)
    }

    func testMonoid_MConcat() {
        XCTAssertEqual(Optional.mconcat([Optional(1), Optional(2), nil, Optional(3), Optional(4), nil]), Optional(10))
    }

    func testMonoid_IdentityLaw() {
        XCTAssertEqual(Optional(3) <> Optional<Int>.mempty, Optional<Int>.mempty <> Optional(3))
    }

    func testFunctor_Fmap() {
        XCTAssertEqual(String.init <&> Optional(3), Optional("3"))
    }

    func testFunctor_ReplaceMap() {
        XCTAssertEqual("This is Sparta" <& Optional(3), Optional("This is Sparta"))
    }
}

extension Int: Semigroup {
    public static func <> (a: Int, b: Int) -> Int {
        a + b
    }
}
