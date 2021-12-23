//
//  ResultExtensionTests.swift
//  
//
//  Created by Manaswi Daksha on 12/23/21.
//

import PureSwift
import XCTest

final class ResultExtensionTests: XCTestCase {
    func testSemigroup_AssociativityLaw() {
        let a: Result<Int, MockError> = .success(1)
        let b: Result<Int, MockError> = .success(2)
        let c: Result<Int, MockError> = .success(3)

        XCTAssertEqual((a <> b) <> c, a <> (b <> c))
        XCTAssertEqual(
            Result<Int, MockError>.combine(Result<Int, MockError>.combine(a, b), c), Result<Int, MockError>.combine(a, Result<Int, MockError>.combine(b, c))
        )
    }

    func testFunctor_Fmap() {
        let a: Result<Int, MockError> = .success(10)
        let b: Result<String, MockError> = .success("200")

        XCTAssertEqual({ x in String.init <| 20 * x } <&> a, b)
        XCTAssertEqual(Result.fmap(a) { x in String.init <| 20 * x }, b)
    }

    func testFunctor_ReplaceMap() {
        let a: Result<Int, MockError> = .success(10)
        let b: String = "200"
        let c: Result<String, MockError> = .success(b)

        XCTAssertEqual(b <& a, c)
    }

    func testFunctor_IdentityLaw() {
        let a: Result<Int, MockError> = .success(10)

        XCTAssertEqual({ x in x } <&> a, a)
    }

    func testFunctor_CompositionLaw() {
        let f: (Int) -> String = { x in String.init <| x }
        let g: (Bool) -> Int = { x in x ? 50 : 100 }
        let x: Result<Bool, MockError> = .success(false)

        XCTAssertEqual((f <+ g) <&> x, f <&> (g <&> x))
    }

    func testApplicativeFunctor_Pure() {
        let a: Int = 3
        let b: Result<Int, MockError> = .success(a)
        XCTAssertEqual(Result.pure(a), b)
    }

    func testApplicativeFunctor_Amap() {
        let f: Result<(Int) -> String, MockError> = .success({ x in
            String.init <| 4 * x
        })

        let a: Result<Int, MockError> = .success(4)
        let b: Result<Int, MockError> = .failure(.someRandomError)

        XCTAssertEqual(f <*> a, .success("16"))
        XCTAssertEqual(f <*> b, .failure(.someRandomError))
    }

    func testApplicativeFunctor_LeftApply() {
        let a: Result<Int, MockError> = .success(4)
        let b: Result<String, MockError> = .success("String")

        XCTAssertEqual(a <* b, a)
    }

    func testApplicativeFunctor_RightApply() {
        let a: Result<Int, MockError> = .success(4)
        let b: Result<String, MockError> = .success("String")

        XCTAssertEqual(a *> b, b)
    }

    func testApplicativeFunctor_IdentityLaw() {
        let a: Result<Int, MockError> = .success(3)

        XCTAssertEqual(Result.pure <| { x in x } <*> a, a)
    }

    func testApplicativeFunctor_CompositionLaw() {
        let f: Result<(String) -> Bool, MockError> = .success({ x in x.count > 3 })
        let g: Result<(Int) -> String, MockError> = .success({ x in String.init <| 80 * x })
        let x: Result<Int, MockError> = .success(20)

        XCTAssertEqual(Result.pure <| { f in { g in f <+ g }} <*> f <*> g <*> x, f <*> (g <*> x))
    }

    func testApplicativeFunctor_HomomorphismLaw() {
        XCTAssertEqual(
            Result.pure { (x: Int) in Double.init <| 2 * x } <*> Result.pure <| 3, Result<Double, MockError>.pure <| { (x: Int) in Double.init <| 2 * x } <| 3
        )
    }

    func testApplicativeFunctor_InterchangeLaw() {
        let f: Result<(Int) -> Int, MockError> = .success({ x in x * 20 })
        XCTAssertEqual(f <*> Result.pure <| 30, Result.pure <| { f in f <| 30 } <*> f)
    }
}

enum MockError: Error {
    case someRandomError
    case someOtherRandomError
}
