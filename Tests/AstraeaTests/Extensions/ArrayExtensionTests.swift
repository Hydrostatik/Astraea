//
//  ArrayExtensionTests.swift
//  
//
//  Created by Manaswi Daksha on 12/23/21.
//

import Astraea
import XCTest

final class ArrayExtensionTests: XCTestCase {
    typealias A = Astraea

    func testSemigroup_AssociativityLaw() {
        let a = [1]
        let b = [2]
        let c = [3]

        XCTAssertEqual((a <> b) <> c, a <> (b <> c))
    }

    func testMonoid_Mempty() {
        XCTAssertEqual(Array<Int>.mempty, [])
    }

    func testMonoid_MConcat() {
        let a = [[1], [2], [3,4], [5,6,7]]
        let b = [1,2,3,4,5,6,7]
        XCTAssertEqual(A.mconcat(a), b)
    }

    func testMonoid_IdentityLaw() {
        let a = [1]
        XCTAssertEqual(a <> Array.mempty, a)
    }

    func testFunctor_Fmap() {
        let a = [3]
        let b = ["3"]

        XCTAssertEqual(String.init <&> a, b)
        XCTAssertEqual(A.fmap(a) { x in String.init <| x }, b)
    }

    func testFunctor_ReplaceMap() {
        let a = [4, 5, 6]
        let b = ["this", "that", "other"]
        let c = [[4,5,6], [4,5,6], [4,5,6]]

        XCTAssertEqual(a <& b, c)
        XCTAssertEqual(A.rmap(a, b), c)
    }

    func testFunctor_IdentityLaw() {
        let a = [10]

        XCTAssertEqual({ x in x } <&> a, a)
    }

    func testFunctor_CompositionLaw() {
        let f: (Int) -> String = { x in String.init <| x }
        let g: (Bool) -> Int = { x in x ? 50 : 100 }
        let x = [false]

        XCTAssertEqual((f <+ g) <&> x, f <&> (g <&> x))
    }

    func testApplicativeFunctor_Pure() {
        let a = 3
        let b = [a]
        XCTAssertEqual(Array.pure(a), b)
    }

    func testApplicativeFunctor_Amap() {
        let f: Array<(Int) -> String> = [ { x in
            String.init <| 4 * x
        }]

        let a: Array<Int> =  [4]
        let b: Array<Int> = []

        XCTAssertEqual(f <*> a, ["16"])
        XCTAssertEqual(A.amap(f, a), ["16"])
        XCTAssertEqual(f <*> b, [])
        XCTAssertEqual(A.amap(f, b), [])
    }

    func testApplicativeFunctor_LeftApply() {
        let a = [4]
        let b = ["String"]

        XCTAssertEqual(a <* b, a)
        XCTAssertEqual(A.left(a, b), a)
    }

    func testApplicativeFunctor_RightApply() {
        let a = [4]
        let b = ["String"]

        XCTAssertEqual(a *> b, b)
        XCTAssertEqual(A.right(a, b), b)
    }

    func testApplicativeFunctor_IdentityLaw() {
        let a = [3]

        XCTAssertEqual(Array.pure <| { x in x } <*> a, a)
    }

    func testApplicativeFunctor_CompositionLaw() {
        let f: Array<(String) -> Bool> = [ { x in x.count > 3 }]
        let g: Array<(Int) -> String> = [ { x in String.init <| 80 * x }]
        let x: Array<Int> = [20]

        XCTAssertEqual(Array.pure <| { f in { g in f <+ g }} <*> f <*> g <*> x, f <*> (g <*> x))
    }

    func testApplicativeFunctor_HomomorphismLaw() {
        XCTAssertEqual(
            Array.pure { (x: Int) in Double.init <| 2 * x } <*> Array.pure <| 3,
            Array.pure <| { (x: Int) in Double.init <| 2 * x } <| 3
        )
    }

    func testApplicativeFunctor_InterchangeLaw() {
        let f: Array<(Int) -> Int> = [ { x in x * 20 }]

        XCTAssertEqual(f <*> Array.pure <| 30, Array.pure <| { f in f <| 30 } <*> f)
    }

    func testAlternativeFunctor_Empty() {
        XCTAssertEqual(Array<Int>.empty, [])
    }

    func testAlternativeFunctor_PipeOnFail() {
        XCTAssertEqual([3] <|> [], [3])
        XCTAssertEqual([] <|> ["This"], ["This"])
        XCTAssertEqual([8] <|> [7], [8])
        XCTAssertEqual(Array<Int>.empty <|> Array<Int>.empty, [])
        XCTAssertEqual(A.alt([], [8]), [8])
    }

    func testFoldable_foldMap() {
        let container: [UInt8] = [1,2,3,3,4,5,5]
        let f: (UInt8) -> Int = { x in Int(x) }

        XCTAssertEqual(Array.foldMap(container, f), 23)
    }

    func testFoldable_fold() {
        let container: [String] = ["This", "is", "Sparta"]
        let f: (UInt, String) -> UInt = { x, y in x + UInt(y.count) }
        let initial: UInt = 0

        XCTAssertEqual(Array.fold(initial, container, f), 12)
    }
}
