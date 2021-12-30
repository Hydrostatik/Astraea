//
//  Foldable.swift
//  
//
//  Created by Manaswi Daksha on 12/29/21.
//

/// The **Foldable** typeclass abstracts over containers which
/// can be "folded" into a summary value. This allows such
/// folding operations to be written in a container-agnostic way.
public protocol Foldable {
    associatedtype A

    /// Converts a container of values to a container of monoidal values
    /// Then uses `mappend` to provide a summary.
    static func foldMap<B: Monoid>(_ a: Self,
                                   _ f: @escaping (Self.A) -> B) -> B

    /// A generalization of the reduce function provided for Array.
    static func fold<B>(_ initial: B,
                        _ container: Self,
                        _ f : @escaping (B, Self.A) -> B) -> B
}
