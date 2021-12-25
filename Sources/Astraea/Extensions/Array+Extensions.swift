//
//  Array+Extensions.swift
//  
//
//  Created by Manaswi Daksha on 12/23/21.
//

extension Array: Semigroup {
    public static func <> (a: Array<Element>, b: Array<Element>) -> Array<Element> { a + b }
}

extension Array: Monoid {
    public static var mempty: Array<Element> { [] }
}

extension Array: Functor {
    public typealias A = Element

    public static func <&> <B>(f: @escaping (A) -> B, a: Array<A>) -> Array<B> {
        a.map {
            f <| $0
        }
    }

    public static func <& <B>(a: A, b: Array<B>) -> Array<A> {
        { _ in a } <&> b
    }
}

extension Array: Applicative {
    public static func pure(_ a: A) -> Array<A> { [a] }

    public static func <*> <B>(a: Array<(A) -> B>, b: Array<A>) -> Array<B> {
        ({ x in { f in f <| x } <&> a } <&> b).reduce([], +)
    }

    public static func <* <B>(a: Array<A>, b: Array<B>) -> Array<A> {
        Astraea.liftA2({ input in { _ in input }}, a, b)
    }

    public static func *> <B>(a: Array<A>, b: Array<B>) -> Array<B> {
        Astraea.id <& a <*> b
    }
}

extension Array: Alternative {
    public static var empty: Array<Element> { [] }

    public static func <|> (a: Array<Element>, b: Array<Element>) -> Array<Element> {
        if !a.isEmpty {
            return a
        } else if !b.isEmpty {
            return b
        }

        return []
    }
}

extension Astraea {
    /// Prefix synonym of the `<&>` operator. Transforms a wrapped value given a function; analagous to `map` for Array.
    ///
    /// Check the **Functor** documentation to see relevant requirements and laws.
    public static func fmap<A,B>(_ a: Array<A>, _ f: @escaping (A) -> B) -> Array<B> { f <&> a }

    /// Prefix synonym of the `<&` operator. Replaces a wrapped value with another value.
    public static func rmap<A,B>(_ a: A, _ b: Array<B>) -> Array<A> { a <& b }

    /// Prefix synonym of the `<*>` operator. Applies a wrapped transformation to a wrapped value.
    ///
    /// Check the **Applicative Functor** documentation to see relevant requirements and laws.
    public static func amap<A,B>(_ a: Array<(A) -> B>, _ b: Array<A>) -> Array<B> { a <*> b }

    /// Lifts wrapped values of type A, B out of their context, applies the transformation and returns a wrapped value.
    public static func liftA2 <A,B,C>(_ f: @escaping (A) -> ((B) -> C), _ a: Array<A>, _ b: Array<B>) -> Array<C> { f <&> a <*> b }

    /// Computes a and b, ignores the output of b and returns a
    public static func left<A,B>(_ a: Array<A>, _ b: Array<B>) -> Array<A> { a <* b }

    /// Computes a and b, ignores the output of a and return b
    public static func right<A,B>(_ a: Array<A>, _ b: Array<B>) -> Array<B> { a *> b }

    /// Returns the first non-empty value, if both are empty, then returns empty.
    ///
    /// Check the **Alternative Functor** documentation to see relevant requirements and laws.
    public static func alt<A>(_ a: Array<A>, _ b: Array<A>) -> Array<A> { a <|> b }
}
