//
//  OptionalExtensionTests.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

import PureSwift
import XCTest

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
        XCTAssertEqual(Optional.fmap(Optional(3)) { x in String.init <| x } , Optional("3"))
    }

    func testFunctor_ReplaceMap() {
        XCTAssertEqual("This is Sparta" <& Optional.init <| 3, Optional.init <| "This is Sparta")
    }

    func testFunctor_IdentityLaw() {
        XCTAssertEqual({ x in x } <&> Optional("Sparta"), Optional("Sparta"))
    }

    func testFunctor_CompositionLaw() {
        let f: (Int) -> String = { x in String.init <| x }
        let g: (Bool) -> Int = { x in x ? 50 : 100 }
        let x = Optional(false)

        XCTAssertEqual((f <+ g) <&> x, f <&> (g <&> x))
    }

    func testApplicativeFunctor_Pure() {
        XCTAssertEqual(Optional.pure <| 3, Optional.init <| 3)
    }

    func testApplicativeFunctor_Amap() {
        let given: Optional<(Int) -> String> = { x in
            String.init <| 4 * x 
        }

        let sut1: Optional<Int> = 4
        let sut2: Optional<Int> = nil

        XCTAssertEqual(given <*> sut1, "16")
        XCTAssertEqual(given <*> sut2, nil)
    }

    func testApplicativeFunctor_LeftApply() {
        XCTAssertEqual(Optional(4) <* Optional("String"), Optional(4))
    }

    func testApplicativeFunctor_RightApply() {
        XCTAssertEqual(Optional(4) *> Optional("String"), Optional("String"))
    }

    func testApplicativeFunctor_IdentityLaw() {
        XCTAssertEqual(Optional.pure <| { x in x } <*> Optional.init <| 3, Optional(3))
    }

    func testApplicativeFunctor_CompositionLaw() {
        let given1: Optional<(String) -> Bool> = { x in x.count > 3 }
        let given2: Optional<(Int) -> String> = { x in String.init <| 80 * x }
        let given3: Optional<Int> = 20

        XCTAssertEqual(Optional.pure <| { f in { g in f <+ g }} <*> given1 <*> given2 <*> given3, given1 <*> (given2 <*> given3))
    }

    func testApplicativeFunctor_HomomorphismLaw() {
        XCTAssertEqual(Optional.pure <| { (x: Int) in Double.init <| 2 * x } <*> Optional.pure <| 3, Optional.pure <| { (x: Int) in Double.init <| 2 * x } <| 3)
    }

    func testApplicativeFunctor_InterchangeLaw() {
        XCTAssertEqual(Optional.init <| { x in x * 20 } <*> Optional.pure <| 30, Optional.pure <| { f in f <| 30 } <*> Optional.init <| { x in x * 20 })
    }

    func testAlternativeFunctor_Empty() {
        XCTAssertEqual(Optional<Int>.empty, nil)
    }

    func testAlternativeFunctor_PipeOnFail() {
        XCTAssertEqual(Optional(3) <|> nil, Optional(3))
        XCTAssertEqual(nil <|> Optional("This"), Optional("This"))
        XCTAssertEqual(Optional(8) <|> Optional(7), Optional(8))
    }
}

extension Int: Semigroup {
    public static func <> (a: Int, b: Int) -> Int {
        a + b
    }
}
