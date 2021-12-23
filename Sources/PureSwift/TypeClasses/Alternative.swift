//
//  Alternative.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

infix operator <|>: AmapGroup
/// An **Alternative Functor** has more structure than an **Applicative Functor**.
public protocol Alternative: Applicative {
    /// Represents a computation with no valid results
    static var empty: Self { get }

    /// Combines two calculations and returns the first non-failing calculation or `empty` if all of them fail.
    static func <|> (a: Self, b: Self) -> Self 
}
