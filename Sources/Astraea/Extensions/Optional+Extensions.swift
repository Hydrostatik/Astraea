//
//  Optional+Extensions.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

extension Optional: Semigroup where Wrapped: Semigroup {
    public static func <> (a: Optional<Wrapped>, b: Optional<Wrapped>) -> Optional<Wrapped> {
        switch (a, b) {
        case (.some(let value), nil):
            return value
        case (nil, .some(let value)):
            return value
        case (.some(let val1), .some(let val2)):
            return val1 <> val2
        case (.none, .none):
            return nil
        }
    }
}

extension Optional: Monoid where Wrapped: Semigroup {
    public static var mempty: Optional<Wrapped> { nil }
}

extension Optional: Functor {
    public typealias A = Wrapped

    public static func <&> <B>(f: @escaping (A) -> B, a: Optional<A>) -> Optional<B> {
        switch a {
        case .some(let value):
            return f <| value
        case .none:
            return nil
        }
    }

    public static func fmap <B>(_ a: Optional<A>, _ f: @escaping (A) -> B) -> Optional<B> {
        f <&> a
    }

    public static func <& <B>(a: A, b: Optional<B>) -> Optional<A> {
        { _ in a } <&> b
    }
}

extension Optional: Applicative {
    public static func pure(_ a: A) -> Optional<A> { .some(a) }

    public static func <*> <B>(a: Optional<(A) -> B>, b: Optional<A>) -> Optional<B> {
        switch a {
        case .some(let f):
            return f <&> b
        case .none:
            return nil
        }
    }

    public static func liftA2 <A,B,C>(_ f: @escaping (A) -> ((B) -> C), _ a: Optional<A>, _ b: Optional<B>) -> Optional<C> {
        f <&> a <*> b
    }

    public static func <* <B>(a: Optional<A>, b: Optional<B>) -> Optional<A> {
        liftA2({ input in { _ in input }}, a, b)
    }

    public static func *> <B>(a: Optional<A>, b: Optional<B>) -> Optional<B> {
        { x in x } <& a <*> b
    }
}

extension Optional: Alternative {
    public static var empty: Optional<A> { nil }

    public static func <|> (a: Optional<A>, b: Optional<A>) -> Optional<A> {
        switch (a,b) {
        case (.some(let val1), _):
            return val1
        case (.none, .some(let val2)):
            return val2
        case (.none, .none):
            return nil
        }
    }
}
