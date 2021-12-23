//
//  Applicative.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

precedencegroup AmapGroup {
    associativity: left
}
infix operator <*>: AmapGroup
infix operator *>: AmapGroup
infix operator <*: AmapGroup
/// An **Applicative Functor** has more structure than a **Functor**.
///
/// It can:
/// * embed pure expressions
/// * sequence computations and combine their results.
///
/// **WARNING:** Please note that amap or <*> needs to be implemented.
/// But cannot be required due to constraints of Swift and how it handles generics in protocols.
/// The function that needs to be implemented is defined as:
/// ```swift
/// static func <*> <B>(a: Implementation<(A) -> B>, b: Implementation<A>) -> Implementation<B>
/// ```
///
/// **Applicative Functor Laws: **
/// * Identity:
/// ```
/// pure { x in x } <*> v = v
/// ```
/// * Composition:
/// ```
/// pure (&&) <*> u <*> v <*> w = u <*> (v <*> w)
/// ```
/// * Homomorphism:
/// ```
/// pure f <*> pure x = pure (f x)
/// ```
/// * Interchange:
/// ```
/// u <*> pure y = pure { f in f(y) } <*> u
/// ```
public protocol Applicative: Functor {

    /// Embeds a pure expression inside itself. 
    static func pure(_ a: Self.A) -> Self

    /// Cannot be required since protocols don't support required notation
    /// static func amap<B>(_ a: Implementation<(A) -> B>, _ b: Implementation<A>) -> Implementation<B>
}
