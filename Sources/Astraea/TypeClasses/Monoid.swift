//
//  Monoid.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

/// The **Monoid** typeclass is a class for types which
/// have a single most natural operation for combining values,
/// together with a value which doesn't do anything when you combine
/// it with others (the *identity* element).
///
/// It is closely related to the **Foldable** typeclass.
///
/// **Monoid Laws**
///
/// * Operating a value with the identity should return the value exactly:
/// ```
/// x <> mempty = x
/// mempty <> x = x
/// ```
///
/// * The binary operation must be associative:
/// ```
/// (a <> b) <> c == a <> (b <> c)
/// ```
public protocol Monoid: Semigroup {
    static var mempty: Self { get }
}

extension Astraea {
    /// Generalizes `.reduce([], +)` or `.reduce(0,+)` to work for all **Monoids**.
    ///
    /// Check the **Monoid** documentation to see relevant requirements and laws.
    public static func mconcat<A: Monoid>(_ vals: [A]) -> A {
        vals.reduce(A.mempty, <>)
    }
}
