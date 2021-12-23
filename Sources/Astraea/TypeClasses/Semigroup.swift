//
//  Semigroup.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

precedencegroup SemigroupGroup {
    higherThan: PipeGroup
}
infix operator <>
/// The **Semigroup** typeclass represents a set with an associative binary operation.
///
/// Any datatype which has an associative binary operation will be able to become
/// a member of the **Semigroup** datatype.
///
/// **Semigroup Laws:**
///
/// * The binary operation must be associative:
/// ```
/// (a <> b) <> c == a <> (b <> c)
/// ```
///
/// **NOTES:**
///
/// * Wrappers will always be associative if the wrapped type is a Semigroup and also associative
/// * Check the implementation of Optional to see how to conform to Semigroup on Types that wrap.
public protocol Semigroup {
    /// The "combine" operator
    static func <>(a: Self, b: Self) -> Self
}

public extension Semigroup {
    /// Prefix synonym of the infix operator <>
    static func combine(_ a: Self,_ b: Self) -> Self { a <> b }
}
