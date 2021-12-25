//
//  Functor.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

precedencegroup MapGroup {
    higherThan: AmapGroup
}
infix operator <&>: MapGroup
infix operator <&: MapGroup
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
public protocol Functor {
    associatedtype A
    static func <&> <B>(f: @escaping (A) -> B, a: Self) -> Self where Self.A == B
}
