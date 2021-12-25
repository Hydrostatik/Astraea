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

    public static func <& <B>(a: A, b: Result<B, Failure>) -> Result<A, Failure> {
        { _ in a } <&> b
    }
}

extension Result: Applicative {
    /// Wraps a value inside the Result context.
    public static func pure(_ a: A) -> Result<A, Failure> { .success(a) }

    public static func <*> <B>(a: Result<(A) -> B, Failure>, b: Result<A, Failure>) -> Result<B, Failure> {
        switch a {
        case .success(let f):
            return f <&> b
        case .failure(let error):
            return .failure(error)
        }
    }

    public static func <* <B>(a: Result<A, Failure>, b: Result<B, Failure>) -> Result<A, Failure> {
        Astraea.liftA2({ input in { _ in input }}, a, b)
    }

    public static func *> <B>(a: Result<A, Failure>, b: Result<B, Failure>) -> Result<B, Failure> {
        Astraea.id <& a <*> b
    }
}

extension Astraea {
    /// Prefix synonym of the `<&>` operator. Transforms a wrapped value given a function; analagous to `map` for Array.
    ///
    /// Check the **Functor** documentation to see relevant requirements and laws.
    public static func fmap<A,Failure,B>(_ a: Result<A, Failure>, _ f: @escaping (A) -> B) -> Result<B, Failure> { f <&> a }

    /// Prefix synonym of the `<&` operator. Replaces a wrapped value with another value.
    public static func rmap<A,Failure,B>(_ a: A, _ b: Result<B,Failure>) -> Result<A,Failure> { a <& b }

    /// Prefix synonym of the `<*>` operator. Applies a wrapped transformation to a wrapped value.
    ///
    /// Check the **Applicative Functor** documentation to see relevant requirements and laws.
    public static func amap<A,Failure,B>(_ a: Result<(A) -> B, Failure>, _ b: Result<A, Failure>) -> Result<B, Failure> { a <*> b }

    /// Lifts wrapped values of type A, B out of their context, applies the transformation and returns a wrapped value.
    public static func liftA2 <A,Failure,B,C>(_ f: @escaping (A) -> ((B) -> C), _ a: Result<A, Failure>, _ b: Result<B,Failure>) -> Result<C,Failure> {
        f <&> a <*> b
    }

    /// Computes a and b, ignores the output of b and returns a
    public static func left<A,Failure,B>(_ a: Result<A,Failure>, _ b: Result<B,Failure>) -> Result<A,Failure> { a <* b }

    /// Computes a and b, ignores the output of a and return b
    public static func right<A,Failure,B>(_ a: Result<A,Failure>, _ b: Result<B, Failure>) -> Result<B, Failure> { a *> b }
}
