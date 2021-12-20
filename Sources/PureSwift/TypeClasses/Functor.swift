//
//  Functor.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

infix operator <&>
infix operator <&
/// The **Functor** typeclass represents a mapping between categories in the context of
/// category theory.
///
/// In practice, a **Functor** represents a type that can be mapped over.
///
/// **Functor Laws**
///
/// * Functors must preserve identity morphisms:
/// ```
/// fmap(value) { x in x } = value
/// ```
///
/// * Functors must preserve composition of morphisms:
/// ```
/// fmap(value, f && g) = fmap(fmap(value, g), f)
/// ```
protocol Functor {
    associatedtype A
    static func <&> <B>(f: @escaping (A) -> B, a: Self) -> Self where Self.A == B
}

extension Functor {
    static func fmap <B>(_ a: Self,_ f: @escaping (A) -> B) -> Self where Self.A == B {
        f <&> a
    }

    static func <& (a: Self.A, b: Self) -> Self {
        { _ in a } <&> b
    }
}
