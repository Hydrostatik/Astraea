//
//  Result+Extensions.swift
//  
//
//  Created by Manaswi Daksha on 12/22/21.
//

extension Result: Semigroup where Success: Semigroup {
    public static func <> (a: Result<Success,Failure>, b: Result<Success,Failure>) -> Result<Success,Failure> {
        switch (a, b) {
        case (.success(let val1), .success(let val2)):
            return .success(val1 <> val2)
        case (.success(let val1), _):
            return .success(val1)
        case (_, .success(let val2)):
            return .success(val2)
        case (.failure(let err1), _):
            return .failure(err1)
        }
    }
}

extension Result: Functor {
    public typealias A = Success

    public static func <&> <B>(f: @escaping (A) -> B, a: Result<A, Failure>) -> Result<B, Failure> {
        switch a {
        case .success(let value):
            return .success(f <| value)
        case .failure(let error):
            return .failure(error)
        }
    }

    public static func fmap <B>(_ a: Result<A, Failure>, _ f: @escaping (A) -> B) -> Result<B, Failure> {
        f <&> a
    }

    public static func <& <B>(a: A, b: Result<B, Failure>) -> Result<A, Failure> {
        { _ in a } <&> b
    }
}

extension Result: Applicative {
    public static func pure(_ a: A) -> Result<A, Failure> { .success(a) }

    public static func <*> <B>(a: Result<(A) -> B, Failure>, b: Result<A, Failure>) -> Result<B, Failure> {
        switch a {
        case .success(let f):
            return f <&> b
        case .failure(let error):
            return .failure(error)
        }
    }

    public static func liftA2 <A,B,C>(_ f: @escaping (A) -> ((B) -> C), _ a: Result<A, Failure>, _ b: Result<B, Failure>) -> Result<C, Failure> {
        f <&> a <*> b
    }

    public static func <* <B>(a: Result<A, Failure>, b: Result<B, Failure>) -> Result<A, Failure> {
        liftA2({ input in { _ in input }}, a, b)
    }

    public static func *> <B>(a: Result<A, Failure>, b: Result<B, Failure>) -> Result<B, Failure> {
        { x in x } <& a <*> b
    }
}
