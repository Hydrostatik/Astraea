//
//  Array+Extensions.swift
//  
//
//  Created by Manaswi Daksha on 12/23/21.
//

extension Array: Semigroup {
    public static func <> (a: Array<Element>, b: Array<Element>) -> Array<Element> {
        a + b
    }
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

    public static func fmap <B>(_ a: Array<A>, _ f: @escaping (A) -> B) -> Array<B> {
        f <&> a
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

    public static func liftA2 <A,B,C>(_ f: @escaping (A) -> ((B) -> C), _ a: Array<A>, _ b: Array<B>) -> Array<C> {
        f <&> a <*> b
    }

    public static func <* <B>(a: Array<A>, b: Array<B>) -> Array<A> {
        liftA2({ input in { _ in input }}, a, b)
    }

    public static func *> <B>(a: Array<A>, b: Array<B>) -> Array<B> {
        { x in x } <& a <*> b
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
