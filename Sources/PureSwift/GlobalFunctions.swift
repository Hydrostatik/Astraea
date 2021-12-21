//
//  GlobalFunctions.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

precedencegroup PipeGroup {
    associativity: right
    higherThan: MapGroup
}
infix operator <|: PipeGroup
func <| <A,B>(f: (A) -> B, a: A) -> B { f(a) }

precedencegroup ComposeGroup {
    higherThan: SemigroupGroup
}
infix operator && : ComposeGroup
func && <A,B,C>(g: @escaping (B) -> C, f: @escaping (A) -> B) -> ((A) -> C) {
    { a in
        g(f(a))
    }
}
