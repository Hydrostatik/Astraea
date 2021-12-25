//
//  GlobalFunctions.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

precedencegroup PipeGroup {
    associativity: right
    higherThan: MapGroup
    lowerThan: LogicalConjunctionPrecedence
}
infix operator <|: PipeGroup
public func <| <A,B>(f: (A) -> B, a: A) -> B { f(a) }

precedencegroup ComposeGroup {
    associativity: right
    higherThan: SemigroupGroup
}
infix operator <+ : ComposeGroup
public func <+ <A,B,C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> ((A) -> C) {
    { a in
        f(g(a))
    }
}
